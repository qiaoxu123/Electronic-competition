set_global_assignment -entity "clk_sam" -library "lib_clk_sam" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk_sam" -library "lib_clk_sam" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "clk_sam" -library "lib_clk_sam" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk_sam" -name SPD_FILE [file join $::quartus(sip_path) "clk_sam.spd"]

set_global_assignment -library "lib_clk_sam" -name MISC_FILE [file join $::quartus(sip_path) "clk_sam_sim/clk_sam.vo"]
