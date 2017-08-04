/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Labortory
* Data:					2017/5
* Function:				测试位同步提取电路
* 
* ==================================================================*/

`timescale 1ns/1ns
`define clk_period 20
`define m_period  5000

module Bit_sync_tb;

//source define 
	reg 	clk;
	reg	rst_n;
	
	//输入M序列
	reg	M_in;
	
	//输入按键，调节不同频率下的时钟提取
	reg 	sw;


//probe define
	wire [6:0] 	One_hundred_thousand_data;	//十万
	wire [6:0]	Ten_thousand_data;			//万
	wire [6:0]	Thousand_data;					//千
	wire [6:0]	Hundred_data;					//百
	wire [6:0]	Ten_data;						//十
	wire [6:0]	One_data;						//个	
	
	wire 			bit_sync;


//instant user module
	Bit_sync Bit_sync_test(
	
			.clk						(clk),
			.rst_n					(rst_n),
	
	//输入M序列
			.M_in						(M_in),
	
	//输入按键，调节不同频率下的时钟提取
			.sw						(sw),
	
	//输出到数码管相应位
			.One_hundred_thousand_data(One_hundred_thousand_data),	//十万
			.Ten_thousand_data	(Ten_thousand_data),			//万
			.Thousand_data			(Thousand_data),					//千
			.Hundred_data			(Hundred_data),					//百
			.Ten_data				(Ten_data),						//十
			.One_data				(One_data),						//个
	
	//输出位同步时钟
			.bit_sync				(bit_sync)

);

//generate clock

	initial clk = 1;
	initial M_in = 1;
	always #(`clk_period/2) clk = ~clk;
	always #(`m_period/2)	M_in= ~M_in;
	
	initial begin 
			rst_n = 1'b0;
		#(`m_period*20+1);
			rst_n = 1'b1;
			sw = 1'b1;
		#(`m_period*50);
			rst_n = 1'b1;
			sw = 1'b0;
		#(`m_period*50);
			
			
		
	end 
	
endmodule




