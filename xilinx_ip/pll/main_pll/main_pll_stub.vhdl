-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue Apr 19 17:50:04 2022
-- Host        : QCrypto2-PC running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub d:/GIT/phos-fec-v1.0/xilinx_ip/pll/main_pll/main_pll_stub.vhdl
-- Design      : main_pll
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k160tffv676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_pll is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    clk_out4 : out STD_LOGIC;
    clk_out5 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end main_pll;

architecture stub of main_pll is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,reset,locked,clk_in1";
begin
end;
