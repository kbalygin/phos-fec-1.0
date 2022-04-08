`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 03:39:17 PM
// Design Name: 
// Module Name: ads52j90_readout
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


module ads52j90
(
    input                   rst,
    
    input                   dclk_p,
    input                   dclk_n,
    input                   adc_clk_x4,
    input                   adc_clk_x2,
    input                   adc_clk,
    
    input           [15:0]  adc_data_in_p,
    input           [15:0]  adc_data_in_n,
   
    output logic    [383:0] adc_data_out
);

logic [11:0] des_out        [15:0];
logic [11:0] des_out_buf    [15:0];

genvar i;
generate
    for(i = 0; i < 16; i = i + 1)
    begin : adc_ch
        deser_12 deser_12_inst
        (
                .rst            (rst)
            ,   .dclk_p         (dclk_p)
            ,   .dclk_n         (dclk_n)
            ,   .adc_clk_x4     (adc_clk_x4)
            ,   .adc_clk_x2     (adc_clk_x2)
            ,   .data_in_p      (adc_data_in_p[i])
            ,   .data_in_n      (adc_data_in_n[i])
            ,   .data_out       (des_out[i])
        );
        always_ff @(posedge adc_clk_x2)
            des_out_buf[i] <= des_out[i];
        always_ff @(posedge adc_clk)
            adc_data_out[24*i + 23: 24*i] <= {des_out[i], des_out_buf[i]};
    end
endgenerate

endmodule
