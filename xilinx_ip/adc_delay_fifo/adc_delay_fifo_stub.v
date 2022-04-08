// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Fri Apr  8 15:40:47 2022
// Host        : QCrypto2-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub d:/GIT/phos-fec-v1.0/xilinx_ip/adc_delay_fifo/adc_delay_fifo_stub.v
// Design      : adc_delay_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffv676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1" *)
module adc_delay_fifo(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  data_count)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[767:0],wr_en,rd_en,dout[767:0],full,empty,data_count[6:0]" */;
  input clk;
  input srst;
  input [767:0]din;
  input wr_en;
  input rd_en;
  output [767:0]dout;
  output full;
  output empty;
  output [6:0]data_count;
endmodule
