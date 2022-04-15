`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 04:36:32 PM
// Design Name: 
// Module Name: dtc
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


module dtc_phos_fec_v1
(
    input                   rst,
    input                   dtc_clk,
    input                   dtc_trig,
    input                   dtc_data,
    input                   dtc_return,
    
    output logic            trig_l0,
    output logic            trig_l1,
    
    input           [15:0]  status,
    
    output logic            rdocmd
);

//Fast commands
`define RDOCMD      8'hE2
`define SCLKSYNC    8'hE4
`define RJECTCMD    8'hEA
`define RSTCMD      8'hE8
`define STREQ       8'hE9
`define ARDOEND     8'hEF

`define SLOWCMD     8'hE1

logic [1:0] trigger_state = 2'b00;

enum logic [7:0]    {   IDLE,
                        GET_CMD,
                        READ_STATUS,
                        READ_REG,        
                        EVENT   } state = IDLE;
                        

logic   trig_1;
logic   trig_2;

logic   dtc_data_0;
logic   dtc_data_1;

logic   dtc_return_0;
logic   dtc_return_1;

logic [3:0] dtc_out;

logic [7:0] header_sh;

logic [71:0]data_from_sru;
logic [5:0] bits_cnt;

logic write;
logic read;

logic [31:0] address;
logic [31:0] data;

IDDR 
# (
        .DDR_CLK_EDGE       ("SAME_EDGE") // "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED"
    ,   .INIT_Q1            (1'b0) // Initial value of Q1: 1'b0 or 1'b1
    ,   .INIT_Q2            (1'b0) // Initial value of Q2: 1'b0 or 1'b1
    ,   .SRTYPE             ("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
)
IDDR_dtc_trig
(
        .Q1                 (trig_1) // 1-bit output for positive edge of clock
    ,   .Q2                 (trig_2) // 1-bit output for negative edge of clock
    ,   .C                  (dtc_clk) // 1-bit clock input
    ,   .CE                 (1'b1) // 1-bit clock enable input
    ,   .D                  (dtc_trig) // 1-bit DDR data input
    ,   .R                  (1'b0) // 1-bit reset
    ,   .S                  (1'b0) // 1-bit set
);

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

assign {dtc_return_1, dtc_data_1, dtc_return_0 ,dtc_data_0} = dtc_out;

always_ff @(posedge dtc_clk)
begin
    case(trigger_state)
    0:  if(trig_1)  trigger_state <= 1;
    
    1:  if(trig_1)  trigger_state <= 3;
        else        trigger_state <= 2;
        
    default         trigger_state <= 0;
    endcase
end

assign trig_l0 = (trigger_state == 2);
assign trig_l1 = (trigger_state == 3);

always_ff @(posedge dtc_clk)
    data_from_sru <= {data_from_sru[70:0], trig_2};

always_ff @(posedge dtc_clk)
begin
    if( (state == IDLE) && (data_from_sru[7:0] == `SLOWCMD) )
        bits_cnt <= 63;
    else if(bits_cnt != 0)
        bits_cnt <= bits_cnt - 1;    
end

always_ff @(posedge dtc_clk)
begin
    read <= 1'b0;
    write <= 1'b0;
    case(state)
        IDLE:
        begin
            case(data_from_sru[7:0])
                `SLOWCMD:   state <= GET_CMD;
                default:    state <= IDLE;
            endcase
        end
        GET_CMD:
        begin
            if(bits_cnt == 0)
            begin
                address <= {1'b0, data_from_sru[62:32]};
                data <= data_from_sru[31:0];
                if(data_from_sru[63])
                    read <= 1'b1;
                else
                    write <= 1'b1;
            end
        end
        default: state <= IDLE;
    endcase
end
endmodule
