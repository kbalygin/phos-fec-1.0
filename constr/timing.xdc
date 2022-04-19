create_clock -period 12.500 -name clk_adc     -waveform {0.000  6.250} [get_ports CLK_ADC_P]
create_clock -period 25.000 -name clk_tdc     -waveform {0.000 12.500} [get_ports CLK_TDC_P]
create_clock -period 25.000 -name clk_dtc     -waveform {0.000 12.500} [get_ports CLK_DTC_P]
create_clock -period 25.000 -name clk_osc_40  -waveform {0.000 12.500} [get_ports CLK_OSC_40_P]
create_clock -period  8.000 -name clk_osc_125 -waveform {0.000  4.000} [get_ports CLK_OSC_125_P]
create_clock -period  8.000 -name clk_mgt     -waveform {0.000  4.000} [get_ports CLK_MGT_P]


### ADC Deserializers Clocks  (!!! 480 MHz, period 2.083(3) ns !!!)
create_clock -period 2.082 -name adc_dclk_0 -waveform {0.000 1.041} [get_ports {ADC_DCLK_P[0]}]
create_clock -period 2.082 -name adc_dclk_1 -waveform {0.000 1.041} [get_ports {ADC_DCLK_P[1]}]


#### generated clocks for MMCM1 (clk_adc, clk4x_adc, clk_tdc)
#create_generated_clock -name g_clk_tdc   -source [get_ports CLK_TDC_P] -divide_by 1   -add -master_clock clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT0]
#create_generated_clock -name g_clk_adc   -source [get_ports CLK_TDC_P] -multiply_by 2 -add -master_clock clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT1]
#create_generated_clock -name g_clk4x_tdc -source [get_ports CLK_TDC_P] -multiply_by 4 -add -master_clock clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT2]

#### generated clocks for MMCM2 (clk_eth, clk200, clk25)
#create_generated_clock -name g_clk_eth -source [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT0] -divide_by 8 -multiply_by 25 -add -master_clock g_clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_2/CLKOUT0]
#create_generated_clock -name g_clk200  -source [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT0] -multiply_by 5 -add -master_clock g_clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_2/CLKOUT1]
#create_generated_clock -name g_clk25   -source [get_pins phos_fec_clocks/MMCME_BASE_inst_1/CLKOUT0] -divide_by 8 -multiply_by 5 -add -master_clock g_clk_tdc [get_pins phos_fec_clocks/MMCME_BASE_inst_2/CLKOUT2]


#### false path: clk_tdc <> clk_eth
#set_false_path -from [get_clocks g_clk_tdc] -to [get_clocks g_clk_eth]
#set_false_path -from [get_clocks g_clk_eth] -to [get_clocks g_clk_tdc]


###
#set_clock_groups -name async_clk -asynchronous -group [get_clocks -include_generated_clocks clk_mgt] -group [get_clocks -include_generated_clocks clk_dtc] -group [get_clocks -include_generated_clocks clk_tdc] -group [get_clocks -include_generated_clocks clk_osc_40] -group [get_clocks -include_generated_clocks clk_osc_125]



#set_clock_groups -name ASYNC_CLK -asynchronous -group {CLK_DTC_P CLK_TDC_P CLK_ADC_P} -group {CLK_OSC_40_P} -group {CLK_OSC_125_P} -group {CLK_MGT_P}

###
#set_clock_groups -name ASYNC_CLK_ETH_TDC -asynchronous -group {G_CLK_ETH} -group {G_CLK_TDC}
#set_max_delay 10 -datapath_only -from [get_pins phos_fec_reset/reset_reg/D] -to [get_pins phos_fec_reset/reset_eth_reg/D]
