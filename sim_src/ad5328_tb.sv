`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 02:35:34 PM
// Design Name: 
// Module Name: ad5328_tb
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


module ad5328_tb;

logic rst;
logic dtc_clk;
    
logic [31:0][11:0]dac_data;
logic dac_update;
    
logic din;
logic [3:0]sync_n;
logic ldac_n;
logic sclk;

ad5328 ad5328_dut
(
        .rst            (rst)
    ,   .dtc_clk        (dtc_clk)
    ,   .dac_data       (dac_data)
    ,   .dac_update     (dac_update)
    ,   .din            (din)
    ,   .sync_n         (sync_n)
    ,   .ldac_n         (ldac_n)
    ,   .sclk           (sclk)
);

always #12.5 dtc_clk = ~dtc_clk;
initial
begin
    rst = 1'b1;
    dtc_clk = 1'b0;
    dac_data =  {   12'h01f, 12'h01e, 12'h01d, 12'h01c, 12'h01b, 12'h01a, 12'h019, 12'h018, 
                    12'h017, 12'h016, 12'h015, 12'h014, 12'h013, 12'h012, 12'h011, 12'h010,
                    12'h00f, 12'h00e, 12'h00d, 12'h00c, 12'h00b, 12'h00a, 12'h009, 12'h008,
                    12'h007, 12'h006, 12'h005, 12'h004, 12'h003, 12'h002, 12'h001, 12'h000};
    dac_update = 0;
    #50
    rst = 0;
    #100
    
    @(posedge dtc_clk) dac_update = 1;
    @(posedge dtc_clk) dac_update = 0;
    
    #10000 $finish;
end
endmodule
