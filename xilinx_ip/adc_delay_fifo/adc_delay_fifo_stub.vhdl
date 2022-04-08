-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Fri Apr  8 15:40:47 2022
-- Host        : QCrypto2-PC running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub d:/GIT/phos-fec-v1.0/xilinx_ip/adc_delay_fifo/adc_delay_fifo_stub.vhdl
-- Design      : adc_delay_fifo
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k160tffv676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adc_delay_fifo is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 767 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 767 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    data_count : out STD_LOGIC_VECTOR ( 6 downto 0 )
  );

end adc_delay_fifo;

architecture stub of adc_delay_fifo is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[767:0],wr_en,rd_en,dout[767:0],full,empty,data_count[6:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_4,Vivado 2019.1";
begin
end;
