//=====================================================================
//                    多功能高频测试仪程序
//硬件连接: 见各个子文件 
//文件名：  DDS.c
//writer:   谷雨 2008年8月23日于EDA实验室
//说明：    本程序为课题答辩程序
//=====================================================================

/**********************************4*4键盘操作界面***********************/
/*	           
         0           1            2             3

		 4			 5			  6				7

		 8			 9			FSK/HZ        RFSK/KHZ

	   BPSK/MHZ	  清零/OSK	    退出/AM		  确定/SIN
*/

#include <STC89C51RC.h>               //STC单片机头文件	
#include "AD9854.h"  
#include "ocmj.h"
#include "key.h" 
#include "menu.h"

#define uint  unsigned int
#define uchar unsigned char

int main(void)
{
	uchar KEY;

	AD9854_Init();
	init_lcd();
	show_kaiji();
	show_select();	
	while(1)
	{
		KEY=Key_Get();
		if(KEY!=0xff)
		{
			switch(KEY)
			{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
					show_error();
					break;
				case 10:
					show_FSK();
					break;
				case 11:
					show_RFSK();
					break;
				case 12:
					show_BPSK();
					break;
				case 13:
					show_OSK();
					break;
				case 14:
					show_AM();
					break;
				case 15:
					show_SIN();
					break;
				default:
				    break;
			}
			KEY=0xff;
		}	
	} 
}

