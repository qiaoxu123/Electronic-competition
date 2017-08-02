#include"AD9854_test.h"

static Uchar8 frq_data[6];
//单频模式
static Ulong32 Frq_SINGAL=15000000;
static Uchar8 SINGLE_data[4]={0x10,0x47,0x00,0x40};
//扫频模式
static Ulong32 Frq_SCAN1=10000;
static Ulong32 Frq_SCAN2=100000;
static Uchar8 SCAN_data[4]={0x10,0x47,0x24,0x50};
static Uchar8 DFW_data[6]={0x00,0x00,0x00,0xff,0xff,0xff};		//控制扫频速率 数值越大扫频速率越快
static Uchar8 RAMP_data[3]={0xff,0xff,0xff};					//控制扫频步进 数值越小扫频步进越大
static Uchar8 Amp_data_1[2]={0xff,0xff};
static Uchar8 Amp_data_2[2]={0xff,0xff};
//非倾斜的FSK模式
static Uchar8 UnFsk_data[4]={0x10,0x47,0x02,0x40};
//static Uchar8 Phase_data_1[2]={0x10,0x00};//不用设置也行
//ASK调制模式
/*********************************************
			输出梯形的ASK调制模式
*********************************************/
static Uchar8 ASK_data[4]={0x10,0x47,0x00,0x70};	//
static Ulong32 Frq_ASK=100000;
static Uchar8 FSK_Amp_1[2]={0xff,0xff};
static Uchar8 FSK_Amp_2[2]={0x00,0x00};
/**********************************************
			输出矩形的ASK调制模式
**********************************************/
static Uchar8 Wind_ASK_data[4]={0x14,0x47,0x01,0x60};	//
static Ulong32 Wind_Frq_ASK=30000;
static Uchar8 Wind_FSK_Amp_1[2]={0xff,0xff};
static Uchar8 Wind_FSK_Amp_2[2]={0x00,0x00};
//BPSK调制模式
static Uchar8 BPSK_data[4]={0x10,0x47,0x08,0x40};
static Uchar8 Phase_data_1[2]={0x10,0x00};
static Uchar8 Phase_data_2[2]={0x30,0x00};

/*----------------总线延时-------------*/

void Delay_bus(Uchar8 i)
{
	while(i--)
	{
		asm("nop");asm("nop");	
	}
}

/*----------------普通延时--------------*/

void Delay(Uint16 t)
{
	Uint16 ii;
	while(t--)
	{
		for(ii=0;ii<10;ii++);
	}
}

/*---------------IO口初始化-------------*/

void IO_init(void)
{
	ADDRESS_DDR |= 0xff;
	DATA_DDR |= 0xff;
	CONTRL_DDR |= 0xff;
	CONTRL_PORT |= 0xc0;
}

/*--------------Updata更新函数----------*/

void Updata_CLK(void)
{
	IO_UPDATA_LOW();
	Delay(1);
	IO_UPDATA_HIGH();
}

/*------------复位引脚初始化函数---------*/

void MASTER_RST_Init(void)
{
	MASTER_RST_HIGH();
	Delay(10);
	MASTER_RST_LOW();
}

/*----------------总的初始化------------*/

void Init_all(void)
{
	IO_init();
	MASTER_RST_Init();	
}

/*-------------写入一个控制字------------*/

void WriteByte(Uchar8 address,Uchar8 data)
{
	WR_HIGH();
	ADDRESS_PORT = address;
	asm("nop");
	WR_LOW();
	DATA_PORT = data;
	asm("nop");
	WR_HIGH();
	asm("nop");
}

/*-----------频率控制字计算函数---------*/

void Count_frq(double frq)
{
	 frq_data[0]=((Ulong32)((frq*256)/280000000))&(0x0000000000ff);						  //高位
	 frq_data[1]=((Ulong32)((frq*65536)/280000000))&(0x0000000000ff);
	 frq_data[2]=((Ulong32)((frq*16777216)/280000000))&(0x0000000000ff);
	 frq_data[3]=((Ulong32)((frq*4294967296)/280000000))&(0x0000000000ff);
	 frq_data[4]=((Ulong32)((frq*1099511627776)/280000000))&(0x0000000000ff);
	 frq_data[5]=((Ulong32)((frq*281474976710656)/280000000))&(0x0000000000ff);			  //低位
}

/*------------配置AD9854工作模式---------

void Set_AD9854(void)
{												
	WR_HIGH();								//bit0:(=1)->数字部分进入掉电模式
	ADDRESS_PORT=0x1d;						//bit1:(=1)->I/Q 两路DAC进入掉电模式
	asm("nop");								//bit2:(=1)->QDAC进入掉电模式，关闭QDAC功能
	WR_LOW();								//bit3:保持低电平，如果设置为1，AD9854将停止工作直到再次复位。
	DATA_PORT=0x10;							//bit4:(Powr Down模式控制位) (=1)->使能掉电模式,关闭内部比较器  (=0)->正常模式
	asm("nop");								//bit5~7:don't care
	WR_HIGH();															
	asm("nop");

	//倍频7倍，时钟为280MHz
	WR_HIGH();
	ADDRESS_PORT=0x1e;						//bit0~bit4:内部时钟倍频数设置（4-20倍可选）
	asm("nop");								//bit5:旁路PLL使能位，(=1)->用(外部时钟)REFCLK直接驱动
	WR_LOW();								//bit6:VCO增益控制位  (=1)->系统时钟高于200MHZ    (=0)->系统时钟低于200MHZ
	DATA_PORT=0x47;							//bit7:don't care								
	asm("nop");
	WR_HIGH();							
	asm("nop");
	
	//设置Updata信号由外部输入，工作模式为单频模式
	WR_HIGH();
	ADDRESS_PORT=0x1f;						//bit0:内部刷新频率触发信号选择端口(=0)->由外部PIN20上升沿触发；(=1)->由内部时钟刷新
	asm("nop");								//bit1~3:选择AD9854工作模式(000->工作在单频点模式)
	WR_LOW();								//bit4:DAC取值通道选择位，(=0)->数字量由用户从芯片IO输入；(=1)->数字量为内部寄存器0x26和0x27的内容
	DATA_PORT=0x00;							//bit5:扫频功能使能位。(=1)->将在F1和F2频率之间扫频，但是这种情况下9854必须工作在Ramp FSK模式
	asm("nop");								//bit6:(=1)->将累加器ACC和ACC2全部复位为0，直到该位为0。
	WR_HIGH();								//bit7:(=1)->只把累加器ACC1复位为0，但是只在CHIRP MODE下设置，为了方便的获得锯齿波									
	asm("nop");	
											
	WR_HIGH();
	ADDRESS_PORT=0x20;						//bit0:激活串行数据输出
	asm("nop");								//bit1:串行数据数据输出顺序		bit2~3:don't care
	WR_LOW();								//bit4:数字乘法器取值选择位  (=0)->从内部I/Q两路乘法器地址取值地址I(0x21~0x22)地址Q(0x23~0x24)--(用于合成波形)；(=1)->由内部线性控制输出幅度
	DATA_PORT=0x40;							//bit5:数字乘法器使能位 (=1)->使能数字乘法器控制信号输出幅度(=0)->信号以最高幅度输出
	asm("nop");								//bit6:内部SINC滤波器使能位  =1）旁路内部sinc滤波器，降低功耗。滤波器对I/Q两路信号都有效，当使能Control DAC时没有滤波功能。
	WR_HIGH();								//bit7:don't care
	asm("nop");
}		*/


/*-----------AD9854设置特殊寄存器---------*/

void AD9854_SetSpecile(Uchar8 *spec)
{
	Uchar8 i = 0 ;
	Uchar8 spec_addr = 0;

	spec_addr = 0x1d;

	for(i = 0;i < 4;i ++ )
	{
		WriteByte(spec_addr + i,spec[i]);	
	}
}

/*----------设置相位寄存器1控制字----------*/   

void AD9854_SetPhase1(Uchar8 *phase)   
{    
      
    WriteByte( 0x00 , phase[0] );
        
    WriteByte( 0x01 , phase[1] );   
    
} 
   
/*----------设置相位寄存器2控制字----------*/   

void AD9854_SetPhase2(Uchar8 *phase)   
{    
    Uchar8 strPhase = 0 ;

	strPhase = *phase;   
    WriteByte( 0x02 , strPhase );
     
    strPhase = *(phase + 1);   
    WriteByte( 0x03 , strPhase );   
    
} 

/*------------设置三角波频率控制字---------*/  

void AD9854_SetDfw(Uchar8 *delta)   
{   
    Uchar8 i = 0 ;
	Uchar8 delta_addr = 0 ;   

    delta_addr = 0x10 ;
	   
    for( i = 0 ; i < 6 ; i ++ )   
    {   
        WriteByte( delta_addr + i , delta[i]);   
    }   
}  
  
/*--------------斜率寄存器控制字------------*/   

void AD9854_SetRamp(Uchar8 *ramp)   
{   
    Uchar8 i ;
	Uchar8 ramp_addr = 0 ;
	   
    ramp_addr = 0x1A;   
    
	for( i = 0 ; i < 3 ; i ++ )   
    {   		    
        WriteByte(ramp_addr + i, ramp[i]);         
    }   
}

/*----------设置频率寄存器1控制字--------*/
 
void AD9854_SetFreq1(Uchar8 *freq)   
{   
    Uchar8 i = 0 ;
	Uchar8 freq_addr = 0 ;   

    freq_addr = 0x04 ;
	   
    for( i = 0 ; i < 6 ; i ++ )   
    {   		  
        WriteByte( freq_addr + i , freq[i]);        
    }   
} 

/*----------设置频率寄存器2控制字--------*/

void AD9854_SetFreq2(Uchar8 *freq)   
{   
    Uchar8 i = 0 ;
	Uchar8 freq_addr = 0 ;   

    freq_addr = 0x0A ;
	   
    for( i = 0 ; i < 6 ; i ++ )   
    {   
        
        WriteByte( freq_addr + i , freq[i]);  
    }   
}
  
/*-------设置I路输出振幅寄存器控制字------*/    

void AD9854_SetOutkeyI(Uchar8 *Ikey)   
{   
    Uchar8 i ;
	Uchar8 OutkeyI_addr = 0;   
       
    OutkeyI_addr=0x21;     						//输出I振幅寄存器地址   
    
	for( i = 0 ; i < 2 ; i ++ )   
    {   
        
		WriteByte(OutkeyI_addr + i,Ikey[i]);  
    }   
} 
  
/*-------设置Q路输出振幅寄存器控制字------*/ 

void AD9854_SetOutkeyQ(Uchar8 *Qkey)   
{   
    Uchar8 i ;
	Uchar8 OutkeyQ_addr = 0;   
    
	OutkeyQ_addr = 0x23;                      	//输出Q振幅寄存器地址   
    
	for( i = 0 ; i < 2 ; i ++ )   
    {   
        
		WriteByte(OutkeyQ_addr + i,Qkey[i]);      
    }   
}  
  
/*----------输出振幅斜率寄存器控制字--------*/   

void AD9854_SetOutkeyRamp(Uchar8 Key_ramp)   
{   
    WriteByte(0x25, Key_ramp);     
} 

/*-------------设置QDAC寄存器的值-----------*/   

void AD9854_SetQDAC(unsigned char *QDAC)   
{   
    
	WriteByte(0x26 , QDAC[0]);

	WriteByte(0x27 , QDAC[1]);
	
}
/*--------------单频点模式设置------------*/  
/******************************************
	单频模式：(一般寄存器0x20设置为0x40)如果
寄存器0x20-数字乘法器使能位选择为0，即信号以
最高幅度输出，那么单频模式的输出只需要设置频
率控制字1的频率即可。
	设置特殊寄存器0x20为0x60时，则两个幅度寄
存器分别控制两路输出信号幅度。
	设置特殊寄存器0x20为0x70时，则其中一个幅
度寄存器用于控制一路输出信号幅度，另一路用于
合成信号。
******************************************/

void SINGLE_MODE(void)
{      
  	AD9854_SetSpecile(SINGLE_data);

	Count_frq(Frq_SINGAL);
	AD9854_SetFreq1(frq_data); 

	Updata_CLK();
} 

/*----------------扫频模式设置-------------*/

void SCAN_MODE(void) 
{
	AD9854_SetSpecile(SCAN_data);

	AD9854_SetOutkeyI(Amp_data_1);	
	AD9854_SetOutkeyQ(Amp_data_2);

	Count_frq(Frq_SCAN1);
	AD9854_SetFreq1(frq_data);
	Count_frq(Frq_SCAN2);
	AD9854_SetFreq2(frq_data); 

	AD9854_SetDfw(DFW_data);
	AD9854_SetRamp(RAMP_data);

	Updata_CLK();
}

/*---------------非倾斜的FSK模式------------*/
/*********************************************
	通过外部FBH同步信号，使得模块输出频率在F1
和F2之间转换，即为2FSK调制。测试时示波器要选择
单次触发模式。
*********************************************/

void UNRAMPFSK_MODE(void)
{
	Count_frq(Frq_SCAN1);
	AD9854_SetFreq1(frq_data);
	Count_frq(Frq_SCAN2);
	AD9854_SetFreq2(frq_data);

	AD9854_SetSpecile(UnFsk_data);

	Updata_CLK();	 
}


/*-----------------ASK调制模式---------------*/
/*********************************************
			输出梯形的ASK调制模式
	这种模式是根据写入的OSK RAMP rate控制字来
决定从0幅度到满幅度的转换时间，控制子最小只能
到0x03,再小就不能正常输出波形。
*********************************************/

void ASK_MODE(void)
{
	Count_frq(Frq_ASK);
	AD9854_SetFreq1(frq_data);

	AD9854_SetOutkeyI(FSK_Amp_1);	
	AD9854_SetOutkeyQ(FSK_Amp_2);

	AD9854_SetOutkeyRamp(0x03);   				//0幅度到满幅度过渡时间，即渐变的速率，越小转换的越快，越大转换的越慢 
	
	AD9854_SetSpecile(ASK_data);

	Updata_CLK();
		
}

/**********************************************
			输出矩形的ASK调制模式
	这种模式，是通过不断扫描单片机端口来获得调
制信号，然后根据端口的电平高低，用CHOISE函数选择
写入的频率控制字，看是否输出频率。（通过不断的对
AD9854写控制字，控制其是否输出频率来实现ASK调制）
	这个模式最好用内部时钟，能自动更新控制字，而
且速度很快。
**********************************************/

void Wind_ASK_MODE(void)
{
	Count_frq(Wind_Frq_ASK);
	AD9854_SetFreq1(frq_data);
	
	AD9854_SetSpecile(Wind_ASK_data);
	
}

/*-------------------选择输出----------------*/

void CHOISE(Uchar8 i)
{
	if(i==0)
	{
		AD9854_SetOutkeyI(Wind_FSK_Amp_2);	
		AD9854_SetOutkeyQ(Wind_FSK_Amp_2);
	}
	else
	{
		AD9854_SetOutkeyI(Wind_FSK_Amp_1);	
		AD9854_SetOutkeyQ(Wind_FSK_Amp_1);
	}
}
		
/*-----------------BPSK调制模式--------------*/

void BPSK_MODE(void)
{
	AD9854_SetSpecile(BPSK_data);

	Count_frq(Frq_SCAN1);
	AD9854_SetFreq1(frq_data);

	AD9854_SetPhase1(Phase_data_1);
	AD9854_SetPhase2(Phase_data_2);

	Updata_CLK();
}




