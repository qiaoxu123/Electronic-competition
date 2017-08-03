/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Labortory
* Data:					2017/
* Function:				
* 
* ==================================================================*/

`timescale 1ns/1ns
`define clk_period 20

module Digital_Freq_top_tb;

//source define 
	reg clk;
	reg rst_n;
	reg One_Signal_in;
	reg Two_Signal_in;


//probe define
	wire 	One_TestSignal_num;    
	wire 	Two_TestSignal_num;    
	wire 	StandSignal_num; // fre
	wire 	Time_interval; // time_
	wire 	Single_Time_interval_a;
   wire 	Single_Time_interval_b;
   wire 	Whole_Time_interval_a;
	wire 	Whole_Time_interval_b;  
	
//instant user module
	Digital_Freq_top Digital_Freq_top_module(
	
		//共用引脚部分
		.clk							(clk),	
		.rst_n						(rst_n),
		.One_Signal_in				(One_Signal_in),	//输入A路信号
		.Two_Signal_in				(Two_Signal_in),	//输入B路信号
		
		.One_TestSignal_num		(One_TestSignal_num),    
		.Two_TestSignal_num		(Two_TestSignal_num),    
		.StandSignal_num			(StandSignal_num), // fre
		.Time_interval				(Time_interval), // time_
		.Single_Time_interval_a	(Single_Time_interval_a),
		.Single_Time_interval_b	(Single_Time_interval_b),
		.Whole_Time_interval_a	(Whole_Time_interval_a), 
		.Whole_Time_interval_b	(Whole_Time_interval_b) 

);



//generate clock

	initial clk = 1;
	always #(`clk_period/2) clk = ~clk;
	initial One_Signal_in = 1;
	always #(`clk_period/200) One_Signal_in = ~One_Signal_in;
	initial Two_Signal_in = 1;
	always #(`clk_period/2) Two_Signal_in = ~Two_Signal_in;
	
	
	initial begin 
		rst_n = 1'b0;
		#(`clk_period*10);
		rst_n = 1'b1;
		#(`clk_period*50);
	
		
	end 
	
endmodule
