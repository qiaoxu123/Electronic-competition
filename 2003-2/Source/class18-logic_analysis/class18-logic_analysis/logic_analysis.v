`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: 特权 franchise.3
// Create Date	: 2009.04.09
// Design Name	: 
// Module Name	: logic_analysis
// Project Name	: logic_analysis
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: DIY逻辑分析仪顶层模块
//					
// Revision		: V1.0
// Additional Comments	:  请尊重他人的劳动成果，
//				未经允许请勿上传源码，谢谢您的支持
////////////////////////////////////////////////////////////////////////////////
module logic_analysis(
				clk,rst_n,
				signal,trigger,
				tri_mode,sampling_mode,add_key,dec_key,sampling_clr_n,
				hsync,vsync,vga_r,vga_g,vga_b
			);

input clk;		//FPAG输入时钟信号25MHz
input rst_n;	//FPAG输入复位信号

input[15:0] signal;	//16路采样信号
input trigger;		//1路触发信号，可配置为上升沿或者下降沿触发
input tri_mode;		//触发信号模式选择，1--上升沿触发，0--下降沿触发
input[2:0] sampling_mode;	//采样模式选择,mode[0]--MODE1，mode[1]--MODE2，mode[2]--MODE3
input add_key;	//按键用于控制采样周期的提高，低电平表示按下
input dec_key;	//按键用于控制采样周期的减低，低电平表示按下
input sampling_clr_n;		//采样清除信号，用于清除当前采样数据，低有效

output hsync;	//行同步信号
output vsync;	//场同步信号
output[2:0] vga_r;
output[2:0] vga_g;
output[1:0] vga_b;

wire sys_rst_n;	//系统复位信号，低有效
wire clk_25m;	//PLL输出25MHz时钟
wire clk_100m;	//PLL输出100MHz时钟

wire disp_ctrl;		//VGA触发且采用完成，显示波形使能
wire[3:0] sampling_rate;	//采样率设置寄存器，0-100M，1-50M，……，9-10K
wire[63:0] sft_r0;	//移位寄存器组0,送给VGA显示的数据
wire[63:0] sft_r1;	//移位寄存器组1,送给VGA显示的数据
wire[63:0] sft_r2;	//移位寄存器组2,送给VGA显示的数据
wire[63:0] sft_r3;	//移位寄存器组3,送给VGA显示的数据
wire[63:0] sft_r4;	//移位寄存器组4,送给VGA显示的数据
wire[63:0] sft_r5;	//移位寄存器组5,送给VGA显示的数据
wire[63:0] sft_r6;	//移位寄存器组6,送给VGA显示的数据
wire[63:0] sft_r7;	//移位寄存器组7,送给VGA显示的数据
wire[63:0] sft_r8;	//移位寄存器组8,送给VGA显示的数据
wire[63:0] sft_r9;	//移位寄存器组9,送给VGA显示的数据
wire[63:0] sft_ra;	//移位寄存器组a,送给VGA显示的数据
wire[63:0] sft_rb;	//移位寄存器组b,送给VGA显示的数据
wire[63:0] sft_rc;	//移位寄存器组c,送给VGA显示的数据
wire[63:0] sft_rd;	//移位寄存器组d,送给VGA显示的数据
wire[63:0] sft_re;	//移位寄存器组e,送给VGA显示的数据
wire[63:0] sft_rf;	//移位寄存器组f,送给VGA显示的数据

//----------------------------------------------
//例化系统时钟和复位信号产生模块
sys_ctrl		uut_sys_ctrl(
					.clk(clk),
					.rst_n(rst_n),			
					.sys_rst_n(sys_rst_n),
					.clk_25m(clk_25m),
					.clk_100m(clk_100m)
				);

//----------------------------------------------
//例化数据采样控制模块
sampling_ctrl	uut_sampling(
					.clk_100m(clk_100m),
					.rst_n(sys_rst_n),
					.signal(signal),
					.trigger(trigger),
					.tri_mode(tri_mode),
					.sampling_mode(sampling_mode),
					.add_key(add_key),
					.dec_key(dec_key),					
					.sampling_clr_n(sampling_clr_n),
					.disp_ctrl(disp_ctrl),
					.sampling_rate(sampling_rate),
					.sft_r0(sft_r0),
					.sft_r1(sft_r1),
					.sft_r2(sft_r2),
					.sft_r3(sft_r3),
					.sft_r4(sft_r4),
					.sft_r5(sft_r5),
					.sft_r6(sft_r6),
					.sft_r7(sft_r7),
					.sft_r8(sft_r8),
					.sft_r9(sft_r9),
					.sft_ra(sft_ra),
					.sft_rb(sft_rb),
					.sft_rc(sft_rc),
					.sft_rd(sft_rd),
					.sft_re(sft_re),
					.sft_rf(sft_rf)						
				);


//----------------------------------------------
//例化VGA显示控制模块
vga_ctrl		uut_vga_ctrl(	
					.clk_25m(clk_25m),
					.rst_n(sys_rst_n),
					.sampling_mode(sampling_mode),
					.tri_mode(tri_mode),
					.disp_ctrl(disp_ctrl),
					.sampling_rate(sampling_rate),
					.sft_r0(sft_r0),
					.sft_r1(sft_r1),
					.sft_r2(sft_r2),
					.sft_r3(sft_r3),	
					.sft_r4(sft_r4),
					.sft_r5(sft_r5),
					.sft_r6(sft_r6),
					.sft_r7(sft_r7),
					.sft_r8(sft_r8),
					.sft_r9(sft_r9),
					.sft_ra(sft_ra),
					.sft_rb(sft_rb),
					.sft_rc(sft_rc),
					.sft_rd(sft_rd),
					.sft_re(sft_re),
					.sft_rf(sft_rf),					
					.hsync(hsync),
					.vsync(vsync),
					.vga_r(vga_r),
					.vga_g(vga_g),
					.vga_b(vga_b)
				);

	
	
endmodule 
