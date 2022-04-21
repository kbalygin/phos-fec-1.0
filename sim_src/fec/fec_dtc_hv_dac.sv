`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 04:25:01 PM
// Design Name: 
// Module Name: fec_dtc_hv_dac
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


module fec_dtc_hv_dac;

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

logic hv_dac_sclk;
logic hv_dac_din;
logic [3:0] hv_dac_sync;
logic hv_dac_ldac;

phos_fec_v1     phos_fec_v1_dut
(
   // ADC
        .ADC_DCLK_P         ()
    ,   .ADC_DCLK_N         ()
    ,   .ADC_FCLK_P         ()
    ,   .ADC_FCLK_N         ()
    ,   .ADC_DOUT_P         ()
    ,   .ADC_DOUT_N         ()
    ,   .ADC_SEN            ()
    ,   .ADC_SCLK           ()
    ,   .ADC_SDATA          ()
    ,   .ADC_SDOUT          ()
    
    ,   .ADC_RESET          ()
    ,   .ADC_SYNC           ()
    ,   .ADC_PDN_FAST       ()
    ,   .ADC_PDN_GBL        ()
    
   // Thermometer ADT7301
    ,   .ADT_CS_B           ()
    ,   .ADT_SCLK           ()
    ,   .ADT_DIN            ()
    ,   .ADT_DOUT           ()

   // Clock
    ,   .CLK_ADC_P          ()
    ,   .CLK_ADC_N          ()
    ,   .CLK_DTC_P          (dtc_clk)
    ,   .CLK_DTC_N          (~dtc_clk)
    ,   .CLK_MGT_P          ()
    ,   .CLK_MGT_N          ()
    ,   .CLK_OSC_125_P      ()
    ,   .CLK_OSC_125_N      ()
    ,   .CLK_OSC_40_P       ()
    ,   .CLK_OSC_40_N       ()
    ,   .CLK_TDC_P          ()
    ,   .CLK_TDC_N          ()
    
   // Clock control
    ,   .CLK_MUX_OE         ()
    ,   .CLK_MUX_SEL        ()

   // DigiPOT control
    ,   .DPOT_SCLK          ()
    ,   .DPOT_SYNC_B        ()
    ,   .DPOT_SDI           ()
    ,   .DPOT_SDO           ()

   // DTC
    ,    .DTC_DATA_P        (dtc_data)
    ,    .DTC_DATA_N        ()
    ,    .DTC_RETURN_P      (dtc_return)
    ,    .DTC_RETURN_N      ()
    ,    .DTC_TRIG_P        (dtc_trig)
    ,    .DTC_TRIG_N        (~dtc_trig)

   // Flash for FPGA F/W
    ,   .FLASH_D            ()
    ,   .FLASH_FCS_B        ()

   // Signals from Discriminators
    ,   .HIT                ()

   // HV DACs Control
    ,   .HV_DAC_SYNC_B      (hv_dac_sync)
    ,   .HV_DAC_SCLK        (hv_dac_sclk)
    ,   .HV_DAC_LOAD_B      (hv_dac_ldac)
    ,   .HV_DAC_DIN         (hv_dac_din)

   // IIC for Board Management
    ,   .IIC_PM_ALERT_B     ()
    ,   .IIC_PM_SCL         ()
    ,   .IIC_PM_SDA         ()

   //// LEDs
   // 0,4 - Red
   // 1,5 - Orange
   // 2,3,6,7 - Green
    ,   .LED_B              ()

   // LVDS
    ,   .LVDS_N             ()
    ,   .LVDS_P             ()

   // 1Wire Temperature & ID
    ,   .ONE_WIRE           ()

   // Board Power Control and Status
    ,   .ON_12V5            ()
    ,   .ON_1V2D_ADC        ()
    ,   .ON_1V8A_ADC        ()
    ,   .ON_1V8D_ADC        ()
    ,   .ON_2V5_CLK         ()
    ,   .ON_2V5_TDC         ()
    ,   .ON_3V3_SHAPER      ()
    ,   .ON_3V3_TDC         ()
    ,   .ON_5V0_BIAS        ()
    ,   .ON_5V0_SUM         ()
    ,   .ON_N5V0            ()
    ,   .PGOOD_1V2D_ADC     ()
    ,   .PGOOD_1V8A_ADC     ()
    ,   .PGOOD_1V8D_ADC     ()
    ,   .PGOOD_2V5_CLK      ()
    ,   .PGOOD_3V3_SHAPER   ()
    ,   .PGOOD_3V3_TDC      ()

   // PLL Control
    ,   .PLL_SPI_CS_B       ()
    ,   .PLL_SPI_SCL        ()
    ,   .PLL_SPI_SDI        ()
    ,   .PLL_SPI_SDO        ()
    ,   .PLL_CS_CA          ()
    ,   .PLL_RST_B          ()
    ,   .PLL_C2B            ()
    ,   .PLL_INT_C1B        ()
    ,   .PLL_LOL            ()


   // HPTDC control/status
    ,   .TDC_BUNCH          ()
    ,   .TDC_ENC            ()
    ,   .TDC_EVENT          ()
    ,   .TDC_ERR            ()
    ,   .TDC_RESET          ()
    ,   .TDC_TRIG           (trig_l0)
   // HPTDC parallel data
    ,   .TDC_DRDY           ()
    ,   .TDC_GETD           ()
    ,   .TDC_DATA           ()
    ,   .TDC_TOKOUT         ()
    ,   .TDC_TOKIN          ()
   // HPTDC JTAG
    ,   .TDC_TCK            ()
    ,   .TDC_TDI            ()
    ,   .TDC_TMS            ()
    ,   .TDC_TDO            ()

   // Threshold setup DACs Control
    ,   .THR_DAC_SYNC_B     ()
    ,   .THR_DAC_SCLK       ()
    ,   .THR_DAC_LOAD_B     ()
    ,   .THR_DAC_DIN        ()
    
    ,   .TTL_IN_P           ()
    ,   .TTL_IN_N           ()
    ,   .TTL_OUT_P          ()
    ,   .TTL_OUT_N          ()
    ,   .TTL_OUT_EN_B       ()
    ,   .TTL_R_EN           ()
    ,   .TTL_LED_B          ()
);

initial
begin
    rst = 1;
    dtc_clk = 0;
    dtc_trig = 0;
    #10
    rst = 0;
    #200
    SlowCommand(32'h00000060, 32'h00000033);
    #100
    SlowCommand(32'h00000061, 32'h00000077);
    #100
    SlowCommand(32'h00000062, 32'h00000099);
    #100
    SlowCommand(32'h00000071, 32'h000000F0);
    #100
    SlowCommand(32'h80000060, 32'h0);
    #100
    SlowCommand(32'h80000071, 32'h0);
    #100
    SlowCommand(32'h0000001e, 32'h0);
    #100
    FastCommand(`RDOCMD);
    #400000 $finish;
end

always #12.5 dtc_clk = ~dtc_clk;

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
