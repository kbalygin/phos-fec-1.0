`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2022 10:26:26 AM
// Design Name: 
// Module Name: dtc_rx
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


module dtc_rx
(
    input               rst,
    input               dtc_clk_90,
    input               dtc_trig,
    
    output logic        trig_l0,
    output logic        trig_l1,
    
    output logic        rdocmd,
    output logic        sclksync,
    output logic        rjectcmd,
    output logic        rstcmd,
    output logic        streq,
    output logic        ardoend,
    
    output logic [31:0] address,
    output logic [31:0] data,
    output logic        write,
    output logic        read
);

//Fast commands
`define RDOCMD      8'hE2
`define SCLKSYNC    8'hE4
`define RJECTCMD    8'hEA
`define RSTCMD      8'hE8
`define STREQ       8'hE9
`define ARDOEND     8'hEF

//slow commands
`define SLOWCMD     8'hE1

logic           trig_1, trig_2;
logic [1:0]     trigger_state = 2'b00;

logic [71:0]    data_from_sru = 0;
logic [5:0]     bits_cnt = 0;

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
    ,   .C                  (dtc_clk_90) // 1-bit clock input
    ,   .CE                 (1'b1) // 1-bit clock enable input
    ,   .D                  (dtc_trig) // 1-bit DDR data input
    ,   .R                  (1'b0) // 1-bit reset
    ,   .S                  (1'b0) // 1-bit set
);

always_ff @(posedge dtc_clk_90)
begin
    case(trigger_state)
        0:  if(trig_1)  trigger_state <= 1;
    
        1:  if(trig_1)  trigger_state <= 3;
            else        trigger_state <= 2;
        
        default:        trigger_state <= 0;
    endcase
end

assign trig_l0 = (trigger_state == 2);
assign trig_l1 = (trigger_state == 3);

always_ff @(posedge dtc_clk_90) data_from_sru <= {data_from_sru[70:0], trig_2};

always_ff @(posedge dtc_clk_90)
begin
    if((data_from_sru[71:64] == `SLOWCMD) && (bits_cnt == 0))
        {address, data} <= data_from_sru[63:0];
    else if(bits_cnt != 0)
        bits_cnt <= bits_cnt - 1;
    else if(data_from_sru[7:0] == `SLOWCMD)
        bits_cnt <= 63;
end

always_ff @(posedge dtc_clk_90)
begin
    if((data_from_sru[71:64] == `SLOWCMD) && (bits_cnt == 0))
    begin
        if(data_from_sru[63])
            read <= 1'b1;
        else
            write <= 1'b1;
    end
    else
    begin
        read <= 1'b0;
        write <= 1'b0;
    end
end

always_ff @(posedge dtc_clk_90)
begin
    rdocmd      <= 0;
    sclksync    <= 0;
    rjectcmd    <= 0;
    rstcmd      <= 0;
    streq       <= 0;
    ardoend     <= 0;
    if((bits_cnt == 0) && (data_from_sru[71:64] != `SLOWCMD))
    begin
        case(data_from_sru[7:0])
            `RDOCMD:    rdocmd      <= 1'b1;
            `SCLKSYNC:  sclksync    <= 1'b1;
            `RJECTCMD:  rjectcmd    <= 1'b1;
            `RSTCMD:    rstcmd      <= 1'b1;
            `STREQ:     streq       <= 1'b1;
            `ARDOEND:   ardoend     <= 1'b1;
            default: ;
        endcase
    end
end

endmodule
