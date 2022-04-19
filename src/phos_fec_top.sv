`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 04:32:43 PM
// Design Name: 
// Module Name: phos_fec_top
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


module phos_fec_v1 (
   // ADC
   input  wire [ 1:0] ADC_DCLK_P,
   input  wire [ 1:0] ADC_DCLK_N,
   input  wire [ 1:0] ADC_FCLK_P,
   input  wire [ 1:0] ADC_FCLK_N,
   input  wire [31:0] ADC_DOUT_P,
   input  wire [31:0] ADC_DOUT_N,

   output wire [ 1:0] ADC_SEN,
   output wire        ADC_SCLK,
   output wire        ADC_SDATA,
   input  wire        ADC_SDOUT,

   output wire        ADC_RESET,
   output wire        ADC_SYNC,
   output wire        ADC_PDN_FAST,
   output wire [ 1:0] ADC_PDN_GBL,

   // Thermometer ADT7301
   output wire [ 2:0] ADT_CS_B,
   output wire        ADT_SCLK,
   output wire        ADT_DIN,
   input  wire        ADT_DOUT,

   // Clock
   input  wire CLK_ADC_P,
   input  wire CLK_ADC_N,
   input  wire CLK_DTC_P,
   input  wire CLK_DTC_N,
   input  wire CLK_MGT_P,
   input  wire CLK_MGT_N,
   input  wire CLK_OSC_125_P,
   input  wire CLK_OSC_125_N,
   input  wire CLK_OSC_40_P,
   input  wire CLK_OSC_40_N,
   input  wire CLK_TDC_P,
   input  wire CLK_TDC_N,

   // Clock control
   output wire CLK_MUX_OE,
   output wire CLK_MUX_SEL,

   // DigiPOT control
   output wire DPOT_SCLK,
   output wire DPOT_SYNC_B,
   output wire DPOT_SDI,
   input  wire DPOT_SDO,

   // DTC
   output wire DTC_DATA_P,
   output wire DTC_DATA_N,
   output wire DTC_RETURN_P,
   output wire DTC_RETURN_N,
   input  wire DTC_TRIG_P,
   input  wire DTC_TRIG_N,

   // Flash for FPGA F/W
   inout  tri  [ 3:0] FLASH_D,
   output wire        FLASH_FCS_B,

   // Signals from Discriminators
   input  wire [31:0] HIT,

   // HV DACs Control
   output wire [ 3:0] HV_DAC_SYNC_B,
   output wire        HV_DAC_SCLK,
   output wire        HV_DAC_LOAD_B,
   output wire        HV_DAC_DIN,

   // IIC for Board Management
   input  wire IIC_PM_ALERT_B,
   inout  tri  IIC_PM_SCL,
   inout  tri  IIC_PM_SDA,

   //// LEDs
   // 0,4 - Red
   // 1,5 - Orange
   // 2,3,6,7 - Green
   output wire [7:0] LED_B,

   // LVDS
   output wire [15:0] LVDS_N,
   output wire [15:0] LVDS_P,

   // 1Wire Temperature & ID
   inout  tri  ONE_WIRE,

   // Board Power Control and Status
   output wire ON_12V5,
   output wire ON_1V2D_ADC,
   output wire ON_1V8A_ADC,
   output wire ON_1V8D_ADC,
   output wire ON_2V5_CLK,
   output wire ON_2V5_TDC,
   output wire ON_3V3_SHAPER,
   output wire ON_3V3_TDC,
   output wire ON_5V0_BIAS,
   output wire ON_5V0_SUM,
   output wire ON_N5V0,
   input  wire PGOOD_1V2D_ADC,
   input  wire PGOOD_1V8A_ADC,
   input  wire PGOOD_1V8D_ADC,
   input  wire PGOOD_2V5_CLK,
   input  wire PGOOD_3V3_SHAPER,
   input  wire PGOOD_3V3_TDC,

   // PLL Control
   output wire PLL_SPI_CS_B,
   output wire PLL_SPI_SCL,
   output wire PLL_SPI_SDI,
   input  wire PLL_SPI_SDO,
   inout  tri  PLL_CS_CA,
   output wire PLL_RST_B,
   input  wire PLL_C2B,
   input  wire PLL_INT_C1B,
   input  wire PLL_LOL,

   // SFP - Ethernet
   inout  wire        SFP_IIC_SCL,
   inout  wire        SFP_IIC_SDA,
   input  wire        SFP_LOS,
   input  wire        SFP_MOD_DETECT,
   output wire [ 1:0] SFP_RT_SEL,
   input  wire        SFP_RX_N,
   input  wire        SFP_RX_P,
   output wire        SFP_TX_DISABLE,
   input  wire        SFP_TX_FAULT,
   output wire        SFP_TX_N,
   output wire        SFP_TX_P,
   output wire        SFP_LED_R_B,
   output wire        SFP_LED_O_B,
   output wire        SFP_LED_G0_B,
   output wire        SFP_LED_G1_B,

   // HPTDC control/status
   output wire        TDC_BUNCH,
   output wire        TDC_ENC,
   output wire        TDC_EVENT,
   input  wire        TDC_ERR,
   output wire        TDC_RESET,
   output wire        TDC_TRIG,
   // HPTDC parallel data
   input  wire        TDC_DRDY,
   output wire        TDC_GETD,
   input  wire [31:0] TDC_DATA,
   input  wire        TDC_TOKOUT,
   output wire        TDC_TOKIN,
   // HPTDC JTAG
   output wire        TDC_TCK,
   output wire        TDC_TDI,
   output wire        TDC_TMS,
   input  wire        TDC_TDO,

   // Threshold setup DACs Control
   output wire [ 3:0] THR_DAC_SYNC_B,
   output wire        THR_DAC_SCLK,
   output wire        THR_DAC_LOAD_B,
   output wire        THR_DAC_DIN,

   input  wire [ 3:0] TTL_IN_P,
   input  wire [ 3:0] TTL_IN_N,
   output wire [ 3:0] TTL_OUT_P,
   output wire [ 3:0] TTL_OUT_N,
   output wire [ 3:0] TTL_OUT_EN_B,
   output wire [ 3:0] TTL_R_EN,
   output wire [ 3:0] TTL_LED_B
);

////////////////////////////////////////////////////////////////
//     LEDs Placement                             +---------+ //
//                                                |         | //
//                                                |         | //
//           LEDs                   LEDs          |         | //
//    +-+  +-+  +-+  +-+     +-+  +-+  +-+  +-+   |         | //
//    |7|  |6|  |5|  |4|     |3|  |2|  |1|  |0|   |   SFP   | //
//    +-+  +-+  +-+  +-+     +-+  +-+  +-+  +-+   |         | //
//                                                |         | //
// +---------------------+                        |         | //
// |        JTAG         |                        |         | //
// +---------------------+                        +---------+ //
////////////////////////////////////////////////////////////////

// LED #0 - Red
// LED #1 - Yellow
// LED #2 - Green
// LED #3 - Green
// LED #4 - Red
// LED #5 - Yellow
// LED #6 - Green
// LED #7 - Green


logic adc_clk_4x;
logic adc_clk_2x;
logic tdc_clk;

logic dtc_clk;
logic dtc_clk_90;
logic dtc_trig;
logic dtc_data;
logic dtc_return;

logic [63:0][11:0]  adc_data_out;
logic [5:0]         read_addr;
logic [6:0]         trigger_latency = 48;

logic trig_l0;
logic trig_l1;

main_pll main_pll_inst 
(
  // Clock out ports
        .clk_out1   (tdc_clk)
    ,   .clk_out2   (dtc_clk_90)
    ,   .clk_out3   (adc_clk_2x)
    ,   .clk_out4   (adc_clk_4x)
    ,   .clk_out5   ()
  // Status and control signals
    ,   .reset      ()
    ,   .locked     ()
 // Clock in ports
    ,   .clk_in1    (dtc_clk)
 );

IBUFDS 
#(
        .IOSTANDARD ("LVDS") // Specify the output I/O standard
    ,   .DIFF_TERM  ("TRUE")
//   .SLEW("SLOW")           // Specify the output slew rate
) dtc_clk_inst (
        .I          (CLK_DTC_P)
    ,   .IB         (CLK_DTC_N)
    ,   .O          (dtc_clk)
);

IBUFDS 
#(
        .IOSTANDARD ("LVDS") // Specify the output I/O standard
    ,   .DIFF_TERM  ("TRUE")
//   .SLEW("SLOW")           // Specify the output slew rate
) dtc_trig_inst (
        .I          (DTC_TRIG_P)
    ,   .IB         (DTC_TRIG_N)
    ,   .O          (dtc_trig)
);

OBUFDS #(
   .IOSTANDARD("LVDS") // Specify the output I/O standard
//   .SLEW("SLOW")           // Specify the output slew rate
) dtc_data_inst (
   .I   (dtc_data),
   .O   (DTC_DATA_P),
   .OB  (DTC_DATA_N)
);

OBUFDS #(
   .IOSTANDARD("LVDS") // Specify the output I/O standard
//   .SLEW("SLOW")           // Specify the output slew rate
) dtc_return_inst (
   .I   (dtc_return),
   .O   (DTC_RETURN_P),
   .OB  (DTC_RETURN_N)
);

adc_event_buf adc_event_buf_inst
( 
        .rst                (1'b0)
    
    ,   .dclk_p             (ADC_DCLK_P)
    ,   .dclk_n             (ADC_DCLK_N)
    ,   .adc_clk_x4         (adc_clk_4x)
    ,   .adc_clk_x2         (adc_clk_2x)
    ,   .adc_clk            (tdc_clk)
    ,   .adc_data_in_p      (ADC_DOUT_P)
    ,   .adc_data_in_n      (ADC_DOUT_N)
    ,   .trigger_latency    (trigger_latency)
    
    ,   .trig_l0            (trig_l0)
    
    ,   .rd_clk             (tdc_clk)
    ,   .adc_buf_data_out   (adc_data_out)
    ,   .read_addr          (read_addr)

);

dtc_phos_fec_v1 dtc_phos_fec_v1_inst
(
        .rst                (1'b0)
    ,   .dtc_clk            (dtc_clk)
    ,   .dtc_clk_90         (dtc_clk_90)
    ,   .dtc_trig           (dtc_trig)
    ,   .dtc_data           (dtc_data)
    ,   .dtc_return         (dtc_return)
    
    ,   .trig_l0            (trig_l0)
    ,   .trig_l1            (trig_l1)
    
    ,   .rstcmd             ()
    ,   .status             ()
    
    ,   .adc_rd_addr        (read_addr)
    ,   .adc_data           (adc_data_out)
    
    ,   .write              ()
    ,   .write_data         ()
    ,   .address            ()
    ,   .read_data          ()
    ,   .data_vld           ()
);

endmodule
