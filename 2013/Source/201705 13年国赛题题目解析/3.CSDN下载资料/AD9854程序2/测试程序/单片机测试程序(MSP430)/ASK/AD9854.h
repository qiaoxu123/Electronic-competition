#define PAR1_H 0x00	//Phase Adjust Register#1<13:8>
#define PAR1_L 0X01	//Phase Adjust Register#1<7:0>
#define PAR2_H 0X02	//Phase Adjust Register#2<13:8>
#define PAR2_L 0X03	//Phase Adjust Register#2<7:0>
#define FTW1_6 0X04	//Frequency Tuning Word1<47:40>
#define FTW1_5 0X05	//Frequency Tuning Word1<39:32>
#define FTW1_4 0X06	//Frequency Tuning Word1<31:24>
#define FTW1_3 0X07	//Frequency Tuning Word1<23:16>
#define FTW1_2 0X08	//Frequency Tuning Word1<15:8>
#define FTW1_1 0X09	//Frequency Tuning Word1<7:0>
#define FTW2_6 0X0A	//Frequency Tuning Word2<47:40>
#define FTW2_5 0X0B	//Frequency Tuning Word2<39:32>
#define FTW2_4 0X0C	//Frequency Tuning Word2<31:24>
#define FTW2_3 0X0D	//Frequency Tuning Word2<23:16>
#define FTW2_2 0X0E	//Frequency Tuning Word2<15:8>
#define FTW2_1 0X0F	//Frequency Tuning Word2<7:0>
#define DFW_6 0X10	//Delta Frequency Word<47:40>
#define DFW_5 0X11	//Delta Frequency Word<39:32>
#define DFW_4 0X12	//Delta Frequency Word<31:24>
#define DFW_3 0X13	//Delta Frequency Word<23:16>
#define DFW_2 0X14	//Delta Frequency Word<15:8>
#define DFW_1 0X15	//Delta Frequency Word<7:0>
#define UDCLK_4 0X16	//Update Clock<31:24>
#define UDCLK_3 0X17	//Update Clock<23:16>
#define UDCLK_2 0X18	//Update Clock<15:8>
#define UDCLK_1 0X19	//Update Clock<7:0>
#define RRC_3 0X1A	//Ramp Rate Clock<19:16>
#define RRC_2 0X1B	//Ramp Rate Clock<15:8>
#define RRC_1 0X1C	//Ramp Rate Clock<7:0>
#define PD 0X1D		//Power Down:DC,DC,DC,Comp PD,0,QDAC PD,DAC PD,DIG PD
#define REFCLK 0X1E	//REFCLK:DC,PLL Range,Bypass PLL,RM4,RM3,RM2,RM1,RM0
#define MOD 0X1F	//MOD:CLR ACC1,CLR ACC2,Triangle,SRC QDAC,M2,M1,M0,Int Update Clk
#define OSK_S 0X20	//OSK&SERIAL COM:DC,Bypass Inv Sinc,OSK EN,OSK INT,DC,DC,LSB First,SDO Active
#define OSKI_2 0X21	//Output Shape Key I Mult<11:8>
#define OSKI_1 0X22	//Output Shape Key I Mult<7:0>
#define OSKQ_2 0X23	//Output Shape Key Q Mult<11:8>
#define OSKQ_1 0X24	//Output Shape Key Q Mult<7:0>
#define OSKRR 0X25	//Output Shape Key Ramp Rate<7:0>
#define QDAC_2 0X26	//QDAC<11:8>
#define QDAC_1 0X27	//QDAC<7:0>

