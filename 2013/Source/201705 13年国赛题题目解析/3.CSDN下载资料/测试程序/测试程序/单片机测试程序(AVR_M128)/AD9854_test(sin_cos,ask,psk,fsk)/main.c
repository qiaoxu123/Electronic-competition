#include"public.h"
#include"AD9854_test.h"

int main(void)
{
	Init_all();

	DDRA=0xff;				//BPSK，FSK，输出梯形ASK
	PORTA =0x00;

//	DDRA=0x00;				//ASK模式
//	PORTA |=0x01; 

//	SINGLE_MODE();			//单频点模式
//	SCAN_MODE();			//扫频模式
	UNRAMPFSK_MODE();		//FSK模式
//	ASK_MODE();				//梯形频率输出的ASK模式
//	BPSK_MODE();			//BPSK模式
//	Wind_ASK_MODE();		//矩形频率输出的ASK模式

	while(1)
	{
	
		PORTA |=0x01;				//用PA0产生一个方波，用于BPSK，FSK，输出梯形ASK等调制模式
		Delay(10);		
		PORTA &=~0x01;
		Delay(10);
	
	/*	if((PINA & 0x01)==0)		//ASK模式
		{							//以示波器的1KHZ标准发玻作为调制波，输入到单片机，控制频率控制字的写入
			CHOISE(0);
		}
		else
		{
			CHOISE(1);
		}*/
	}

	return 0;
}
