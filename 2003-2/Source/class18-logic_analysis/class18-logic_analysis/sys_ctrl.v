`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: 特权 franchise.3
// Create Date	: 2009.04.09
// Design Name	: 
// Module Name	: sys_ctrl
// Project Name	: logic_analysis
// Target Device: Cyclone EP1C3T144C8
// Tool versions: Quartus II 8.1
// Description	: DIY逻辑分析仪复位以及PLL配置模块
//					
// Revision		: V1.0
// Additional Comments	:  请尊重他人的劳动成果，
//				未经允许请勿上传源码，谢谢您的支持
////////////////////////////////////////////////////////////////////////////////
module sys_ctrl(
				clk,rst_n,sys_rst_n,
				clk_25m,clk_100m
			);

input clk;		//FPAG输入时钟信号25MHz
input rst_n;	//系统复位信号

output sys_rst_n;	//系统复位信号，低有效

output clk_25m;		//PLL输出25MHz时钟
output clk_100m;	//PLL输出100MHz时钟
wire locked;		//PLL输出有效标志位，高表示PLL输出有效

//----------------------------------------------
//PLL复位信号产生，高有效
//异步复位，同步释放
wire pll_rst;	//PLL复位信号，高有效

reg rst_r1,rst_r2;

always @(posedge clk or negedge rst_n)
	if(!rst_n) rst_r1 <= 1'b1;
	else rst_r1 <= 1'b0;

always @(posedge clk or negedge rst_n)
	if(!rst_n) rst_r2 <= 1'b1;
	else rst_r2 <= rst_r1;

assign pll_rst = rst_r2;

//----------------------------------------------
//系统复位信号产生，低有效
//异步复位，同步释放
wire sys_rst_n;	//系统复位信号，低有效
wire sysrst_nr0;
reg sysrst_nr1,sysrst_nr2;

assign sysrst_nr0 = rst_n & locked;	//系统复位直到PLL有效输出

always @(posedge clk_100m or negedge sysrst_nr0)
	if(!sysrst_nr0) sysrst_nr1 <= 1'b0;
	else sysrst_nr1 <= 1'b1;

always @(posedge clk_100m or negedge sysrst_nr0)
	if(!sysrst_nr0) sysrst_nr2 <= 1'b0;
	else sysrst_nr2 <= sysrst_nr1;

assign sys_rst_n = sysrst_nr2;

//----------------------------------------------
//例化PLL产生模块
PLL_ctrl 		uut_PLL_ctrl(
					.areset(pll_rst),	//PLL复位信号,高电平复位
					.inclk0(clk),		//PLL输入时钟，25MHz
					.c0(clk_25m),		//PLL输出25MHz时钟			
					.c1(clk_100m),		//PLL输出100MHz时钟
					.locked(locked)		//PLL输出有效标志位，高表示PLL输出有效
				);
				

endmodule

