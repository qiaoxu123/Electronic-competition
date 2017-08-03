
#CLK
set_location_assignment PIN_AF14  -to clk
set_location_assignment PIN_AA14 -to rst_n
#switch

set_location_assignment PIN_AB12  -to switch1
##GPIO 0
set_location_assignment PIN_AJ19 -to hang[3]
set_location_assignment PIN_AK19 -to hang[2]
set_location_assignment PIN_AK18 -to hang[1]
set_location_assignment PIN_AK16 -to hang[0]
set_location_assignment PIN_Y18  -to lie[3]
set_location_assignment PIN_AD17 -to lie[2]
set_location_assignment PIN_Y17  -to lie[1]
set_location_assignment PIN_AC18 -to lie[0]


set_location_assignment PIN_AJ21 -to SEN
set_location_assignment PIN_AG18 -to SDI
set_location_assignment PIN_AG20 -to SCK
set_location_assignment PIN_AF18 -to LD_SDO