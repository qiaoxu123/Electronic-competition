/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				
* 
* ==================================================================*/

module DDS_top(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [3:0]  key,
	
	output wire [9:0] data_out			
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire [31:0] fword;
	wire [9:0]  pword;


//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 按键模块 ****************************/
 	key_control key_control_module(
	
		.clk		(clk),	
		.rst_n	(rst_n),
		.key		(key),
		
		.fword	(fword),
		.pword	(pword),
	);
	
	/************************* 按键模块 ****************************/
	DDS_signal dds_signal_module(
	
		.clk(clk),	
		.rst_n(rst_n),
		.fword(fword),
		.pword(pword),
		
		.Data_out(data_out)
);

	
	
	
	
	
	
	
	
	
	
	
	


endmodule

