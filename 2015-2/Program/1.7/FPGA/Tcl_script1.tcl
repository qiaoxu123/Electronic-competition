
#CLK
set_location_assignment PIN_AF14  -to clk
set_location_assignment PIN_AA14 -to rst_n
set_location_assignment PIN_AA16  -to clk_1


set_location_assignment PIN_Y26 -to clk3_50
set_location_assignment PIN_K14 -to clk4_50



#KEY
set_location_assignment PIN_AA14 -to key[0]
set_location_assignment PIN_AA15 -to key[1]
set_location_assignment PIN_W15 -to key[2]
set_location_assignment PIN_Y16 -to key[3]

#switch

set_location_assignment PIN_AB12  -to sw[0]
set_location_assignment PIN_AC12  -to sw[1]
set_location_assignment PIN_AF9   -to sw[2]
set_location_assignment PIN_AF10  -to sw[3]
set_location_assignment PIN_AD11  -to sw[4]
set_location_assignment PIN_AD12  -to sw[5]
set_location_assignment PIN_AE11  -to sw[6]
set_location_assignment PIN_AC9   -to sw[7]
set_location_assignment PIN_AD10  -to sw[8]
set_location_assignment PIN_AE12  -to sw[9]


#LED
set_location_assignment PIN_V16 -to LED[0]
set_location_assignment PIN_W16 -to LED[1]
set_location_assignment PIN_V17 -to LED[2]
set_location_assignment PIN_V18 -to LED[3]
set_location_assignment PIN_W17 -to LED[4]
set_location_assignment PIN_W19 -to LED[5]
set_location_assignment PIN_Y19 -to LED[6]
set_location_assignment PIN_W20 -to LED[7]
set_location_assignment PIN_W21 -to LED[8]
set_location_assignment PIN_Y21 -to LED[9]


#UART
set_location_assignment PIN_AJ21 -to  uart_rxd
set_location_assignment PIN_AG18 -to  uart_txd


#VGA


set_location_assignment PIN_B13 -to VGA_B[0]
set_location_assignment PIN_G13 -to VGA_B[1]
set_location_assignment PIN_H13 -to VGA_B[2]
set_location_assignment PIN_F14 -to VGA_B[3]
set_location_assignment PIN_H14 -to VGA_B[4]
set_location_assignment PIN_F15 -to VGA_B[5]
set_location_assignment PIN_G15 -to VGA_B[6]
set_location_assignment PIN_J14 -to VGA_B[7]
set_location_assignment PIN_F10 -to VGA_BLANK_N
set_location_assignment PIN_A11 -to VGA_CLK
set_location_assignment PIN_J9  -to VGA_G[0]
set_location_assignment PIN_J10 -to VGA_G[1]
set_location_assignment PIN_H12 -to VGA_G[2]
set_location_assignment PIN_G10 -to VGA_G[3]
set_location_assignment PIN_G11 -to VGA_G[4]
set_location_assignment PIN_G12 -to VGA_G[5]
set_location_assignment PIN_F11 -to VGA_G[6]
set_location_assignment PIN_E11 -to VGA_G[7]
set_location_assignment PIN_B11 -to VGA_HS
set_location_assignment PIN_A13 -to VGA_R[0]
set_location_assignment PIN_C13 -to VGA_R[1]
set_location_assignment PIN_E13 -to VGA_R[2]
set_location_assignment PIN_B12 -to VGA_R[3]
set_location_assignment PIN_C12 -to VGA_R[4]
set_location_assignment PIN_D12 -to VGA_R[5]
set_location_assignment PIN_E12 -to VGA_R[6]
set_location_assignment PIN_F13 -to VGA_R[7]
set_location_assignment PIN_C10 -to VGA_SYNC_N
set_location_assignment PIN_D11 -to VGA_VS





#SDRAM
set_location_assignment PIN_AK14 -to sdram_addr[0] 
set_location_assignment PIN_AH14 -to sdram_addr[1] 
set_location_assignment PIN_AG15 -to sdram_addr[2] 
set_location_assignment PIN_AE14 -to sdram_addr[3] 
set_location_assignment PIN_AB15 -to sdram_addr[4] 
set_location_assignment PIN_AC14 -to sdram_addr[5] 
set_location_assignment PIN_AD14 -to sdram_addr[6] 
set_location_assignment PIN_AF15 -to sdram_addr[7] 
set_location_assignment PIN_AH15 -to sdram_addr[8] 
set_location_assignment PIN_AG13 -to sdram_addr[9] 
set_location_assignment PIN_AG12 -to sdram_addr[10] 
set_location_assignment PIN_AH13 -to sdram_addr[11] 
set_location_assignment PIN_AJ14 -to sdram_addr[12] 


set_location_assignment PIN_AF13 -to sdram_ba[0]
set_location_assignment PIN_AJ12 -to sdram_ba[1]


set_location_assignment PIN_AF11 -to sdram_cas_n

set_location_assignment PIN_AK13 -to sdram_cke

set_location_assignment PIN_AG11 -to sdram_cs_n

set_location_assignment PIN_AH12 -to sdram_clk

set_location_assignment PIN_AK6 -to sdram_dq[0]
set_location_assignment PIN_AJ7 -to sdram_dq[1]
set_location_assignment PIN_AK7 -to sdram_dq[2]
set_location_assignment PIN_AK8 -to sdram_dq[3]
set_location_assignment PIN_AK9 -to sdram_dq[4]
set_location_assignment PIN_AG10 -to sdram_dq[5]
set_location_assignment PIN_AK11 -to sdram_dq[6]
set_location_assignment PIN_AJ11 -to sdram_dq[7]
set_location_assignment PIN_AH10 -to sdram_dq[8]
set_location_assignment PIN_AJ10 -to sdram_dq[9]
set_location_assignment PIN_AJ9 -to sdram_dq[10]
set_location_assignment PIN_AH9 -to sdram_dq[11]
set_location_assignment PIN_AH8 -to sdram_dq[12]
set_location_assignment PIN_AH7 -to sdram_dq[13]
set_location_assignment PIN_AJ6 -to sdram_dq[14]
set_location_assignment PIN_AJ5 -to sdram_dq[15]
set_location_assignment PIN_AB13 -to sdram_dqm[0]
set_location_assignment PIN_AE13 -to sdram_ras_n
set_location_assignment PIN_AK12 -to sdram_dqm[1]
set_location_assignment PIN_AA13 -to sdram_we_n


#GPIO 0

//set_location_assignment PIN_AJ21 -to GPIO_0[35]
//set_location_assignment PIN_AG18 -to GPIO_0[34]
set_location_assignment PIN_AG20 -to GPIO_0[33]
set_location_assignment PIN_AF18 -to GPIO_0[32]
set_location_assignment PIN_AG21 -to GPIO_0[31]
set_location_assignment PIN_AF19 -to GPIO_0[30]
set_location_assignment PIN_AF21 -to GPIO_0[29]
set_location_assignment PIN_AF20 -to GPIO_0[28]
set_location_assignment PIN_AE19 -to GPIO_0[27]
set_location_assignment PIN_AE18 -to GPIO_0[26]	
set_location_assignment PIN_AD20 -to GPIO_0[25]
set_location_assignment PIN_AD19 -to GPIO_0[24]
set_location_assignment PIN_AK21 -to GPIO_0[23]
set_location_assignment PIN_AH20 -to GPIO_0[22]
set_location_assignment PIN_AJ20 -to GPIO_0[21]
set_location_assignment PIN_AH19 -to GPIO_0[20]
set_location_assignment PIN_AC20 -to GPIO_0[19]
set_location_assignment PIN_AE17 -to GPIO_0[18]
set_location_assignment PIN_AA19 -to GPIO_0[17]
set_location_assignment PIN_AA18 -to GPIO_0[16]
set_location_assignment PIN_AG17 -to GPIO_0[15]
set_location_assignment PIN_AF16 -to GPIO_0[14]
set_location_assignment PIN_AE16 -to GPIO_0[13]
set_location_assignment PIN_AG16 -to GPIO_0[12]
set_location_assignment PIN_AH17 -to GPIO_0[11]
set_location_assignment PIN_AH18 -to GPIO_0[10]
set_location_assignment PIN_AJ16 -to GPIO_0[9]
set_location_assignment PIN_AJ17 -to GPIO_0[8]
set_location_assignment PIN_AJ19 -to GPIO_0[7]
set_location_assignment PIN_AK19 -to GPIO_0[6]
set_location_assignment PIN_AK18 -to GPIO_0[5]
set_location_assignment PIN_AK16 -to GPIO_0[4]
set_location_assignment PIN_Y18  -to GPIO_0[3]
set_location_assignment PIN_AD17 -to GPIO_0[2]
set_location_assignment PIN_Y17  -to GPIO_0[1]
set_location_assignment PIN_AC18 -to GPIO_0[0]



#GPIO 1


set_location_assignment PIN_AC22 -to GPIO_1[35]
set_location_assignment PIN_AA20 -to GPIO_1[34]
set_location_assignment PIN_AD21 -to GPIO_1[33]
set_location_assignment PIN_AE22 -to GPIO_1[32]
set_location_assignment PIN_AF23 -to GPIO_1[31]
set_location_assignment PIN_AF24 -to GPIO_1[30]
set_location_assignment PIN_AG22 -to GPIO_1[29]
set_location_assignment PIN_AH22 -to GPIO_1[28]
set_location_assignment PIN_AJ22 -to GPIO_1[27]
set_location_assignment PIN_AK22 -to GPIO_1[26]
set_location_assignment PIN_AH23 -to GPIO_1[25]
set_location_assignment PIN_AK23 -to GPIO_1[24]
set_location_assignment PIN_AG23 -to GPIO_1[23]
set_location_assignment PIN_AK24 -to GPIO_1[22]
set_location_assignment PIN_AJ24 -to GPIO_1[21]
set_location_assignment PIN_AJ25 -to GPIO_1[20]
set_location_assignment PIN_AH25 -to GPIO_1[19]
set_location_assignment PIN_AK26 -to GPIO_1[18]
set_location_assignment PIN_AJ26 -to GPIO_1[17]
set_location_assignment PIN_AK27 -to GPIO_1[16]
set_location_assignment PIN_AK28 -to GPIO_1[15]
set_location_assignment PIN_AK29 -to GPIO_1[14]
set_location_assignment PIN_AJ27 -to GPIO_1[13]
set_location_assignment PIN_AH27 -to GPIO_1[12]
set_location_assignment PIN_AH24 -to GPIO_1[11]
set_location_assignment PIN_AG26 -to GPIO_1[10]
set_location_assignment PIN_AG25 -to GPIO_1[9]
set_location_assignment PIN_AF26 -to GPIO_1[8]
set_location_assignment PIN_AF25 -to GPIO_1[7]
set_location_assignment PIN_AE24 -to GPIO_1[6]
set_location_assignment PIN_AE23 -to GPIO_1[5]
set_location_assignment PIN_AD24 -to GPIO_1[4]
set_location_assignment PIN_AC23 -to GPIO_1[3]
set_location_assignment PIN_AB21 -to GPIO_1[2]
set_location_assignment PIN_AA21 -to GPIO_1[1]
set_location_assignment PIN_AB17 -to GPIO_1[0]


#数码管

set_location_assignment PIN_AH28 -to HEX0[6]
set_location_assignment PIN_AG28 -to HEX0[5]
set_location_assignment PIN_AF28 -to HEX0[4]
set_location_assignment PIN_AG27 -to HEX0[3]
set_location_assignment PIN_AE28 -to HEX0[2]
set_location_assignment PIN_AE27 -to HEX0[1]
set_location_assignment PIN_AE26 -to HEX0[0]

set_location_assignment PIN_AD27 -to HEX1[6]
set_location_assignment PIN_AF30 -to HEX1[5]
set_location_assignment PIN_AF29 -to HEX1[4]
set_location_assignment PIN_AG30 -to HEX1[3]
set_location_assignment PIN_AH30 -to HEX1[2]
set_location_assignment PIN_AH29 -to HEX1[1]
set_location_assignment PIN_AJ29 -to HEX1[0]

set_location_assignment PIN_AC30 -to HEX2[6]
set_location_assignment PIN_AC29 -to HEX2[5]
set_location_assignment PIN_AD30 -to HEX2[4]
set_location_assignment PIN_AC28 -to HEX2[3]
set_location_assignment PIN_AD29 -to HEX2[2]
set_location_assignment PIN_AE29 -to HEX2[1]
set_location_assignment PIN_AB23 -to HEX2[0]

set_location_assignment PIN_AB22 -to HEX3[6]
set_location_assignment PIN_AB25 -to HEX3[5]
set_location_assignment PIN_AB28 -to HEX3[4]
set_location_assignment PIN_AC25 -to HEX3[3]
set_location_assignment PIN_AD25 -to HEX3[2]
set_location_assignment PIN_AC27 -to HEX3[1]
set_location_assignment PIN_AD26 -to HEX3[0]

set_location_assignment PIN_W25  -to HEX4[6]
set_location_assignment PIN_V23  -to HEX4[5]
set_location_assignment PIN_W24  -to HEX4[4]
set_location_assignment PIN_W22  -to HEX4[3]
set_location_assignment PIN_Y24  -to HEX4[2]
set_location_assignment PIN_Y23  -to HEX4[1]
set_location_assignment PIN_AA24 -to HEX4[0]

set_location_assignment PIN_AA25 -to HEX5[6]
set_location_assignment PIN_AA26 -to HEX5[5]
set_location_assignment PIN_AB26 -to HEX5[4]
set_location_assignment PIN_AB27 -to HEX5[3]
set_location_assignment PIN_Y27  -to HEX5[2]
set_location_assignment PIN_AA28 -to HEX5[1]
set_location_assignment PIN_V25  -to HEX5[0]






