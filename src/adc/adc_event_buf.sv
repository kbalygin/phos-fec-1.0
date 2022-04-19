`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 01:33:32 PM
// Design Name: 
// Module Name: adc_event_buf
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


module adc_event_buf
(
    input                   rst,
    
    input   [1:0]           dclk_p,
    input   [1:0]           dclk_n,
    input                   adc_clk_x4,
    input                   adc_clk_x2,
    input                   adc_clk,
    
    input   [31:0]          adc_data_in_p,
    input   [31:0]          adc_data_in_n,
    
    input   [5:0]           trigger_latency,
    
    input                   trig_l0,
    
    output                  rd_clk,
    
    output  [767:0]         adc_buf_data_out,
    
    input   [5:0]           read_addr

);

logic       [5:0]           mem_wr_addr = 0;
logic                       mem_wr_en = 0;

logic [767:0]         adc_data_out;

adc_data adc_data_inst
(

        .rst                (rst)
    
    ,   .dclk_p             (dclk_p)
    ,   .dclk_n             (dclk_n)
    ,   .adc_clk_x4         (adc_clk_x4)
    ,   .adc_clk_x2         (adc_clk_x2)
    ,   .adc_clk            (adc_clk)
    ,   .adc_data_in_p      (adc_data_in_p)
    ,   .adc_data_in_n      (adc_data_in_n)
    ,   .adc_data_out       (adc_data_out)
    ,   .trigger_latency    (trigger_latency)

);

event_buf event_buf_inst
(
        .clka               (adc_clk)
    ,   .wea                (mem_wr_en)
    ,   .addra              (mem_wr_addr)
    ,   .dina               (adc_data_out)
    ,   .clkb               (rd_clk)
    ,   .addrb              (read_addr)
    ,   .doutb              (adc_buf_data_out)
);

always_ff @(posedge adc_clk)
begin
    if(!mem_wr_en && trig_l0)
        {mem_wr_en, mem_wr_addr} <= {7{1'b1}};
    else if(mem_wr_en)
        {mem_wr_en, mem_wr_addr} <= {mem_wr_en, mem_wr_addr} - 1;
end

endmodule
