`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 09:47:27 AM
// Design Name: 
// Module Name: deser_12
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


module deser_12
(
    input                   rst,
    input                   dclk_p,
    input                   dclk_n,
    input                   adc_clk_x4,
    input                   adc_clk_x2,
    input                   data_in_p,
    input                   data_in_n,
    output logic    [11:0]  data_out
);

logic [11:0]    q;
logic           data_in;         

IBUFDS 
#(
        .IOSTANDARD ("LVDS") // Specify the output I/O standard
    ,   .DIFF_TERM  ("TRUE")
//   .SLEW("SLOW")           // Specify the output slew rate
)
sipm_input_inst
(
        .I          (data_in_p)
    ,   .IB         (data_in_n)
    ,   .O          (data_in)
);      

ISERDESE2
# (
        .DATA_RATE          ("DDR")
    ,   .DATA_WIDTH         (6)
    ,   .INTERFACE_TYPE     ("NETWORKING")
    ,   .DYN_CLKDIV_INV_EN  ("FALSE")
    ,   .DYN_CLK_INV_EN     ("FALSE")
    ,   .NUM_CE             (1)
    ,   .OFB_USED           ("FALSE")
    ,   .IOBDELAY           ("NONE")                                // Use input at D to output the data on Q
    ,   .SERDES_MODE        ("MASTER")
)
iserdese2_inst
(
        .Q1                 (q[0])
    ,   .Q2                 (q[1])
    ,   .Q3                 (q[2])
    ,   .Q4                 (q[3])
    ,   .Q5                 (q[4])
    ,   .Q6                 (q[5])
    ,   .Q7                 ()
    ,   .Q8                 ()
    ,   .SHIFTOUT1          ()
    ,   .SHIFTOUT2          ()
    ,   .BITSLIP            (1'b0)                             // 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
                                                           // The amount of BITSLIP is fixed by the DATA_WIDTH selection.
    ,   .CE1                (1'b1)                        // 1-bit Clock enable input
    ,   .CE2                (1'b0)                        // 1-bit Clock enable input
    ,   .CLK                (dclk_p)                      // Fast source synchronous clock driven by BUFIO
    ,   .CLKB               (~dclk_p)                      // Locally inverted fast 
    ,   .CLKDIV             (adc_clk_x4)                             // Slow clock from BUFR.
    ,   .CLKDIVP            (1'b0)
    ,   .D                  (data_in)                                    // 1-bit Input signal from IOB 
    ,   .DDLY               (1'b0)                                // 1-bit Input from Input Delay component 
    ,   .RST                (rst)                            // 1-bit Asynchronous reset only.
    ,   .SHIFTIN1           (1'b0)
    ,   .SHIFTIN2           (1'b0)
    // unused connections
    ,   .DYNCLKDIVSEL       (1'b0)
    ,   .DYNCLKSEL          (1'b0)
    ,   .OFB                (1'b0)
    ,   .OCLK               (1'b0)
    ,   .OCLKB              (1'b0)
    ,   .O                  ()                                   // unregistered output of ISERDESE1
);

always_ff @(posedge adc_clk_x4) q[11:6] <= q[5:0];

always_ff @(posedge adc_clk_x2) data_out <= q;
    
endmodule
