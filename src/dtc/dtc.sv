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
    input           rst,
    input           dtc_clk,
    input           dtc_trig,
    input           dtc_data,
    input           dtc_return,
    
    output logic    trig_l0,
    output logic    trig_l1
);

logic [1:0] trigger_state = 2'b00;

logic   trig_1;
logic   trig_2;

logic   dtc_data_0;
logic   dtc_data_1;

logic   dtc_return_0;
logic   dtc_return_1;

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

endmodule
