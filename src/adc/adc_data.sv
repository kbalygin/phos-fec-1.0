`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 02:55:59 PM
// Design Name: 
// Module Name: adc_data
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


module adc_data
(

    input                   rst,
    
    input   [1:0]           dclk_p,
    input   [1:0]           dclk_n,
    input                   adc_clk_x4,
    input                   adc_clk_x2,
    input                   adc_clk,
    
    input   [31:0]          adc_data_in_p,
    input   [31:0]          adc_data_in_n,
    
    output  [767:0]         adc_data_out,
    
    input   [5:0]           trigger_latency

);

logic [31:0][11:0]  adc_data_out_0;
logic [31:0][11:0]  adc_data_out_1;

logic [767:0]       adc_data_mapped;

logic [6:0] fifo_used;
logic       fifo_rd;
logic       fifo_wr;

ads52j90 ads52j90_inst_0
(
        .rst            (rst)
    
    ,   .dclk_p         (dclk_p)
    ,   .dclk_n         (dclk_n)
    ,   .adc_clk_x4     (adc_clk_x4)
    ,   .adc_clk_x2     (adc_clk_x2)
    ,   .adc_clk        (adc_clk)
    ,   .adc_data_in_p  (adc_data_in_p[15:0])
    ,   .adc_data_in_n  (adc_data_in_n[15:0])
    ,   .adc_data_out   (adc_data_out_0)
);

ads52j90 ads52j90_inst_1
(
        .rst            (rst)
    
    ,   .dclk_p         (dclk_p)
    ,   .dclk_n         (dclk_n)
    ,   .adc_clk_x4     (adc_clk_x4)
    ,   .adc_clk_x2     (adc_clk_x2)
    ,   .adc_clk        (adc_clk)
    ,   .adc_data_in_p  (adc_data_in_p[31:16])
    ,   .adc_data_in_n  (adc_data_in_n[31:16])
    ,   .adc_data_out   (adc_data_out_1)
);

phos_fec_v1_adc_mapping 
# (
        .ADC_BITS       (12)
    ,   .ADC_CHIPS      (2)
    ,   .ADC_CHIP_NCH   (32)
)
phos_fec_v1_adc_mapping_inst 
(
        .adc_pdata_i    ({adc_data_out_1, adc_data_out_0})
    ,   .adc_pdata_o    (adc_data_mapped)
);

adc_delay_fifo adc_delay_fifo_inst
(
        .clk            (adc_clk)
    ,   .srst           (rst)
    ,   .din            (adc_data_mapped)
    ,   .wr_en          (fifo_wr)
    ,   .rd_en          (fifo_rd)
    ,   .dout           (adc_data_out)
    ,   .full           ()
    ,   .empty          ()
    ,   .data_count     (fifo_used)
);

assign fifo_wr = ~(fifo_used > trigger_latency);
assign fifo_rd = ~(fifo_used < trigger_latency);

endmodule
