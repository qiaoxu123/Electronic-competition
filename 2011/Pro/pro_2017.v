/*-----------------------------------------------------------------------

Date				:		2017-07-16
Description			:		Design for 2011 电赛.

-----------------------------------------------------------------------*/

module pro_2017
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//button interface
	input					button_add,   	//
	input					button_sub ,  	//

	//sig interface s数字信号发生器
	output					signal_v1,		//
	output					signal_v1_clk,
	
	//sig interface s伪随机信号
	output					signal_v3,
	//sig interface 曼切斯特编码
	output					signal_v1_man,
	//sig interface sync同步信号
	input					sig_v2a,
	//	//sig interface sync同步信号
	output					sync_clk,
	//display		interface
	output			[6:0]	smg1
); 

//--------------------------------
//Funtion :    pll

wire		clk_200;
wire		clk_phase90;
clk_200  pll_inst (
		. refclk(clk),   //  refclk.clk
		. rst(!rst_n),      //   reset.reset
		.outclk_0(clk_200), // outclk0.clk
		.outclk_1(clk_phase90) // outclk1.clk
	);



//--------------------------------
//Funtion :    anjian
wire		[3:0]			button_data;
anjian	U1
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//button interface
	.button_add(button_add),   	//
	.button_sub(button_sub),		//

	//user interface

	.button_data(button_data)		//
);           

//--------------------------------
//Funtion :    数字信号发生器

M_1	M_1inst
(
	//global clock
	.clk(clk_200),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//button interface
	.button_data(button_data),

	//sig interface

	.signal_v1(signal_v1),		//
	.signal_v1_clk(signal_v1_clk),
	.signal_v1_man(signal_v1_man)
	
); 

//--------------------------------
//Funtion :  伪随机信号  
M_2 M_2inst
(
	//global clock
	.clk(clk_200),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//V3 interface
	.signal_v3(signal_v3)  
); 
//--------------------------------
//Funtion :  sync clk


sync sync_inst
(
	//global clock
	.clk(clk_200),			//system clock
	.clk_phase90(clk_phase90),
	.rst_n(rst_n),     		//sync reset
	
	//manqiesite interface
	.signal_v1_man(sig_v2a),					

	//sync		 interface
	.sync_clk(sync_clk)
	
); 
//--------------------------------
//Funtion :  display

display	display_inst
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//smg interface
	.button_data(button_data),   	//
	.smg1(smg1)
	
); 
endmodule
	
