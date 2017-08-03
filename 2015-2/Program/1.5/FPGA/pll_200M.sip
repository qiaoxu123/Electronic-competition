set_global_assignment -entity "pll_200M" -library "lib_pll_200M" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_200M" -library "lib_pll_200M" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "pll_200M" -library "lib_pll_200M" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_200M" -name SPD_FILE [file join $::quartus(sip_path) "pll_200M.spd"]

set_global_assignment -library "lib_pll_200M" -name MISC_FILE [file join $::quartus(sip_path) "pll_200M_sim/pll_200M.vo"]
