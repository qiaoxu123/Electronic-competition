/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				VGA顶层文件
* 
* ==================================================================*/

module vga_top(
	
	input wire 			clk,	
	input	wire			rst_n,
	
	//vga引脚定义
	output wire 		VGA_CLK,
	output wire 		VGA_BLANK_N,VGA_SYNC_N,
	output wire [7:0] VGA_R,VGA_B,VGA_G,
	output wire 		VGA_HS,VGA_VS			
			


);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire [9:0]  hx,vy;		//定义扫描坐标
	wire [23:0] RGB;



//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* vga控制部分 ****************************/
	vga_control vga_control(
	
		.clk				(clk),	
		.rst_n			(rst_n),
		
		.hx				(hx),		//vga的行坐标和列坐标
		.vy				(vy),
		.RGB			   (RGB)
	);
	
	
	
	
	/************************* vga驱动部分 ****************************/
 	vga_drive vga_drive(
	
		.clk				(clk),	
		.rst_n			(rst_n),
		
		.RGB				(RGB),
		.VGA_CLK			(VGA_CLK),
		.VGA_BLANK_N	(VGA_BLANK_N),
		.VGA_SYNC_N		(VGA_SYNC_N),
		.VGA_R			(VGA_R),
		.VGA_B			(VGA_B),
		.VGA_G			(VGA_G),
		.VGA_HS			(VGA_HS),
		.VGA_VS			(VGA_VS),
		.hx				(hx),
		.vy				(vy)
	
	);
	
	
	
	
	
	
	
	
	
	
	
	
	


endmodule

