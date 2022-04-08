`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 02:12:40 PM
// Design Name: 
// Module Name: ads52j90_model
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


module ads52j90_tb;

logic rst;
logic dclk;
logic dclk_p;
logic dclk_n;
logic fclk6;
logic fclk12;
logic [3:0]fclk12_sh;
logic ser_q;
logic load;
logic [23:0] ser_d[15:0];
logic [15:0] adc_data_in;
logic [31:0][11:0] adc_data_out;

logic [11:0] data [31:0];

logic [11:0] deser_q;

logic adc_clk_x4;
logic adc_clk_x2;
logic adc_clk;

ads52j90_readout ads52j90_readout_tb
(
        .rst            (rst)
    ,   .dclk_p         (dclk_p)
    ,   .dclk_n         (dclk_n)
    ,   .adc_clk_x4     (adc_clk_x4)
    ,   .adc_clk_x2     (adc_clk_x2)
    ,   .adc_clk        (adc_clk)
    ,   .adc_data_in    (adc_data_in)
    ,   .adc_data_out   (adc_data_out)
);

always #10  dclk = ~dclk;
assign dclk_n = ~dclk_p;
always #30 fclk6 = ~fclk6;
always #60 fclk12 = ~fclk12;
always #120 adc_clk = ~adc_clk;
always @(posedge dclk or negedge dclk)
    #5 dclk_p <= dclk;

always @(posedge fclk6 or negedge fclk6)
    adc_clk_x4 <= fclk6;
    
always @(posedge fclk12 or negedge fclk12)
    adc_clk_x2 <= fclk12;


always_ff @(posedge dclk or negedge dclk) fclk12_sh <= {fclk12_sh[2:0], adc_clk};
always_ff @(posedge dclk or negedge dclk) load <= (fclk12_sh[1:0] == 2'b01);

genvar j;
generate 
    for(j = 0; j < 16; j = j + 1)
    begin : adc_out
        always_ff @(posedge dclk or negedge dclk)
            if(load)
                ser_d[j] <= {data[2 * j], data[2 * j + 1]};
            else
                ser_d[j] <= ser_d[j] << 1;                  
    assign adc_data_in[j] = ser_d[j][23];
    end
endgenerate 

integer i;

initial
begin
    dclk = 1;
    fclk6 = 1;
    fclk12 = 1;
    adc_clk = 1;
    rst = 1;
    for(i = 0; i < 32; i = i + 1)
        data[i] = i + 1;
    #100
    rst = 0;
    #1000 $finish;
end

endmodule
