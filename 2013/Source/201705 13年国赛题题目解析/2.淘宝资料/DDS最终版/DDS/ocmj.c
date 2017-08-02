//=====================================================================
//                    OCMJ4X8C 液晶驱动程序(串行)
//硬件连接: cs   ——  P2^6;	  
//          std  ——  P3^1;    
//          sclk ——  P3^0;     
//          psb  ——  VSS;   
//          rst  ——  VDD; 
//          VDD  ——  逻辑电源(+5V)
//          VSS  ——  GND(0V)  
//ocm4x8c(串).c
//writer:谷雨 2008年3月12日于EDA实验室整理
//=====================================================================
#include <STC89C51RC.h>      //STC单片机头文件

#define uint  unsigned int
#define uchar unsigned char

static void wr_lcd (uchar dat_comm,uchar content);
static void delay (uint us);

#define comm  0
#define dat   1
#define x1    0x80
#define x2    0x88
#define y     0x80

//**************************修改硬件时要修改的部分********************************

sbit cs   = P0^0;	  //串行口使能，高电平有效（作RS时，1为数据，0为指令）
sbit std  = P0^1;     //串口数据（作R/W时，1为读，0为写）
sbit sclk = P0^2;     //串口时钟，高电平有效

//================================================================= 
// 函数名称 ：void init_lcd (void)
// 函数功能 ：实现lcd初始化  
// 入口参数 ：无
// 出口参数 ：无
//================================================================= 
void init_lcd (void)
{
	delay(100);
	wr_lcd (comm,0x30);  //30---基本指令动作
	wr_lcd (comm,0x01);  //清屏，地址指针指向00H
	delay (100);         //清屏需较长时间
	wr_lcd (comm,0x06);  //光标的移动方向
    wr_lcd (comm,0x0c);  //显示打开，光标关，反白关
}

//=================================================================
//函数名:void set_position(unsigned int a,unsigned int b) 
//函数功能: 设定显示坐标
//入口参数:xx  yy    
//          xx:0~3   yy:0~7
//出口参数：无
//=================================================================   
void set_position(unsigned int xx,unsigned int yy) 	//坐标    
{ 
   unsigned int line;
   wr_lcd (comm,0x30);  //30---基本指令动作
   switch(xx)
   {
     case 0:line=0x00;break;	
     case 1:line=0x10;break;
     case 2:line=0x08;break;
     case 3:line=0x18;break;
     default:break;
    }
   wr_lcd(comm,0x80+line+yy);		  //设定地址
} 

//================================================================= 
//函数名:void send_str(unsigned char *cc) 
//函数功能: 显示汉字或是字符
//入口参数:*cc 
//出口参数：无   
//注意:注意为全角字符,即每个字符占十六个字节
//     显示汉字或者字符时先设定显示坐标，最多显示8个汉字           
//=================================================================         
void send_str(uchar code *cc)  
{
   unsigned int i;
   wr_lcd (comm,0x30); 
   for(i=0;(i<16)&&*(cc+i);i++)
   {
   		wr_lcd(dat,*(cc+i));
   }     
}

//================================================================= 
//函数名:void send_chin(uchar code *cc) 
//函数功能: 显示单个汉字
//入口参数:*cc 
//出口参数：无            
//=================================================================         
void send_chin(uchar code *cc)  
{
   unsigned int i;
   wr_lcd (comm,0x30); 
   for(i=0;(i<2)&&*(cc+i);i++)
   {
   		wr_lcd(dat,*(cc+i));
   }     
}

//================================================================= 
//函数名:void send_char(uchar cc) 
//函数功能: 显示一个字符
//入口参数: cc 
//出口参数：无          
//=================================================================         
void send_char(uchar cc)  
{
   wr_lcd (comm,0x30); 
   wr_lcd(dat,cc);     
}

//=================================================================
//函数名:void send_img(unsigned code *img)
//函数功能: 显示图形
//入口参数:uchar code *img     
//出口参数：无
//注意：显示图形时先写第一行数据，依次向后  
//=================================================================  
void send_img (uchar code *img)
{
  uchar i,j;
  for(j=0;j<32;j++)			   //上半屏写入图形数据
  {
    for(i=0;i<8;i++)
    {
      wr_lcd (comm,0x34);	//8位控制端口，选择扩充指令集
      wr_lcd (comm,y+j);	//选择图形区Y轴坐标
      wr_lcd (comm,x1+i);	 //选择图形区X轴坐标
      wr_lcd (comm,0x30);	 //选择基本指令集
      wr_lcd (dat,img[j*16+i*2]);	//写图形数据
      wr_lcd (dat,img[j*16+i*2+1]);
    }
  }
  for(j=32;j<64;j++)			//下半屏写入图形数据
  {
    for(i=0;i<8;i++)
    {
      wr_lcd (comm,0x34);
      wr_lcd (comm,y+j-32);
      wr_lcd (comm,x2+i);
      wr_lcd (comm,0x30);
      wr_lcd (dat,img[j*16+i*2]);
      wr_lcd (dat,img[j*16+i*2+1]);
    }
  }
  wr_lcd (comm,0x36);		//写入数据后选择图形显示
}

//=================================================================
//函数名:void lat_disp (uchar data1,uchar data2)
//函数功能:显示点阵
//入口参数:uchar data1 奇数行显示的点阵
//         uchar data2 偶数行显示的点阵 
//出口参数：无
//================================================================= 
void lat_disp (uchar data1,uchar data2)
{
  uchar i,j,k,x;
  x=x1;
  for(k=0;k<2;k++)
  {
    for(j=0;j<16;j++)
    {
      for(i=0;i<8;i++)
      {
        wr_lcd (comm,0x34);		  //8位控制端口，选择扩充指令集
        wr_lcd (comm,y+j*2);	  //Y轴
        wr_lcd (comm,x+i);		  //X轴
        wr_lcd (comm,0x30);		  //选择基本指令集
        wr_lcd (dat,data1);		  //写入数据
        wr_lcd (dat,data1);
      }
      for(i=0;i<8;i++)
      {
        wr_lcd (comm,0x34);
        wr_lcd (comm,y+j*2+1);
        wr_lcd (comm,x+i);
        wr_lcd (comm,0x30);
        wr_lcd (dat,data2);
        wr_lcd (dat,data2);
      }
    }
    x=x2;
  }
  wr_lcd (comm,0x36);		//写入数据后选择显示
}

//=================================================================
//函数名:void clear() 
//函数功能:清屏 
//入口参数:无
//出口参数：无 
//================================================================= 
void clear (void)
{
  wr_lcd (comm,0x30);	  //选择基本指令集
  wr_lcd (comm,0x01);	  //清屏
  delay (180);			  //延时
}

//=================================================================
//函数名:void clear_line(uint line) 
//函数功能:清除一行 
//入口参数: line 0~3
//出口参数：无
//================================================================= 
void clear_line(uint line)  //清除一行（0~3行） 
{
	uint i;
	set_position(line,0);
	for(i=0;i<16;i++)
    wr_lcd (dat,0x20);//填充空格  
}

//================================================================= 
// 函数名称 ：void delay (uint us)
// 函数功能 ：延时
// 入口参数 ：us  延时时间的长短
// 出口参数 ：无
//================================================================= 
void delay (uint us)   
{
  while(us--);
}

//================================================================= 
// 函数名称 ：void wr_lcd (uchar dat_comm,uchar content)
// 函数功能 ：向lcd中写数据或者指令  
// 入口参数 ：dat_comm 选择是写数据或者写指令位
//            content    dat_comm为1时写数据，否则写指令
// 出口参数 ：无
//================================================================= 
void wr_lcd (uchar dat_comm,uchar content)
{
 	uchar a,i,j;
    delay (50);	   //延时，等待内部动作完成
    a=content;
  	cs=1;
  	sclk=0;
  	std=1;
  	for(i=0;i<5;i++)		 //写入5个1，作为启动位
  	{
    	sclk=1;
    	sclk=0;
  	}
  	std=0;
  	sclk=1;
  	sclk=0;
  	if(dat_comm)			 //判断写数据还是指令
    	std=1;   //data
  	else
    	std=0;   //command
  	sclk=1;
  	sclk=0;
  	std=0;					//写入1个0
  	sclk=1;
  	sclk=0;
  	for(j=0;j<2;j++)		 
  	{
    	for(i=0;i<4;i++)	//分别写入高四位和低四位
    	{
    		a=a<<1;
    		std=CY;
    		sclk=1;
    		sclk=0;
    	}
    	std=0;				   //写入4个0
    	for(i=0;i<4;i++)
    	{
      		sclk=1;
      		sclk=0;
    	}
  	}
}