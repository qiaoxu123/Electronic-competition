## Generated SDC file "logic_analysis.sdc"

## Copyright (C) 1991-2008 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 8.1 Build 163 10/28/2008 SJ Full Version"

## DATE    "Mon May 11 20:54:34 2009"

##
## DEVICE  "EP1C3T144C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 40.000 -waveform { 0.000 20.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks -use_tan_name


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[0]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[0]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[10]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[10]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[11]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[11]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[12]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[12]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[13]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[13]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[14]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[14]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[15]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[15]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[1]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[1]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[2]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[2]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[3]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[3]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[4]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[4]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[5]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[5]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[6]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[6]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[7]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[7]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[8]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[8]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {signal[9]}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {signal[9]}]
set_input_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  7.000 [get_ports {trigger}]
set_input_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  5.000 [get_ports {trigger}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {hsync}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {hsync}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_b[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_b[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_b[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_b[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_b[2]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_b[2]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_g[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_g[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_g[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_g[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_g[2]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_g[2]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_r[0]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_r[0]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vga_r[1]}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vga_r[1]}]
set_output_delay -add_delay -max -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  28.000 [get_ports {vsync}]
set_output_delay -add_delay -min -clock [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}]  -4.500 [get_ports {vsync}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {rst_n sampling_mode[0] sampling_mode[1] sampling_mode[2] sampling_clr_n tri_mode}] -to [get_registers *]
set_false_path -from [get_ports {add_key dec_key}] -to [get_registers *]


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -start -from  [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  -to  [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}] 4
set_multicycle_path -hold -start -from  [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk1}]  -to  [get_clocks {sys_ctrl:uut_sys_ctrl|PLL_ctrl:uut_PLL_ctrl|altpll:altpll_component|_clk0}] 3


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

