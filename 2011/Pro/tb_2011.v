/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/
`timescale	1ns/1ns
module tb_2011();
reg			clk;
reg			rst_n;
reg			button_add;
reg			button_sub;
wire		signal_v1;
wire		signal_v1_clk;
wire		signal_v3; 

pro_2017	tb_inst
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//button interface
	.button_add(button_add),   	//
	.button_sub(button_sub) ,  	//

	//sig interface s数字信号发生器
	.signal_v1(signal_v1),		//
	.signal_v1_clk(signal_v1_clk),
	
	//sig interface s伪随机信号
	.signal_v3(signal_v3)	
); 
//--------------------------------
//Funtion :               

initial begin
	clk = 0;
	rst_n = 0;
	button_add = 0;
	button_sub = 0;
	#100;
	rst_n = 1;

end
always #10 clk =~ clk;
endmodule
	
