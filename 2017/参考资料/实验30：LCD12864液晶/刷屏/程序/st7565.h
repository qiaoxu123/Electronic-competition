#ifndef __ST7565_H
#define __ST7565_H

#include<reg51.h>
#include<intrins.h>

//---包含字库头文件
//#define CHAR_CODE


//---重定义关键词---//
#ifndef uchar
#define uchar unsigned char
#endif

#ifndef uint 
#define uint unsigned int
#endif

//--定时使用的IO口--//
#define DATA_PORT P0
sbit LCD12864_CS   = P3^2;
sbit LCD12864_RSET = P3^3;
sbit LCD12864_RS   = P2^6;
sbit LCD12864_RW   = P2^7;
sbit LCD12864_RD   = P2^5;

//--定义全局函数--//
void LcdSt7565_WriteCmd(cmd);
void LcdSt7565_WriteData(dat);
void Lcd12864_Init();
void Lcd12864_ClearScreen(void);
uchar Lcd12864_Write16CnCHAR(uchar x, uchar y, uchar *cn);

#endif
