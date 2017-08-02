/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module bit_sync
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//XXX interface
	output					signal_v1_man,
	output					sync_clk,
	output					signal_v1,
	output					signal_v1_clk,
	output					M_sync_clk,
	output					sync_clk1
	
); 


//--------------------------------
//Funtion :               

M_1		M_1_inst
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset

	//sig interface

	.	signal_v1_man(signal_v1_man),
	.	signal_v1_clk(signal_v1_clk),
	.	signal_v1(signal_v1)
	
);


sync	sync_inst
(
	//global clock
	.	clk(clk_200),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//sig_in interface
	.	sig_in(signal_v1_man),
	
	//sig_out	interface
	.	sync_clk(sync_clk),

	.	sync_clk1(sync_clk1)
	
); 



M_sync	M_sync_inst
(
	//global clock
	.	clk(clk_200),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//sig_in interface
	.	sig_in(signal_v1),
	//sig_out	interface
	.	M_sync_clk(M_sync_clk)
	
); 


wire		clk_200;
clk_200 	clk_inst
(
		.  refclk(clk),   //  refclk.clk
		.  rst(!rst_n),      //   reset.reset
		.  outclk_0(clk_200) // outclk0.clk
//		.  locked    //  locked.export
	);
endmodule
	
