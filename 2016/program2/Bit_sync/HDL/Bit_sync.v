/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5/25
* Function:				B机位同步提取电路部分的顶层文件
* 
* ==================================================================*/

module Bit_sync(
	
	input wire 	clk,
	input	wire	rst_n,
	
	//输入M序列
	input			M_in,
	
	//输入按键，调节不同频率下的时钟提取
	input 		sw,
	
	//输出到数码管相应位
	output wire [6:0] One_hundred_thousand_data,	//十万
	output wire [6:0]	Ten_thousand_data,			//万
	output wire [6:0]	Thousand_data,					//千
	output wire [6:0]	Hundred_data,					//百
	output wire [6:0]	Ten_data,						//十
	output wire [6:0]	One_data,						//个
	
	//输出位同步时钟
	output		bit_sync

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire 			M_edge;
	wire [31:0]	M_period;
	wire [19:0]	sync_period;

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* M序列接收部分 ****************************/
	//接收A机发送来的M序列，并根据不同的ck信号速率，改变提取出的最小时钟周期
	M_Receive M_Receive_test(
	
		.clk			(clk),
		.rst_n		(rst_n),	
		
		.M_in			(M_in),			//输入产生的M序列
		
		.M_edge		(M_edge),		//输出提取出的码元脉冲边沿
		.M_period	(M_period)		//根据不同的ck时钟速率，提取出M序列不同的最小时钟周期

	);
	
	/************************* 位同步信号提取 ****************************/
	
	sync_signal_collect sync_signal_collect_test(
	
		.clk			(clk),
		.rst_n		(rst_n),	

		.sw			(sw),				//根据不同时钟速率，手动按键进行调整计算
		.M_period	(M_period),		//A机得出的最小时钟周期

		.M_edge		(M_edge),		//提取出的M序列边沿
		.bit_sync	(bit_sync),		//输出提取出的位同步时钟
		.sync_period(sync_period)	//提取出的位同步时钟的周期，进入下一个模块进行译码显示

	);
	
	/************************* 数码管显示位同步信号的频率 ****************************/
	
	freq_smg freq_smg_test(
	
	.clk								(clk),
	.rst_n							(rst_n),	
	.sync_period					(sync_period),		//位同步时钟的周期

	.One_hundred_thousand_data	(One_hundred_thousand_data),	//十万
	.Ten_thousand_data			(Ten_thousand_data),			//万
	.Thousand_data					(Thousand_data),					//千
	.Hundred_data					(Hundred_data),					//百
	.Ten_data						(Ten_data),						//十
	.One_data						(One_data)							//个
	);
	
	

endmodule
