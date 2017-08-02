#ifndef _AD9854_TEST_H_
#define _AD9854_TEST_H_

#include"public.h"

/*--------------单频点模式设置------------*/  
void SINGLE_MODE(void);
/*----------------普通延时--------------*/
void Delay(Uint16 t);
/*----------------总线延时-------------*/
void Delay_bus(Uchar8 i);
/*----------------总的初始化------------*/
void Init_all(void);
/*----------------扫频模式设置-------------*/
void SCAN_MODE(void);
/*---------------非倾斜的FSK模式------------*/
void UNRAMPFSK_MODE(void); 
/*-----------------ASK调制模式---------------*/
/*********************************************
			输出梯形的ASK调制模式
*********************************************/
void ASK_MODE(void);
/**********************************************
			输出矩形的ASK调制模式
**********************************************/
void Wind_ASK_MODE(void);
/*-------------------选择输出----------------*/
void CHOISE(Uchar8 i);
/*-----------------BPSK调制模式--------------*/
void BPSK_MODE(void);

#define ADDRESS_DDR				DDRE
#define ADDRESS_PORT			PORTE
#define ADDRESS_PIN				PINE

#define DATA_DDR				DDRC
#define DATA_PORT				PORTC
#define DATA_PIN				PINC

#define CONTRL_DDR				DDRB
#define CONTRL_PORT 			PORTB
#define CONTRL_PIN				PINB

//#define FBH						2
//#define SK						3
#define MASTER_RST				4
#define IO_UPDATA				5
#define RD						6
#define WR						7

#define MASTER_RST_HIGH()		CONTRL_PORT |= (1 << MASTER_RST)
#define MASTER_RST_LOW()		CONTRL_PORT &= ~(1 << MASTER_RST)

#define IO_UPDATA_HIGH()		CONTRL_PORT |= (1 << IO_UPDATA)
#define IO_UPDATA_LOW()			CONTRL_PORT &= ~(1 << IO_UPDATA)

#define RD_HIGH()				CONTRL_PORT |= (1 << RD)
#define RD_LOW()				CONTRL_PORT &= ~(1 << RD)

#define WR_HIGH()				CONTRL_PORT |= (1 << WR)
#define WR_LOW()				CONTRL_PORT &= ~(1 << WR)

#endif
