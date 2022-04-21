`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2022 11:09:37 AM
// Design Name: 
// Module Name: dtc_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dtc_tx
(
    input                   rst,
    input                   dtc_clk,
    input                   dtc_clk_90,
    output                  dtc_data,
    output                  dtc_return,
    
    input                   rdocmd,
    output logic    [5:0]   adc_rd_addr,
    input           [63:0][11:0]    adc_data,
    
    input                   streq,
    input           [15:0]  status,
    
    input                   read,
    input           [31:0]  address,
    input           [31:0]  data,
    input                   data_vld
);

parameter reply_header 		= 16'hF7F7;		
parameter status_header 	= 16'hDCDC;
parameter event_header 		= 16'h5C5C;
parameter sync_word 		= 16'hBC50;
parameter event_end_flag 	= 16'hC5D5; //
parameter event_dummy 		= 16'h8012;

enum logic [7:0]    {   IDLE,
                        SEND_STATUS_HEADER,
                        SEND_STATUS,
                        SEND_DATA,
                        SEND_DATA_HEADER,
                        SEND_ADDRESS_HIGH,
                        SEND_ADDRESS_LOW,
                        SEND_DATA_HIGH,
                        SEND_DATA_LOW,
                        SEND_EVENT,
                        SEND_EVENT_HEADER,        
                        SEND_ADC,
                        SEND_TDC,
                        SEND_EVENT_TRAILER  } state = IDLE;

logic   dtc_data_0;
logic   dtc_data_1;

logic   dtc_return_0;
logic   dtc_return_1;

logic [3:0] dtc_out;

logic [1:0] dtc_out_cnt = 0;
logic       write_dtc_word;
logic [15:0]dtc_word = 0;

logic [5:0] ch_cnt = 0;
logic [5:0] sample_cnt = 0;
logic       done ;
logic [5:0] event_window = 40;

logic [1:0] tr_word_cnt = 0;

ODDR 
# (
        .DDR_CLK_EDGE       ("SAME_EDGE")
    ,   .SRTYPE             ("SYNC")
)
ODDR_dtc_data 
(
        .Q                  (dtc_data)
    ,   .C                  (dtc_clk)
    ,   .CE                 (1'b1)
    ,   .D1                 (dtc_data_0)
    ,   .D2                 (dtc_data_1)
    ,   .R                  (1'b0)
    ,   .S                  (1'b0)
);

ODDR 
# (
        .DDR_CLK_EDGE       ("SAME_EDGE")
    ,   .SRTYPE             ("SYNC")
)
ODDR_dtc_return 
(
        .Q                  (dtc_return)
    ,   .C                  (dtc_clk)
    ,   .CE                 (1'b1)
    ,   .D1                 (dtc_return_0)
    ,   .D2                 (dtc_return_1)
    ,   .R                  (1'b0)
    ,   .S                  (1'b0)
);

always_ff @(posedge dtc_clk) dtc_out_cnt <= dtc_out_cnt + 1;
assign write_dtc_word = (dtc_out_cnt == 0);
assign dtc_out = dtc_word[3:0];

always_ff @(posedge dtc_clk) {dtc_return_1, dtc_data_1, dtc_return_0 ,dtc_data_0} <= dtc_out;

always_ff @(posedge dtc_clk)
begin
    if(rst)
        state <= IDLE;
    else
    begin
        case(state)
            IDLE:
            begin
                if(rdocmd)          state <= SEND_EVENT;
                else if(read)       state <= SEND_DATA;
                else if(streq)      state <= SEND_STATUS_HEADER;
            end
            
            SEND_EVENT:                                             state <= SEND_EVENT_HEADER;
            SEND_EVENT_HEADER:  if(dtc_out_cnt == 3)                state <= SEND_ADC;
            SEND_ADC:           if((done) && (dtc_out_cnt == 3))    state <= SEND_TDC;
            SEND_TDC:           if((done) && (dtc_out_cnt == 3))    state <= SEND_EVENT_TRAILER;
            SEND_EVENT_TRAILER: if((done) && (dtc_out_cnt == 3))    state <= IDLE;
            
            SEND_DATA:          if(data_vld)            state <= SEND_DATA_HEADER;      
            SEND_DATA_HEADER:   if(dtc_out_cnt == 3)    state <= SEND_ADDRESS_HIGH;
            SEND_ADDRESS_HIGH:  if(dtc_out_cnt == 3)    state <= SEND_ADDRESS_LOW;
            SEND_ADDRESS_LOW:   if(dtc_out_cnt == 3)    state <= SEND_DATA_HIGH;
            SEND_DATA_HIGH:     if(dtc_out_cnt == 3)    state <= SEND_DATA_LOW;
            SEND_DATA_LOW:      if(dtc_out_cnt == 3)    state <= IDLE;
            
            SEND_STATUS_HEADER: if(dtc_out_cnt == 3)    state <= SEND_STATUS;
            SEND_STATUS:        if(dtc_out_cnt == 3)    state <= IDLE;
            
            default:                state <= IDLE;
        endcase
    end
end

always_ff @(posedge dtc_clk)
begin
    if(write_dtc_word)
    begin
        case(state)
            IDLE:               dtc_word <= sync_word;
            
            SEND_EVENT_HEADER:  dtc_word <= event_header;
            SEND_ADC:           dtc_word <= {{4{1'b0}}, adc_data[ch_cnt]};
            SEND_TDC:           dtc_word <= dtc_word;
            SEND_EVENT_TRAILER: dtc_word <= event_end_flag;
            
            SEND_DATA_HEADER:   dtc_word <= reply_header;
            SEND_ADDRESS_HIGH:  dtc_word <= address[31:16];
            SEND_ADDRESS_LOW:   dtc_word <= address[15:0];
            SEND_DATA_HIGH:     dtc_word <= data[31:16];
            SEND_DATA_LOW:      dtc_word <= data[15:0];
            
            SEND_STATUS_HEADER: dtc_word <= status_header;
            SEND_STATUS:        dtc_word <= status;
            
            default:            dtc_word <= sync_word;
        endcase
    end
    else
        dtc_word <= dtc_word >> 4;
end

always_ff @(posedge dtc_clk)
begin
    if(state == SEND_EVENT)
    begin
        ch_cnt <= 63;
        sample_cnt <= event_window;
    end
    else if(write_dtc_word)
    begin
        if(ch_cnt != 0)
        begin
            if(sample_cnt != 0)
                sample_cnt <= sample_cnt - 1;
            else
            begin
                sample_cnt <= event_window;
                ch_cnt <= ch_cnt - 1;
            end
        end
        else if(sample_cnt != 0)
            sample_cnt <= sample_cnt - 1;
    end
end

assign adc_rd_addr = sample_cnt;

always_ff @(posedge dtc_clk)
    if(state == IDLE)
        tr_word_cnt <= 1'b0;
    else if( (state == SEND_EVENT_TRAILER) && (write_dtc_word))
        tr_word_cnt <= tr_word_cnt + 1;
        
always_ff @(posedge dtc_clk)
begin
    if(dtc_out_cnt == 3)
        done <= 1'b0;
    else if((state == SEND_ADC) && ({ch_cnt ,sample_cnt} == 0))
        done <= 1'b1;
    else if(state == SEND_TDC)
        done <= 1'b1;
    else if((state == SEND_EVENT_TRAILER) && (tr_word_cnt == 3))
        done <= 1'b1;
end

endmodule
