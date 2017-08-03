/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				VGA驱动部分
* 
* ==================================================================*/

module vga_drive(
	
	input wire 			clk,	
	input	wire			rst_n,
	
	
	//vga引脚定义
	input  wire [23:0] RGB,
	output wire 		 VGA_CLK,
	output wire 		 VGA_BLANK_N,VGA_SYNC_N,
	output wire [7:0]  VGA_R,VGA_B,VGA_G,
	output wire 		 VGA_HS,VGA_VS,
	output wire [9:0]  hx,vy
			


);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	//定义图像时序常数
	parameter H_END = 11'd1056;
	parameter HA = 11'd80,HB = 11'd160,HC = 11'd800,HD = 11'd16;
	
	parameter V_END = 11'd625;
	parameter VO = 11'd3,VP = 11'd21,VQ = 11'd600,VR = 11'd1;
	
	//定义图像显示区域
	parameter bmp_one_a1 = 11'd0;
	parameter bmp_one_a2 = 11'd800;
	parameter bmp_one_b1 = 11'd0;
	parameter bmp_one_b2 = 11'd600;



//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 图像时序 ****************************/
 	//横轴时序
	reg [10:0] hs_count;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(rst_n == 0)
			hs_count <= 11'd0;
		else if(hs_count == H_END)
			hs_count <= 1'd0;
		else 
			hs_count <= hs_count + 1'b1;
	end 
	
	//纵轴时序
	reg [10:0] vs_count;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(rst_n == 0)
			vs_count <= 11'd0;
		else if(vs_count == V_END)
			vs_count <= 11'b0;
		else if(hs_count == H_END)
			vs_count <= vs_count + 11'd1;
	end

	//显示使能
	reg isReady;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(rst_n == 0)
			isReady <= 1'b0;
		else if((hs_count >= HA + HB && hs_count <= HA + HB + HC) && (vs_count >= VO + VP && vs_count <= VO + VP + VQ))
			isReady <= 1'b1;
		else 
			isReady <= 1'b0;
	end 
	
	
	//定义显示使能
	wire hs,vs;
	
	assign hs = (hs_count <= HA)?1'b0:1'b1;		//确定显示的部分在可视位置
	assign vs = (vs_count <= VO)?1'b0:1'b1;
	
	
	
	/************************* 显示部分 ****************************/
	//定义图像起始坐标
	//wire [9:0] hx,vy;
	
	assign hx = isReady?(hs_count - HA - HB):10'd0;
	assign vy = isReady?(vs_count - VO - VP):10'd0;
	
	
	//定义端口值
	assign VGA_B = RGB[7:0];
	assign VGA_G = RGB[15:8];
	assign VGA_R = RGB[23:16];
	
	assign VGA_CLK = clk;
	assign VGA_BLANK_N = hs;
	assign VGA_SYNC_N = vs;
	
	assign VGA_HS = hs;
	assign VGA_VS = vs;
	

endmodule

