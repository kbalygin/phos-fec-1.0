`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 10:27:22 AM
// Design Name: 
// Module Name: deser_12_tb
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


module deser_12_tb;

logic rst;
logic dclk;
logic dclk_p;
logic dclk_n;
logic fclk6;
logic fclk12;
logic [3:0]fclk12_sh;
logic ser_q;
logic load;
logic [11:0] ser_d;

logic [11:0] data [2:0] = {12'h001, 12'h002, 12'h004};

logic [11:0] deser_q;

logic adc_clk_x4;
logic adc_clk_x2;

deser_12 deser_12_dut
(   
        .rst        (rst)
    ,   .dclk_p     (dclk_p)
    ,   .dclk_n     (dclk_n)
    ,   .adc_clk_x4 (fclk6)
    ,   .adc_clk_x2 (fclk12)
    ,   .data_in    (ser_d[11])
    ,   .data_out   (deser_q)
);
always #10  dclk = ~dclk;
assign dclk_n = ~dclk_p;
always #30 fclk6 = ~fclk6;
always #60 fclk12 = ~fclk12;
always @(posedge dclk or negedge dclk)
    #5 dclk_p <= dclk;

always @(posedge fclk6 or negedge fclk6)
    adc_clk_x4 <= fclk6;
    
always @(posedge fclk12 or negedge fclk12)
    adc_clk_x2 <= fclk12;


always_ff @(posedge dclk or negedge dclk) fclk12_sh <= {fclk12_sh[2:0], fclk12};
always_ff @(posedge dclk or negedge dclk) load <= (fclk12_sh[1:0] == 2'b01);

always_ff @(posedge dclk or negedge dclk)
    if(load)
        ser_d <= data[0];
    else
        ser_d <= ser_d << 1;
        
always_ff @(posedge dclk)
    if(load)
        data <= {data[0], data[2], data[1]};

initial
begin
    dclk = 1;
    fclk6 = 1;
    fclk12 = 1;
    rst = 1;
    #100
    rst = 0;
    #1000 $finish;
end

endmodule
