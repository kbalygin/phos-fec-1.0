`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2022 04:36:32 PM
// Design Name: 
// Module Name: dtc
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


module dtc_phos_fec_v1
(
    input                   rst,
    input                   dtc_clk,
    input                   dtc_clk_90,
    input                   dtc_trig,
    output                  dtc_data,
    output                  dtc_return,
    
    output logic            trig_l0,
    output logic            trig_l1,
    
    output logic            rstcmd,
    
    input           [15:0]  status,
    
    
    output logic    [5:0]   adc_rd_addr,
    input           [767:0] adc_data,
    
    output logic            write,
    output logic    [31:0]  write_data,
    output logic    [31:0]  address,
    input           [31:0]  read_data,
    input                   data_vld
);

logic rdocmd;
logic streq;

logic read;

dtc_rx dtc_rx_inst
(
        .rst            (rst)
    ,   .dtc_clk_90     (dtc_clk_90)
    ,   .dtc_trig       (dtc_trig)
    
    ,   .trig_l0        (trig_l0)
    ,   .trig_l1        (trig_l1)
    
    ,   .rdocmd         (rdocmd)
    ,   .sclksync       ()
    ,   .rjectcmd       ()
    ,   .rstcmd         (rstcmd)
    ,   .streq          (streq)
    ,   .ardoend        ()
    
    ,   .address        (address)
    ,   .data           (write_data)
    ,   .write          (write)
    ,   .read           (read)
);

dtc_tx dtc_tx_inst
(
        .rst            (rst || rstcmd)
    ,   .dtc_clk        (dtc_clk)
    ,   .dtc_clk_90     (dtc_clk_90)
    ,   .dtc_data       (dtc_data)
    ,   .dtc_return     (dtc_return)
    
    ,   .rdocmd         (rdocmd)
    ,   .adc_rd_addr    (adc_rd_addr)
    ,   .adc_data       (adc_data)
    
    ,   .streq          (streq)
    ,   .status         (status)
    
    ,   .read           (read)
    ,   .address        (address)
    ,   .data           (read_data)
    ,   .data_vld       (data_vld)
);

endmodule
