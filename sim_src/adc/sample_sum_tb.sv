`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2022 04:19:41 PM
// Design Name: 
// Module Name: sample_sum_tb
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


module sample_sum_tb;

logic clk;
logic l0;
logic rst;
logic [7:0]cnt = 0;

logic [29:0][11:0]samples = { 12'd49,
                12'd51,
                12'd51,
                12'd50,
                12'd51,
                12'd57,
                12'd279,
                12'd634,
                12'd890,
                12'd1003,
                12'd1007,
                12'd949,
                12'd859,
                12'd758,
                12'd657,
                12'd563,
                12'd481,
                12'd411,
                12'd353,
                12'd303,
                12'd262,
                12'd227,
                12'd199,
                12'd177,
                12'd159,
                12'd145,
                12'd131,
                12'd121,
                12'd111,
                12'd103};

logic [11:0] adc_data;
logic [11:0] data_out;

Sample_Sum 
#(
        .presample_num   (4)
    ,   .sample_num      (16) 
) Sample_Sum_dut (
        .clk        (clk)
    ,   .rst        (rst)
    ,   .L0         (l0)
    ,   .data_in    (adc_data)
    ,   .data_out   (data_out)
);

always #12.5 clk = ~clk;

always_ff @(posedge clk)
begin
    if(l0)
        cnt <= 30;
    else if(cnt != 0)
        cnt <= cnt - 1;
end

assign adc_data = samples[29];

always_ff @(posedge clk)
    if(cnt != 0)
        samples <= (samples << 12);

initial
begin
    rst = 1;
    clk = 0;
    l0 = 0;   
    #100;
    rst = 0;
    #100
    l0 = 1;           
    #25 l0 = 0;
    #1000 $finish;
end

endmodule
