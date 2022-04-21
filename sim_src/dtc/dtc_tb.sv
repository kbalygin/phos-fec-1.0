`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2022 02:33:29 PM
// Design Name: 
// Module Name: dtc_tb
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


module dtc_tb;

//Fast commands
`define RDOCMD      8'hE2
`define SCLKSYNC    8'hE4
`define RJECTCMD    8'hEA
`define RSTCMD      8'hE8
`define STREQ       8'hE9
`define ARDOEND     8'hEF

//slow commands
`define SLOWCMD     8'hE1

logic rst;
logic dtc_clk;
logic dtc_clk_90;
logic dtc_trig;
logic dtc_data;
logic dtc_return;
logic trig_l0;
logic trig_l1;
logic rstcmd;
logic [15:0] status = 16'hAACC;
logic [5:0] adc_rd_addr;
logic [63:0][11:0] adc_data = 0;
logic write;
logic [31:0]write_data;
logic [31:0]read_data = 32'hAABBCCDD;
logic [31:0]address;

dtc_phos_fec_v1 dtc_phos_fec_v1_dut
(
        .rst            (rst)
    ,   .dtc_clk        (dtc_clk)
    ,   .dtc_clk_90     (dtc_clk_90)
    ,   .dtc_trig       (dtc_trig)
    ,   .dtc_data       (dtc_data)
    ,   .dtc_return     (dtc_return)
    ,   .trig_l0        (trig_l0)
    ,   .trig_l1        (trig_l1)
    ,   .rstcmd         (rstcmd)
    ,   .status         (status)
    ,   .adc_rd_addr    (adc_rd_addr)
    ,   .adc_data       (adc_data)
    ,   .write          (write)
    ,   .write_data     (write_data)
    ,   .address        (address)
    ,   .read_data      (read_data)
    ,   .data_vld       (1'b1)
);

initial
begin
    rst = 1;
    dtc_clk = 0;
    dtc_clk_90 = 0;
    dtc_trig = 0;
    #10
    rst = 0;
    #100
    FastCommand(`RSTCMD);
    #50
    L0;
    #100
    L1;
    #100
    SlowCommand(32'h00000060, 32'h0033);
    #100
    SlowCommand(32'h00000061, 32'h0077);
    #100
    SlowCommand(32'h00000062, 32'h0099);
    #100
    SlowCommand(32'h00000071, 32'h00F0);
    #100
    SlowCommand(32'h80000060, 32'h0000);
    #100
    SlowCommand(32'h80000071, 32'h0000);
    #100
    SlowCommand(32'h0000001e, 32'h0000);
    #100
    FastCommand(`RDOCMD);
    #400000 $finish;
end

always #12.5 dtc_clk = ~dtc_clk;
always @(posedge dtc_clk or negedge dtc_clk)
    #6.25 dtc_clk_90 <= dtc_clk;

task L0;
    @(posedge dtc_clk)  dtc_trig = 1;
    @(negedge dtc_clk)  dtc_trig = 0;
endtask

task L1;
    @(posedge dtc_clk)  dtc_trig = 1;
    @(negedge dtc_clk)  dtc_trig = 0;
    @(posedge dtc_clk)  dtc_trig = 1;
    @(negedge dtc_clk)  dtc_trig = 0;
endtask

task FastCommand
(
    input [7:0]cmd
);
    automatic integer i = 7;
    do begin
        @(negedge dtc_clk) dtc_trig = cmd[i];
        @(posedge dtc_clk) dtc_trig = 0;
        i = i - 1;
    end while (i != 0);
endtask

task SlowCommand
(
    input [31:0]    address,
    input [31:0]    data
);
    automatic integer i = 71;
    automatic logic [71:0] data_to_dtc;
    data_to_dtc = {`SLOWCMD, address, data};
    do begin
        @(negedge dtc_clk) dtc_trig = data_to_dtc[i];
        @(posedge dtc_clk) dtc_trig = 0;
        i = i - 1;
    end while (i != 0);        
endtask

endmodule
