/////////////////////////////////////
//  Generated Initialization File  //
/////////////////////////////////////

#include <c8051f020.h>
#include <intrins.h>


//---------------------------
#define   ADDRESS   P2
#define   DATA      P1
#define   ulong     unsigned long 
#define   uchar     unsigned char 

sbit MASTER_RESET = P3^3;    
sbit IO_UPDATE    = P3^4;
sbit FBH          = P3^5;       //fsk/bpsk/hold
sbit RD           = P3^6;
sbit WR           = P3^7;
sbit SHAPED_LEYING= P0^3;  

uchar  temp;
uchar  TAB_Data[40];

////////////////////////////////////////////
////////////////////////////////////////////
/////////////////////////////////////////

ulong  fre=10000000;//输出频率
//////////////////////////////////////////
///////////////////////////////////////////
//////////////////////////////////////////

void AD9854_IO_INT();
void TAB_DataWord(double);
void V_init();


//-----------------------
void delay(long t)
{   
  unsigned int i=0;
   	while(t--)
  	for(i=0;i<=1000;i++);
}

//--------------------------
void update(void)   
{
	IO_UPDATE=0; 
	delay(10);	
	IO_UPDATE=1;
//	delay(0);
	
}

//----------------------
void Port_IO_Init()
{
    
    P0MDOUT   = 0xff;
    P1MDOUT   = 0xFF;
    P2MDOUT   = 0xFF;
    P3MDOUT   = 0xFF;
    XBR2      = 0x40;
}
//-------------------------
void Oscillator_Init()
{
    OSCICN    = 0x07;
}
//---------------------------

void Init_Device(void)
{
    Port_IO_Init();
    Oscillator_Init();
}

////////////////////////////////////////////////////////
//**********************************************************
void main (void)
{
	
   	WDTCN = 0xde;           //关看门狗
   	WDTCN = 0xad;

   	Init_Device();	   

    V_init();   
	TAB_DataWord(fre);
	AD9854_IO_INT();
     while(1);

 }
//////////////////////////////////////////////////////
//****************************************************


void TAB_DataWord(double f)
  
  {     
         

  //////////////////////////////////////////////////
 //------------ phase  turning word 1----------------
     TAB_Data[0]=0x00;   //高位
	 TAB_Data[1]=0x00;   //低位
  //------------ phase  turning word 2----------------
	 TAB_Data[2]=0x00;   //高位
	 TAB_Data[3]=0x00;   //低位

/////////////////////////////////////////////////
//------------ frequency  turning word 1----------------
     TAB_Data[4]=((ulong)((f*256)/300000000))&(0x0000000000ff);//  0x00;//  //高位
	 TAB_Data[5]=((ulong)((f*65536)/300000000))&(0x0000000000ff);//0x00;//
	 TAB_Data[6]=((ulong)((f*16777216)/300000000))&(0x0000000000ff);//0x9f;//
	 TAB_Data[7]=((ulong)((f*4294967296)/300000000))&(0x0000000000ff);//0x16;//
	 TAB_Data[8]=((ulong)((f*1099511627776)/300000000))&(0x0000000000ff);//0xb1;//
	 TAB_Data[9]=((ulong)((f*281474976710656)/300000000))&(0x0000000000ff);//0x1c;//
//------------ frequency  turning word 2----------------
     TAB_Data[10]=0x00;    //高位
	 TAB_Data[11]=0x00;
	 TAB_Data[12]=0x00;
	 TAB_Data[13]=0x00;
	 TAB_Data[14]=0x00;
	 TAB_Data[15]=0x00;   
/////////////////////////////////////////////////
//------------ delta  frequency  word 1----------------
     TAB_Data[16]=0x00;    //高位
	 TAB_Data[17]=0x00;
	 TAB_Data[18]=0x00;
	 TAB_Data[19]=0x00;
	 TAB_Data[20]=0x00;
	 TAB_Data[21]=0x00;     //低位   三角波  


/////////////////////////////////////////////////
//------------ update  clock----------------
     TAB_Data[22]=0x00;    //高位
	 TAB_Data[23]=0x00;
	 TAB_Data[24]=0x00;
	 TAB_Data[25]=0x00;   //低位


/////////////////////////////////////////////////
//------------ ramp rate  clock----------------
	 TAB_Data[26]=0x00;
	 TAB_Data[27]=0x00; 
	 TAB_Data[28]=0x00;  

/////////////////////////////////////////////////
//------------ 初始化预设----------------
     TAB_Data[29]=0x00;    //高位   
	 TAB_Data[30]=0x00;    ///300M
	 TAB_Data[31]=0x00;
	 TAB_Data[32]=0x00;   //低位


/////////////////////////////////////////////////
//------------ output shape key  I Mul----------------
     TAB_Data[33]=0x00;       
	 TAB_Data[34]=0x00; 
//------------ output shape key  Q Mul----------------  
     TAB_Data[35]=0x00;       
	 TAB_Data[36]=0x00;  


/////////////////////////////////////////////////
//------------ output shape key ramp rate-------------
     TAB_Data[37]=0x00; 



/////////////////////////////////////////////////
//------------QDAC-------------
     TAB_Data[38]=0x00; 
	 TAB_Data[39]=0x00;
    
	} 



//***********************************************************
void AD9854_IO_INT()
{
   uchar i;

   MASTER_RESET=0; 
   FBH=0;  
   SHAPED_LEYING=1;//使上斜或下斜的引脚
 
   temp=0;    

  for(i=0;i<40;i++)
   {
     ADDRESS=temp;     //送地址
     DATA=TAB_Data[i];
     WR=0;
	 WR=1;
	 WR=0;
     temp++; 
   }
    update();
	delay(2);
}


  void V_init(void)         

{
                  
 	MASTER_RESET=0;               

    
	ADDRESS=0x1d;
	DATA=0x00;
	WR=0;
	WR=1;
	WR=0;
	
	ADDRESS=0x1e;//倍频5倍，时钟为200MHz
	DATA=0x45;
	WR=0;
    WR=1;
	WR=0;
	
	ADDRESS=0x1f;
	DATA=0x00;
	WR=0;
    WR=1;
	WR=0;
	
	ADDRESS=0x20;
	DATA=0x40;
	WR=0;
    WR=1;
	WR=0;

	update();

    delay(2);

  }
  
              