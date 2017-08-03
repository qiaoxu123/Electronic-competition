set_global_assignment -entity "pll_500" -library "lib_pll_500" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_500" -library "lib_pll_500" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "pll_500" -library "lib_pll_500" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_500" -name SPD_FILE [file join $::quartus(sip_path) "pll_500.spd"]

set_global_assignment -library "lib_pll_500" -name MISC_FILE [file join $::quartus(sip_path) "pll_500_sim/pll_500.vo"]
