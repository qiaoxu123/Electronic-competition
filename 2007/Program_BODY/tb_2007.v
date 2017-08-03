/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/
`timescale 1ns/1ns

module	tb_2007();

reg					clk;
reg					rst_n;
reg		[9:0]		ad_data_in;
reg					sample_sig;
pr_2007		tb
(
	//global clock
	.clk(clk),			//system clock
	.rst_n(rst_n),    		//sync reset
	
	//XXX interface
	.ad_data_in(ad_data_in),
	.sample_sig(sample_sig)
	//user interface

	
); 

//--------------------------------
//Funtion :               

initial 
begin
	clk = 0;
	rst_n = 0;
	ad_data_in = 0;
	sample_sig = 0;
	#100;
	rst_n = 1;

end

always #10 clk =~ clk;

always #500 sample_sig =~ sample_sig;
endmodule
	
