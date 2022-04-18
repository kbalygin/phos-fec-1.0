`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 05:19:44 PM
// Design Name: 
// Module Name: adc_event_buf_tb
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


module adc_event_buf_tb;

logic rst;
logic dclk;
logic dclk_p;
logic dclk_n;
logic fclk6;
logic fclk12;
logic [3:0]fclk12_sh;
logic ser_q;
logic load;
logic [23:0] ser_d[31:0];
logic [31:0] adc_data_in;
logic [63:0][11:0] adc_data_out;

logic [11:0] data [63:0];

logic [11:0] deser_q;

logic adc_clk_x4;
logic adc_clk_x2;
logic adc_clk;

logic trig_l0;

adc_event_buf adc_event_buf_dut
(
        .rst            (rst)
    ,   .dclk_p         ({dclk_p, dclk_p})
    ,   .dclk_n         ({dclk_n, dclk_n})
    ,   .adc_clk_x4     (adc_clk_x4)
    ,   .adc_clk_x2     (adc_clk_x2)
    ,   .adc_clk        (adc_clk)
    ,   .adc_data_in_p  (adc_data_in)
    ,   .adc_data_in_n  (~adc_data_in)
    
    ,   .trigger_latency(10)
    
    ,   .trig_l0        (trig_l0)
    
    ,   .rd_clk         ()
    
    ,   .adc_data_out   ()
    
    ,   .read_addr      (0)

);

always #1.0  dclk = ~dclk;
assign dclk_n = ~dclk_p;
always #3.0 fclk6 = ~fclk6;
always #6.0 fclk12 = ~fclk12;
always #12.0 adc_clk = ~adc_clk;
always @(posedge dclk or negedge dclk)
    #0.5 dclk_p <= dclk;

always @(posedge fclk6 or negedge fclk6)
    adc_clk_x4 <= fclk6;
    
always @(posedge fclk12 or negedge fclk12)
    adc_clk_x2 <= fclk12;


always_ff @(posedge dclk or negedge dclk) fclk12_sh <= {fclk12_sh[2:0], adc_clk};
always_ff @(posedge dclk or negedge dclk) load <= (fclk12_sh[1:0] == 2'b01);

genvar j;
generate 
    for(j = 0; j < 32; j = j + 1)
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

genvar k;
generate
for(k = 0; k < 64; k = k + 1)
begin : data_change
    always_ff @(posedge fclk12)
        data[k][11:6] <= data[k][11:6] + 1;
end
endgenerate

initial
begin
    dclk = 1;
    fclk6 = 1;
    fclk12 = 1;
    adc_clk = 1;
    rst = 1;
    trig_l0 = 0;
    for(i = 0; i < 64; i = i + 1)
        data[i] = i + 1;
    #100
    rst = 0;
    #2000
    trig_l0 = 1;
    #20
    trig_l0 = 0;
     
    #10000 $finish;
end

endmodule
