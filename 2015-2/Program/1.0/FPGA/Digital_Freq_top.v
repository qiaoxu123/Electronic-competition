/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				实现labview接收频率检测信号，在上位机输出频率，占空比，时间间隔等信息
* 
* ==================================================================*/

module Digital_Freq_top(
	
	//共用引脚部分
	input wire 			 clk,	
	input	wire			 rst_n,
//	input wire 			 One_Signal_in,	//输入A路信号
//	input wire 			 Two_Signal_in,	//输入B路信号
	input wire [3:0] 	 sw,
	
	//串口接收部分
	input  wire        uart_rxd,      //  uart.rxd
	output wire        uart_txd,       //      .txd
	
	//Nios模块引脚
	output wire [12:0] sdram_addr,    // sdram.addr
	output wire [1:0]  sdram_ba,      //      .ba
	output wire        sdram_cas_n,   //      .cas_n
	output wire        sdram_cke,     //      .cke
	output wire        sdram_cs_n,    //      .cs_n
	inout  wire [15:0] sdram_dq,      //      .dq
	output wire [1:0]  sdram_dqm,     //      .dqm
	output wire        sdram_ras_n,   //      .ras_n
	output wire        sdram_we_n,     //      .we_n
	output wire 		 sdram_clk
	
);
//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire [31:0] One_TestSignal_num;        //   freq_a.export
   wire [31:0] Two_TestSignal_num;       	//   freq_b.export
   wire [31:0] StandSignal_num; 				// freq_standard.export
   wire [31:0] Time_interval; 				// time_interval.export
   wire [31:0] Single_Time_interval_a;  	//  duty_cycle_a.export
   wire [31:0] Single_Time_interval_b; 	//  duty_cycle_b.export
   wire [31:0] Whole_Time_interval_a;  	//  whole_time_a.export
   wire [31:0] Whole_Time_interval_b;   	//  whole_time_b.export
	
//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 信号产生模块 ****************************/
	Signal_born Signal_born_module(
	
		.clk				(clk),	
		.rst_n			(rst_n),
		.sw				(sw),

		.One_Signal_in	(One_Signal_in),
		.Two_Signal_in	(Two_Signal_in)
);
	
	
	
	/************************* 测频模块 ****************************/
	Freq_check Freq_check_module(
	
		.clk						(clk),	
		.rst_n					(rst_n),
		.One_Signal_in			(One_Signal_in),
		.Two_Signal_in			(Two_Signal_in),
		
		.One_TestSignal_num	(One_TestSignal_num),  //A路信号在闸门时间内的个数
		.Two_TestSignal_num	(Two_TestSignal_num),   //B路信号在闸门时间内的个数
		.StandSignal_num		(StandSignal_num)		  //标准信号在闸门时间内的个数
	);
	
	/************************* 测量时间间隔模块 ****************************/
	Time_period_check Time_period_check_module(
	
		.clk						(clk),	
		.rst_n					(rst_n),
		.One_Signal_in			(One_Signal_in),	//待测信号1
		.Two_Signal_in			(Two_Signal_in),	//待测信号2
		
		.Time_interval			(Time_interval)  //1000个周期内，两信号的时间间隔
	);
	
	/*************************  测量占空比模块 ****************************/
	Duty_Cycle Duty_Cycle_module(
	
		.clk							(clk),	
		.rst_n						(rst_n),
		
		.One_Signal_in				(One_Signal_in),  //A路信号输入
		.Two_Signal_in				(Two_Signal_in),   //B路信号输入
		
		.Single_Time_interval_a	(Single_Time_interval_a),  //A路信号1000个波峰时间总长
		.Whole_Time_interval_a	(Whole_Time_interval_a),   //A路信号周期总长
		.Single_Time_interval_b	(Single_Time_interval_b),  //b路信号1000个波峰的时间总长
		.Whole_Time_interval_b	(Whole_Time_interval_b)    //b路信号1000个周期总长
	);
	
	/*************************   Nios模块 ****************************/
	
	Nios Nios_module (
       .clk                  (clk),              //           clk.clk
       .rst_n        		  (rst_n),        //         reset.reset_n
       .sdram_addr           (sdram_addr),           //         sdram.addr
       .sdram_ba             (sdram_ba),             //              .ba
       .sdram_cas_n          (sdram_cas_n),          //              .cas_n
       .sdram_cke            (sdram_cke),            //              .cke
       .sdram_cs_n           (sdram_cs_n),           //              .cs_n
       .sdram_dq             (sdram_dq),             //              .dq
       .sdram_dqm            (sdram_dqm),            //              .dqm
       .sdram_ras_n          (sdram_ras_n),          //              .ras_n
       .sdram_we_n           (sdram_we_n),           //              .we_n
		 .sdram_clk				  (sdram_clk),
       .uart_rxd             (uart_rxd),             //          uart.rxd
       .uart_txd             (uart_txd),             //              .txd
       .freq_a_export        (One_TestSignal_num),        //        freq_a.export
       .freq_b_export        (Two_TestSignal_num),        //        freq_b.export
       .freq_standard_export (StandSignal_num), // freq_standard.export
       .time_interval_export (Time_interval), // time_interval.export
       .duty_cycle_a_export  (Single_Time_interval_a),  //  duty_cycle_a.export
       .duty_cycle_b_export  (Single_Time_interval_b),  //  duty_cycle_b.export
       .whole_time_a_export  (Whole_Time_interval_a),  //  whole_time_a.export
       .whole_time_b_export  (Whole_Time_interval_b)   //  whole_time_b.export
   );	


endmodule
