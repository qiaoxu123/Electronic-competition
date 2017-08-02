#define uchar unsigned char
#define ulong unsigned long
#define uint unsigned int
#define data_out P6OUT
#define data_in P6IN
#define data_dir P6DIR
#define add_out P8OUT
#define add_dir P8DIR
#define ctrl_out P1OUT
#define ctrl_dir P1DIR
#define UDCLK BIT6
#define WR BIT5
#define RD BIT4
#define FBH BIT3
#define SK BIT2
#define SP BIT1
#define RST BIT0
void send_byte(uchar add,uchar data);
uchar read_byte(uchar add);
uchar table9854[8];
//**********初始化AD9854*********//
void init_9854()
{                           
  data_dir=0xFF;
  add_dir=0xff;
  ctrl_dir=0xff;
  ctrl_out=0x32;     //CP,UDCLK,F/B/H,SK,RST=0;WR,RD,S/P=1 0011 0010
  ctrl_out|=RST;  //一个一毫秒的高电平脉冲
  _NOP();
  ctrl_out&=~RST;          //1F为默认值，即Triangle=0，QDAC为内部输入，模式0，内部刷新时钟
  send_byte(REFCLK,0x04);     //PLL小于200MHz，不旁路PLL，4倍频  dc,pllrange,bypasspll,ref4  ref3,ref2,ref1,ref0             
  _NOP();_NOP();_NOP();_NOP();   //延时4us，以保证数据写入
  send_byte(UDCLK_1,0x20);     //将刷新周期改为(32+1)*(1/160M)*2=412.5ns，保证发送1字节数据的周期大于刷新周期 
  _NOP();_NOP();  //延时2us，以保证数据写入
  send_byte(PD,0x17);     //power down所有模块
  send_byte(OSK_S,0x20);     //不旁路Inv Sinc，使能OSK EN
  send_byte(PD,0x04);         //turn on I DAC and DIG,but still off Q DAC,PD: CR,DC,DC,COMP,  0,QDAC,DAC,DIG
}                               //DAC开了IDAC就开了，给1就关
//**********发送1字节数据************//
void send_byte(uchar add,uchar data)
{
  data_dir=0xff;  //设置数据IO口为输出
  ctrl_out|=WR;    //拉高wr
  add_out=add;        //给并口地址A
  _NOP();   //延时7ns以上
  ctrl_out&=~WR;      //拉低WR
  data_out=data;      //送数据
  _NOP();  //延时2.5ns以上
  ctrl_out|=WR;       //拉高WR
  _NOP();  //延时一下
}
//**********读取一个字节的数据**********//
uchar read_byte(uchar add)
{
  uchar dat;
  data_dir=0x00;  //设置数据IO口为输入
  ctrl_out|=RD;  //拉高RD
  add_out=add;  //给并口地址
  _NOP();  //延时20ns以上
  ctrl_out&=~RD; //拉低RD
  _NOP(); //延时15ns以上
  dat=data_in; //读并口数据；
  return dat;
}
void ad9854f(double f) 
{
  table9854[0]=(uchar)((f*256)/160000000);//高位
  table9854[1]=(uchar)(((f*256)/160000000-table9854[0])*256);//去掉整数部分，用原来的数减整数再乘256
  table9854[2]=(uchar)((((f*256)/160000000-table9854[0])*256-table9854[1])*256);
  table9854[3]=(uchar)(((((f*256)/160000000-table9854[0])*256-table9854[1])*256-table9854[2])*256);
  table9854[4]=(uchar)((((((f*256)/160000000-table9854[0])*256-table9854[1])*256-table9854[2])*256-table9854[3])*256);
  table9854[5]=(uchar)(((((((f*256)/160000000-table9854[0])*256-table9854[1])*256-table9854[2])*256-table9854[3])*256-table9854[4])*256);
  send_byte(FTW1_6,table9854[0]);     //M=f*2^48/160 算出来的M转为2进制
  send_byte(FTW1_5,table9854[1]);   
  send_byte(FTW1_4,table9854[2]);
  send_byte(FTW1_3,table9854[3]);
  send_byte(FTW1_2,table9854[4]);
  send_byte(FTW1_1,table9854[5]);
}
void ad9854v(float v) 
{
  if(v>=1)
  {
    table9854[6]=0xff;
    table9854[7]=0xff; 
  }
  else
  {
    table9854[6]=((uint)(v*4096))/256;//高位
    table9854[7]=((uint)(v*4096))%256;//用原来的数取余256
  }
  send_byte(OSKI_2,table9854[6]);    //0~11位  2^12  1V  (x/4096)*1=K   x=4096k
  send_byte(OSKI_1,table9854[7]);   
  send_byte(OSKQ_2,table9854[6]);   
  send_byte(OSKQ_1,table9854[7]);
}