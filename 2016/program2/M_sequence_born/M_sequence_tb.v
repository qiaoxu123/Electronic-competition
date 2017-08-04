/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Labortory
* Data:					2017/5
* Function:				测试产生的M序列
* 
* ==================================================================*/

`timescale 1ns/1ns
`define clk_period 5000

module M_sequence_tb;

//source define 
	reg		clk;
	reg 		rst_n;
	
	reg 		bit_sync_clk;


//probe define
	wire 		M_out;


//instant user module
	M_sequence M_sequence_test(
	
		.clk				(clk),
		.rst_n			(rst_n),

		.bit_sync_clk	(bit_sync_clk),		//外部输入的位同步信号，频率分为200kh和200~240khz两种情况。

		.M_out			(M_out)				//输出产生的M序列

);

//generate clock

	initial bit_sync_clk = 1;
	always #(`clk_period/2) bit_sync_clk = ~bit_sync_clk;
	
	initial begin 
		rst_n = 1'b0;
		#(`clk_period*20 + 1);
		rst_n = 1'b1;
		#(`clk_period*200);
		
	end 
	
endmodule


