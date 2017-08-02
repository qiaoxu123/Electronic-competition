/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/
`timescale 1ns/1ns
module	tb_uart();

reg					clk;
reg					rst_n;
reg					sig_in;
reg					sig_in1;
wire	[31:0]		phase;
wire	[31:0]		pinlv;

pro_uart	tb_inst
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//pinlv interface
	.sig_in(sig_in),			//a
	.sig_in1(sig_in1),		//b

	//user interface
	.phase(phase),
	.pinlv(pinlv)
	
); 


//--------------------------------
//Funtion :               

initial 
begin
	clk = 0;
	rst_n = 0;
	sig_in = 1;
	sig_in1 = 0;
	#100;
	rst_n = 1;
end

always #10 clk =~ clk;
always #1040 
begin
	sig_in =~ sig_in;
	sig_in1 =~ sig_in1;
end
endmodule
	
