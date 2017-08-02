/*-----------------------------------------------------------------------

Date				:		2017-07-04
Description			:		Design for 等精度测频.

-----------------------------------------------------------------------*/

module pro_uart
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//pinlv interface
	input					sig_in,			//a
	input					sig_in1		//b

	//user interface

	
); 

wire		[31:0]		phase;
wire		[31:0]		pinlv;
wire		[31:0]		fenzi;
wire		[31:0]		fenmu;
phase	u1
(
	//global clock
	.clk(clk_200),			//system clock
	.rst_n(rst_n),     		//sync reset
	
	//pinlv interface
	.sig_in(sig_in),			//a
	.sig_in1(sig_in1),		//b

	//user interface
	.phase(phase),
	.pinlv(pinlv),
	.fenzi(fenzi),
	.fenmu(fenmu)
	
); 

wire	clk_200;
clk_200 clk_inst(
		.  refclk(clk),   //  refclk.clk
		.  rst(!rst_n),      //   reset.reset
		.  outclk_0(clk_200)// outclk0.clk
	);
endmodule