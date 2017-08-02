set_global_assignment -entity "clk_200" -library "lib_clk_200" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk_200" -library "lib_clk_200" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "clk_200" -library "lib_clk_200" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk_200" -name SPD_FILE [file join $::quartus(sip_path) "clk_200.spd"]

set_global_assignment -library "lib_clk_200" -name MISC_FILE [file join $::quartus(sip_path) "clk_200_sim/clk_200.vo"]
