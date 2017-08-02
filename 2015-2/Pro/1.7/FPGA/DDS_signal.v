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

module DDS_signal(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [31:0] fword,
	input wire [7:0]  pword,
	
	output wire [9:0] Data_out
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 相位累加器 ****************************/
 	reg [31:0] Fre_acc;
	reg [9:0]  Rom_addr;
	
	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		Fre_acc <= fword;
	else  
		Fre_acc <= Fre_acc + fword;
		
//	always @(posedge clk or negedge rst_n)
//	if(!rst_n)
//		Pre_acc <= 0;
//	else 
//		Pre_acc <= Pre_acc + pword;
		
	/************************* 生成查找表地址 ****************************/
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		Rom_addr <= 10'd0;
	else 
		Rom_addr <= Fre_acc[31:22] + pword;
		
	
	/************************* 例化查找表 ****************************/
	rom rom_module(
		.address(Rom_addr),
		.clock(clk),
		.q(Data_out)
	);
	


endmodule

