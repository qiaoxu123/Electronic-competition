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

module vga_test_tb;

//source define 
	reg clk;
	reg rst_n;


//probe define
	wire 		VGA_CLK;
	wire 		VGA_BLANK_N,VGA_SYNC_N;
	wire [7:0] VGA_R,VGA_B,VGA_G;
   wire 		VGA_HS,VGA_VS;			

//instant user module
	vga_top vga_top(
	
		.clk				(clk),	
		.rst_n			(rst_n),
		
		.VGA_CLK			(VGA_CLK),
		.VGA_BLANK_N	(VGA_BLANK_N),
		.VGA_SYNC_N		(VGA_SYNC_N),
		.VGA_R			(VGA_R),
		.VGA_B			(VGA_B),
		.VGA_G			(VGA_G),
		.VGA_HS			(VGA_HS),
		.VGA_VS			(VGA_VS)			
			
);



//generate clock

	initial clk = 1;
	always #(`clk_period/2) clk = ~clk;
	
	initial begin 
		rst_n = 1'b0;
		#(`clk_period*20);
		rst_n = 1'b1;
		#(`clk_period*80);
	
		
	end 
	
endmodule
