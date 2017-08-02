/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/
`timescale 1ns/1ns

module	tb_2003();

reg			clk;
reg			rst_n;
reg			key_sigle;
pro_2003	tb
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),    		//sync reset
	
	//XXX interface
	.key_sigle(key_sigle)

	//user interface

	
); 

//--------------------------------
//Funtion :               

initial 
begin
	clk = 0;
	rst_n = 0;
	key_sigle = 1;
	#100;

	key_sigle = 1;
	rst_n = 1;
	key_sigle = 0;
	#200;
	key_sigle = 1;

end

always #10 clk =~ clk;


endmodule
	
