set_global_assignment -entity "pll_100m" -library "lib_pll_100m" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_100m" -library "lib_pll_100m" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "pll_100m" -library "lib_pll_100m" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_100m" -name SPD_FILE [file join $::quartus(sip_path) "pll_100m.spd"]

set_global_assignment -library "lib_pll_100m" -name MISC_FILE [file join $::quartus(sip_path) "pll_100m_sim/pll_100m.vo"]
