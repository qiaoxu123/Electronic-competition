`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: 特权 franchise.3
// Create Date	: 2009.04.09
// Design Name	: 
// Module Name	: vga_ctrl
// Project Name	: logic_analysis
// Target Device: Cyclone EP1C3T144C8
// Tool versions: Quartus II 8.1
// Description	: DIY逻辑分析仪VGA显示驱动控制模块
//					
// Revision		: V1.0
// Additional Comments	:  请尊重他人的劳动成果，
//				未经允许请勿上传源码，谢谢您的支持
////////////////////////////////////////////////////////////////////////////////
module vga_ctrl(	
				clk_25m,rst_n,	
				sampling_mode,tri_mode,disp_ctrl,sampling_rate,	
				sft_r0,sft_r1,sft_r2,sft_r3,sft_r4,sft_r5,sft_r6,sft_r7,
				sft_r8,sft_r9,sft_ra,sft_rb,sft_rc,sft_rd,sft_re,sft_rf,	
				hsync,vsync,vga_r,vga_g,vga_b
			);

input clk_25m;	// 25MHz
input rst_n;	//低电平复位

input[2:0] sampling_mode;	//采样模式选择,mode[0]--MODE1，mode[1]--MODE2，mode[2]--MODE3
input tri_mode;			//触发信号模式选择，1--上升沿触发，0--下降沿触发
input disp_ctrl;		//VGA触发且采用完成，显示波形使能
input[3:0] sampling_rate;	//采样率设置寄存器，0-100M，1-50M，……，9-10K

	// 内部移位寄存器相关信号
input[63:0] sft_r0;		//移位寄存器组0,送给VGA显示的数据
input[63:0] sft_r1;		//移位寄存器组1,送给VGA显示的数据
input[63:0] sft_r2;		//移位寄存器组2,送给VGA显示的数据
input[63:0] sft_r3;		//移位寄存器组3,送给VGA显示的数据
input[63:0] sft_r4;		//移位寄存器组4,送给VGA显示的数据
input[63:0] sft_r5;		//移位寄存器组5,送给VGA显示的数据
input[63:0] sft_r6;		//移位寄存器组6,送给VGA显示的数据
input[63:0] sft_r7;		//移位寄存器组7,送给VGA显示的数据
input[63:0] sft_r8;		//移位寄存器组8,送给VGA显示的数据
input[63:0] sft_r9;		//移位寄存器组9,送给VGA显示的数据
input[63:0] sft_ra;		//移位寄存器组a,送给VGA显示的数据
input[63:0] sft_rb;		//移位寄存器组b,送给VGA显示的数据
input[63:0] sft_rc;		//移位寄存器组c,送给VGA显示的数据
input[63:0] sft_rd;		//移位寄存器组d,送给VGA显示的数据
input[63:0] sft_re;		//移位寄存器组e,送给VGA显示的数据
input[63:0] sft_rf;		//移位寄存器组f,送给VGA显示的数据

	// FPGA与VGA接口信号
output hsync;	//行同步信号
output vsync;	//场同步信号
output[2:0] vga_r;
output[2:0] vga_g;
output[1:0] vga_b;

//该头文件定义char_rom的各个字符对应的首地址
`include "para_define.v"	

//--------------------------------------------------
	// 坐标计数
reg[9:0] x_cnt;		//行坐标
reg[9:0] y_cnt;		//列坐标

always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) x_cnt <= 10'd0;
	else if(x_cnt == 10'd799) x_cnt <= 10'd0;
	else x_cnt <= x_cnt+1'b1;

always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) y_cnt <= 10'd0;
	else if(y_cnt == 10'd524) y_cnt <= 10'd0;
	else if(x_cnt == 10'd799) y_cnt <= y_cnt+1'b1;

//--------------------------------------------------
	// VGA场同步,行同步信号
reg hsync_r,vsync_r;	//同步信号
 
always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) hsync_r <= 1'b1;								
	else if(x_cnt == 10'd0) hsync_r <= 1'b0;	//产生hsync信号
	else if(x_cnt == 10'd96) hsync_r <= 1'b1;

always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) vsync_r <= 1'b1;							  
	else if(y_cnt == 10'd0) vsync_r <= 1'b0;	//产生vsync信号
	else if(y_cnt == 10'd2) vsync_r <= 1'b1;

assign hsync = hsync_r;
assign vsync = vsync_r;

//--------------------------------------------------
	//有效显示标志位产生
reg valid_yr;	//行显示有效信号
always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) valid_yr <= 1'b0;
	else if(y_cnt == 10'd32) valid_yr <= 1'b1;
	else if(y_cnt == 10'd512) valid_yr <= 1'b0;	

wire valid_y = valid_yr;

reg valid_r;	// VGA有效显示区标志位
always @ (posedge clk_25m or negedge rst_n)
	if(!rst_n) valid_r <= 1'b0;
	else if((x_cnt == 10'd141) && valid_y) valid_r <= 1'b1;
	else if((x_cnt == 10'd781) && valid_y) valid_r <= 1'b0;
	
wire valid = valid_r;		

//--------------------------------------------------
	//产生竖坐标,黄色显示在屏幕上
	
	//置高该位，表示要显示竖坐标(用于波形观察)
wire coordinate = (y_cnt > 10'd79) && (y_cnt < 481) && (x_cnt[2:0] == 3'd0) 
						&& (x_cnt > 10'd223) && (x_cnt < 10'd737);

//--------------------------------------------------
	//产生触发模式和采样模式的图形/边框,黄色显示在屏幕上

	//置高该位，表示要显示触发模式和采样模式的图形边框
wire dis_rim = ((y_cnt == 10'd489 | y_cnt == 10'd502) & (x_cnt > 10'd320) & (x_cnt < 10'd381))
					| ((x_cnt == 10'd320 | x_cnt == 10'd381 | x_cnt == 10'd638) & (y_cnt > 10'd488) & (y_cnt < 10'd503));

	//采样模式1时显示填充区域标志位，高有效
wire dis_sap_m1 = (x_cnt > 10'd320) & (x_cnt < 10'd351) & (y_cnt > 10'd489) & (y_cnt < 10'd502);
	//采样模式2时显示填充区域标志位，高有效
wire dis_sap_m2 = (x_cnt > 10'd335) & (x_cnt < 10'd365) & (y_cnt > 10'd489) & (y_cnt < 10'd502);
	//采样模式3时显示填充区域标志位，高有效
wire dis_sap_m3 = (x_cnt > 10'd349) & (x_cnt < 10'd381) & (y_cnt > 10'd489) & (y_cnt < 10'd502);	
	//采样模式显示填充区域标志位，高有效
wire dis_sap_fig = (dis_sap_m1 & sampling_mode == 3'b001) | (dis_sap_m2 & sampling_mode == 3'b010)
						| (dis_sap_m3 & sampling_mode == 3'b100);

	//上升沿触发，图形显示横线标志位，高有效
wire dis_tri_m1 = (y_cnt == 10'd502 & x_cnt > 10'd608 & x_cnt < 10'd638)
						| (y_cnt == 10'd489 & x_cnt > 10'd638 & x_cnt < 10'd668);
	//下降沿触发，图形显示横线标志位，高有效						
wire dis_tri_m0 = (y_cnt == 10'd489 & x_cnt > 10'd608 & x_cnt < 10'd638)
						| (y_cnt == 10'd502 & x_cnt > 10'd638 & x_cnt < 10'd668);
	//触发方式图形显示横线标志位，高有效						
wire dis_tri_fig = (dis_tri_m1 & tri_mode) | (dis_tri_m0 & ~tri_mode);

//--------------------------------------------------
	//16路采用信号高低电平的波形显示控制
wire sig0_dis_h,sig0_dis_l;		//signal 0	
wire sig1_dis_h,sig1_dis_l;		//signal 1
wire sig2_dis_h,sig2_dis_l;		//signal 2
wire sig3_dis_h,sig3_dis_l;		//signal 3	
wire sig4_dis_h,sig4_dis_l;		//signal 4	
wire sig5_dis_h,sig5_dis_l;		//signal 5
wire sig6_dis_h,sig6_dis_l;		//signal 6
wire sig7_dis_h,sig7_dis_l;		//signal 7	
wire sig8_dis_h,sig8_dis_l;		//signal 8	
wire sig9_dis_h,sig9_dis_l;		//signal 9
wire siga_dis_h,siga_dis_l;		//signal 10
wire sigb_dis_h,sigb_dis_l;		//signal 11	
wire sigc_dis_h,sigc_dis_l;		//signal 12	
wire sigd_dis_h,sigd_dis_l;		//signal 13
wire sige_dis_h,sige_dis_l;		//signal 14
wire sigf_dis_h,sigf_dis_l;		//signal 15	

assign sig0_dis_h = (y_cnt == 10'd96) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig0_dis_l = (y_cnt == 10'd104) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig1_dis_h = (y_cnt == 10'd120) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig1_dis_l = (y_cnt == 10'd128) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig2_dis_h = (y_cnt == 10'd144) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig2_dis_l = (y_cnt == 10'd152) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig3_dis_h = (y_cnt == 10'd168) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig3_dis_l = (y_cnt == 10'd176) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig4_dis_h = (y_cnt == 10'd192) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig4_dis_l = (y_cnt == 10'd200) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig5_dis_h = (y_cnt == 10'd216) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig5_dis_l = (y_cnt == 10'd224) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig6_dis_h = (y_cnt == 10'd240) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig6_dis_l = (y_cnt == 10'd248) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig7_dis_h = (y_cnt == 10'd264) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig7_dis_l = (y_cnt == 10'd272) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig8_dis_h = (y_cnt == 10'd288) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig8_dis_l = (y_cnt == 10'd296) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sig9_dis_h = (y_cnt == 10'd312) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sig9_dis_l = (y_cnt == 10'd320) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign siga_dis_h = (y_cnt == 10'd336) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign siga_dis_l = (y_cnt == 10'd344) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sigb_dis_h = (y_cnt == 10'd360) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sigb_dis_l = (y_cnt == 10'd368) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sigc_dis_h = (y_cnt == 10'd384) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sigc_dis_l = (y_cnt == 10'd392) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sigd_dis_h = (y_cnt == 10'd408) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sigd_dis_l = (y_cnt == 10'd416) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sige_dis_h = (y_cnt == 10'd432) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sige_dis_l = (y_cnt == 10'd440) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

assign sigf_dis_h = (y_cnt == 10'd456) && (x_cnt > 10'd223) && (x_cnt < 10'd737);
assign sigf_dis_l = (y_cnt == 10'd464) && (x_cnt > 10'd223) && (x_cnt < 10'd737);

	//显示位计算
wire[6:0] dis_bit = x_cnt[9:3]-7'h1c;

//--------------------------------------------------
	//显示标题“DIY 逻辑分析仪” 32*224
wire[31:0] topic_data;		//标题ROM数据总线
reg[7:0] topic_addr;		//标题ROM地址总线

	//例化标题ROM，该ROM存储标题字模数据
topic_rom		topic_rom_inst(
					.address(topic_addr),
					.clock(clk_25m),
					.q(topic_data)
				);
				
	//topic ROM地址运算
always @(posedge clk_25m or negedge rst_n)
	if(!rst_n) topic_addr <= 8'd0;
	else if(x_cnt == 10'd242) topic_addr <= 8'd0;
	else topic_addr <= topic_addr+1'b1;

	//显示标题区域标志位，高有效
wire dis_topic = (y_cnt > 10'd39) & (y_cnt < 10'd72) 
					& (x_cnt > 10'd245) & (x_cnt < 10'd470);

//--------------------------------------------------
	//显示字符 8*16bit
/*	char_rom存储空间为 512*8bit,从0地址开始每16个字节为一个字符的字模数据;
	512个地址上依此存放着0-9,a-z,A-Z共62个字符的字模
*/	
wire[15:0] char_data;	//char ROM数据总线
reg[8:0] char_addr;		//char ROM地址总线

	//例化char_ROM，该ROM存储字符字模数据
char_rom	char_rom_inst(
						.address(char_addr[8:0]),
						.clock(clk_25m),
						.q(char_data)
					);

	//char ROM地址运算
always @(posedge clk_25m or negedge rst_n) begin
	if(!rst_n) char_addr <= 9'd0;
	else if((y_cnt > 10'd91 & y_cnt < 10'd108) | (y_cnt > 10'd115 & y_cnt < 10'd132)
			| (y_cnt > 10'd139 & y_cnt < 10'd156) | (y_cnt > 10'd163 & y_cnt < 10'd180)
			| (y_cnt > 10'd187 & y_cnt < 10'd204) | (y_cnt > 10'd211 & y_cnt < 10'd228)
			| (y_cnt > 10'd235 & y_cnt < 10'd252) | (y_cnt > 10'd259 & y_cnt < 10'd276)
			| (y_cnt > 10'd283 & y_cnt < 10'd300) | (y_cnt > 10'd307 & y_cnt < 10'd324)
			| (y_cnt > 10'd331 & y_cnt < 10'd348) | (y_cnt > 10'd355 & y_cnt < 10'd372)
			| (y_cnt > 10'd379 & y_cnt < 10'd396) | (y_cnt > 10'd403 & y_cnt < 10'd420)
			| (y_cnt > 10'd427 & y_cnt < 10'd444) | (y_cnt > 10'd451 & y_cnt < 10'd468)) 
		begin
			if(x_cnt == 10'd187) char_addr <= `CHAR_C;		//送'C'字模存储首地址
			else if(x_cnt == 10'd195) char_addr <= `CHAR_h;	//送'h'字模存词首地址
			else if(x_cnt == 10'd203) begin
				if(y_cnt > 10'd91 && y_cnt < 10'd108) char_addr <= `CHAR_0;			//送'0'字模存储首地址
				else if(y_cnt > 10'd115 & y_cnt < 10'd132) char_addr <= `CHAR_1;	//送'1'字模存储首地址
				else if(y_cnt > 10'd139 & y_cnt < 10'd156) char_addr <= `CHAR_2;	//送'2'字模存储首地址
				else if(y_cnt > 10'd163 & y_cnt < 10'd180) char_addr <= `CHAR_3;	//送'3'字模存储首地址
				else if(y_cnt > 10'd187 & y_cnt < 10'd204) char_addr <= `CHAR_4;	//送'4'字模存储首地址
				else if(y_cnt > 10'd211 & y_cnt < 10'd228) char_addr <= `CHAR_5;	//送'5'字模存储首地址
				else if(y_cnt > 10'd235 & y_cnt < 10'd252) char_addr <= `CHAR_6;	//送'6'字模存储首地址
				else if(y_cnt > 10'd259 & y_cnt < 10'd276) char_addr <= `CHAR_7;	//送'7'字模存储首地址
				else if(y_cnt > 10'd283 & y_cnt < 10'd300) char_addr <= `CHAR_8;	//送'8'字模存储首地址
				else if(y_cnt > 10'd307 & y_cnt < 10'd324) char_addr <= `CHAR_9;	//送'9'字模存储首地址
				else if(y_cnt > 10'd331 & y_cnt < 10'd348) char_addr <= `CHAR_a;	//送'a'字模存储首地址
				else if(y_cnt > 10'd355 & y_cnt < 10'd372) char_addr <= `CHAR_b;	//送'b'字模存储首地址
				else if(y_cnt > 10'd379 & y_cnt < 10'd396) char_addr <= `CHAR_c;	//送'c'字模存储首地址
				else if(y_cnt > 10'd403 & y_cnt < 10'd430) char_addr <= `CHAR_d;	//送'd'字模存储首地址
				else if(y_cnt > 10'd427 & y_cnt < 10'd444) char_addr <= `CHAR_e;	//送'e'字模存储首地址
				else if(y_cnt > 10'd451 & y_cnt < 10'd468) char_addr <= `CHAR_f;	//送'f'字模存储首地址				
				end
			else char_addr <= char_addr+1'b1;	//取下一个地址的字模数据
		end
	else if(y_cnt > 10'd55 & y_cnt < 10'd72) begin
			case(x_cnt)	
					//屏幕右上方显示“Sampling Period:”
				10'd572: char_addr <= `CHAR_S;	//送'S'字模存储首地址 
				10'd580: char_addr <= `CHAR_a;	//送'a'字模存储首地址
				10'd588: char_addr <= `CHAR_m;	//送'm'字模存储首地址
				10'd596: char_addr <= `CHAR_p;	//送'p'字模存储首地址
				10'd604: char_addr <= `CHAR_l;	//送'l'字模存储首地址
				10'd612: char_addr <= `CHAR_i;	//送'i'字模存储首地址
				10'd620: char_addr <= `CHAR_n;	//送'n'字模存储首地址
				10'd628: char_addr <= `CHAR_g;	//送'g'字模存储首地址
				10'd636: char_addr <= `CHAR_kg;	//送' '字模存储首地址
				10'd644: char_addr <= `CHAR_P;	//送'P'字模存储首地址
				10'd652: char_addr <= `CHAR_e;	//送'e'字模存储首地址
				10'd660: char_addr <= `CHAR_r;	//送'r'字模存储首地址
				10'd668: char_addr <= `CHAR_i;	//送'i'字模存储首地址
				10'd676: char_addr <= `CHAR_o;	//送'o'字模存储首地址
				10'd684: char_addr <= `CHAR_d;	//送'd'字模存储首地址
				10'd692: char_addr <= `CHAR_mh;	//送':'字模存储首地址
					//显示采样周期的数值和单位，如500ns
				10'd708: if(sampling_rate == 4'd4) char_addr <= `CHAR_5;	//送百位字模存储首地址
						 else if(sampling_rate == 4'd3 || sampling_rate == 4'd9) char_addr <= `CHAR_1;
						 else char_addr <= `CHAR_kg;
				10'd716: case(sampling_rate)	//送十位字模存储首地址
							4'd5,4'd6,4'd7: char_addr <= `CHAR_kg;		
							4'd0,4'd8: char_addr <= `CHAR_1;	
							4'd1: char_addr <= `CHAR_2;	
							4'd2: char_addr <= `CHAR_4;	
							default: char_addr <= `CHAR_0;
							endcase	
				10'd724: case(sampling_rate)	//送个位字模存储首地址
							4'd5: char_addr <= `CHAR_1;	
							4'd6: char_addr <= `CHAR_2;	
							4'd7: char_addr <= `CHAR_5;	
							default: char_addr <= `CHAR_0;	
							endcase	
				10'd732: if(sampling_rate > 4'd4) char_addr <= `CHAR_u;	//送'u'字模存储首地址
						 else char_addr <= `CHAR_n;	//送'n'字模存储首地址
				10'd740: char_addr <= `CHAR_s;	//送's'字模存储首地址
				default: char_addr <= char_addr+1'b1;	//取下一个地址的字模数据
				endcase
		end
	else if(y_cnt > 10'd488 & y_cnt < 10'd505) begin
			case(x_cnt)
					//屏幕左下方显示“Trigger Mode:”
				10'd199: char_addr <= `CHAR_T;	//送'T'字模存储首地址 
				10'd207: char_addr <= `CHAR_r;	//送'r'字模存储首地址
				10'd215: char_addr <= `CHAR_i;	//送'i'字模存储首地址
				10'd223: char_addr <= `CHAR_g;	//送'g'字模存储首地址
				10'd231: char_addr <= `CHAR_g;	//送'g'字模存储首地址
				10'd239: char_addr <= `CHAR_e;	//送'e'字模存储首地址
				10'd247: char_addr <= `CHAR_r;	//送'r'字模存储首地址
				10'd255: char_addr <= `CHAR_kg;	//送' '字模存储首地址
				10'd263: char_addr <= `CHAR_M;	//送'M'字模存储首地址
				10'd271: char_addr <= `CHAR_o;	//送'o'字模存储首地址
				10'd279: char_addr <= `CHAR_d;	//送'd'字模存储首地址
				10'd287: char_addr <= `CHAR_e;	//送'e'字模存储首地址
				10'd295: char_addr <= `CHAR_mh;	//送':'字模存储首地址
					//屏幕右下方显示“Sampling Mode:”
				10'd479: char_addr <= `CHAR_S;	//送'S'字模存储首地址
				10'd487: char_addr <= `CHAR_a;	//送'a'字模存储首地址
				10'd495: char_addr <= `CHAR_m;	//送'm'字模存储首地址
				10'd503: char_addr <= `CHAR_p;	//送'p'字模存储首地址
				10'd511: char_addr <= `CHAR_l;	//送'l'字模存储首地址
				10'd519: char_addr <= `CHAR_i;	//送'i'字模存储首地址
				10'd527: char_addr <= `CHAR_n;	//送'n'字模存储首地址
				10'd535: char_addr <= `CHAR_g;	//送'g'字模存储首地址
				10'd543: char_addr <= `CHAR_kg;	//送' '字模存储首地址
				10'd551: char_addr <= `CHAR_M;	//送'M'字模存储首地址
				10'd559: char_addr <= `CHAR_o;	//送'o'字模存储首地址
				10'd567: char_addr <= `CHAR_d;	//送'd'字模存储首地址
				10'd575: char_addr <= `CHAR_e;	//送'e'字模存储首地址
				10'd583: char_addr <= `CHAR_mh;	//送':'字模存储首地址				
				default: char_addr <= char_addr+1'b1;	//取下一个地址的字模数据
				endcase
		end
end

	//显示'Ch'以及数字区域标志位，高有效
wire dis_ch = ((y_cnt > 10'd91 & y_cnt < 10'd108) | (y_cnt > 10'd115 & y_cnt < 10'd132)
				| (y_cnt > 10'd139 & y_cnt < 10'd156) | (y_cnt > 10'd163 & y_cnt < 10'd180)
				| (y_cnt > 10'd187 & y_cnt < 10'd204) | (y_cnt > 10'd211 & y_cnt < 10'd228)
				| (y_cnt > 10'd235 & y_cnt < 10'd252) | (y_cnt > 10'd259 & y_cnt < 10'd276)
				| (y_cnt > 10'd283 & y_cnt < 10'd300) | (y_cnt > 10'd307 & y_cnt < 10'd324)
				| (y_cnt > 10'd331 & y_cnt < 10'd348) | (y_cnt > 10'd355 & y_cnt < 10'd372)
				| (y_cnt > 10'd379 & y_cnt < 10'd396) | (y_cnt > 10'd403 & y_cnt < 10'd420)
				| (y_cnt > 10'd427 & y_cnt < 10'd444) | (y_cnt > 10'd451 & y_cnt < 10'd468))
				& (x_cnt > 10'd188 & x_cnt < 10'd213);

reg[3:0] ch_bit;	//显示Ch时根据y_cnt计算显示位bit0-15
always @(posedge clk_25m or negedge rst_n)
	if(!rst_n) ch_bit <= 4'd0;
	else if(x_cnt == 10'd1) begin	//每y_cnt期间，只译码一次
		if((y_cnt == 10'd92) | (y_cnt == 10'd116) | (y_cnt == 10'd140) | (y_cnt == 164)
			| (y_cnt == 10'd188) | (y_cnt == 10'd212) | (y_cnt == 10'd236) | (y_cnt == 10'd260)
			| (y_cnt == 10'd284) | (y_cnt == 10'd308) | (y_cnt == 10'd332) | (y_cnt == 10'd356)
			| (y_cnt == 10'd380) | (y_cnt == 10'd404) | (y_cnt == 10'd428) | (y_cnt == 10'd452))
			ch_bit <= 4'd15;	//地址复位，该操作可以作为多周期路径进行约束
		else ch_bit <= ch_bit-1'b1;		//自增一次y_cnt，数据位都减1
	end
	
	//屏幕右上方显示“Sampling Period:”有效标志位,高有效
wire dis_sap_prd = (y_cnt > 10'd55 & y_cnt < 10'd72) & (x_cnt > 10'd573 & x_cnt < 10'd702);

	//屏幕左下方显示“Trigger Mode:”有效标志位,高有效
wire dis_tri_mod = (y_cnt > 10'd488 & y_cnt < 10'd505) & (x_cnt > 10'd200 & x_cnt < 10'd305);

	//屏幕右下方显示“Sampling Mode:”有效标志位,高有效
wire dis_sap_mod = (y_cnt > 10'd488 & y_cnt < 10'd505) & (x_cnt > 10'd480 & x_cnt < 10'd593);

	//显示采样周数值和单位标志，高有效
wire dis_prd_value = (x_cnt > 10'd709 & x_cnt < 10'd750) & (y_cnt > 10'd55 & y_cnt < 10'd72);
	
//-------------------------------------------------- 
	// VGA色彩信号产生
/*
RGB = 000  	黑色	RGB = 100	红色
	= 001  	蓝色		= 101	紫色
	= 010	绿色		= 110	黄色
	= 011	青色		= 111	白色
*/	
	
reg[2:0] vga_rgb;	// VGA色彩显示寄存器

always @ (posedge clk_25m)
	if(!valid) vga_rgb <= 3'b000;
	else if(coordinate) vga_rgb <= 3'b110;	//产生竖坐标,黄色显示在屏幕上
	else if(dis_rim) vga_rgb <= 3'b101;		//产生竖条框,黄色显示在屏幕上
	else if(dis_sap_fig) vga_rgb <= 3'b101;		//采样模式显示填充区域,紫色显示在屏幕上
	else if(dis_tri_fig) vga_rgb <= 3'b101;		//触发模式图形显示区域,紫色显示在屏幕上
	else if(dis_topic) begin 	//31-(y_cnt-40) = 71-y_cnt
			if(topic_data[10'd71-y_cnt]) vga_rgb <= 3'b001;	//显示标题,蓝色
			else vga_rgb <= 3'b111;
		end
	else if(dis_ch) begin	
			if(char_data[ch_bit]) vga_rgb <= 3'b001;	//显示"Ch0/1/2/3/……",蓝色
			else vga_rgb <= 3'b111;			
		end
	else if(dis_sap_prd) begin	//15-(y_cnt-56) = 71-y_cnt
			if(char_data[10'd71-y_cnt]) vga_rgb <= 3'b001;	//显示“Sampling Period:”,蓝色
			else vga_rgb <= 3'b111;				
		end
	else if(dis_tri_mod) begin	//15-(y_cnt-489) = 504-y_cnt
			if(char_data[10'd504-y_cnt]) vga_rgb <= 3'b001;	//显示“Trigger Mode:”,蓝色
			else vga_rgb <= 3'b111;		
		end
	else if(dis_sap_mod) begin	//15-(y_cnt-489) = 504-y_cnt
			if(char_data[10'd504-y_cnt]) vga_rgb <= 3'b001;	//显示“Sampling Mode:”,蓝色
			else vga_rgb <= 3'b111;		
		end
	else if(dis_prd_value) begin	//15-(y_cnt-56) = 71-y_cnt
			if(char_data[10'd71-y_cnt]) vga_rgb <= 3'b101;	//显示“Sampling Period:”后的数值和单位,紫色
			else vga_rgb <= 3'b111;		
		end
	else if(disp_ctrl) begin	//触发后，显示波形
			if(sig0_dis_h && sft_r0[dis_bit]) vga_rgb <= 3'b010;	//signal0高电平波形显示
			else if(sig0_dis_l && !sft_r0[dis_bit]) vga_rgb <= 3'b010;	//signal 0低电平波形显示
			else if(sig1_dis_h && sft_r1[dis_bit]) vga_rgb <= 3'b010;	//signal 1高电平波形显示
			else if(sig1_dis_l && !sft_r1[dis_bit]) vga_rgb <= 3'b010;	//signal 1低电平波形显示
			else if(sig2_dis_h && sft_r2[dis_bit]) vga_rgb <= 3'b010;	//signal 2高电平波形显示
			else if(sig2_dis_l && !sft_r2[dis_bit]) vga_rgb <= 3'b010;	//signal 2低电平波形显示
			else if(sig3_dis_h && sft_r3[dis_bit]) vga_rgb <= 3'b010;	//signal 3高电平波形显示
			else if(sig3_dis_l && !sft_r3[dis_bit]) vga_rgb <= 3'b010;	//signal 3低电平波形显示
			else if(sig4_dis_h && sft_r4[dis_bit]) vga_rgb <= 3'b010;	//signal 4高电平波形显示
			else if(sig4_dis_l && !sft_r4[dis_bit]) vga_rgb <= 3'b010;	//signal 4低电平波形显示
			else if(sig5_dis_h && sft_r5[dis_bit]) vga_rgb <= 3'b010;	//signal 5高电平波形显示
			else if(sig5_dis_l && !sft_r5[dis_bit]) vga_rgb <= 3'b010;	//signal 5低电平波形显示
			else if(sig6_dis_h && sft_r6[dis_bit]) vga_rgb <= 3'b010;	//signal 6高电平波形显示
			else if(sig6_dis_l && !sft_r6[dis_bit]) vga_rgb <= 3'b010;	//signal 6低电平波形显示
			else if(sig7_dis_h && sft_r7[dis_bit]) vga_rgb <= 3'b010;	//signal 7高电平波形显示
			else if(sig7_dis_l && !sft_r7[dis_bit]) vga_rgb <= 3'b010;	//signal 7低电平波形显示
			else if(sig8_dis_h && sft_r8[dis_bit]) vga_rgb <= 3'b010;	//signal 8高电平波形显示
			else if(sig8_dis_l && !sft_r8[dis_bit]) vga_rgb <= 3'b010;	//signal 8低电平波形显示
			else if(sig9_dis_h && sft_r9[dis_bit]) vga_rgb <= 3'b010;	//signal 9高电平波形显示
			else if(sig9_dis_l && !sft_r9[dis_bit]) vga_rgb <= 3'b010;	//signal 9低电平波形显示
			else if(siga_dis_h && sft_ra[dis_bit]) vga_rgb <= 3'b010;	//signal 10高电平波形显示
			else if(siga_dis_l && !sft_ra[dis_bit]) vga_rgb <= 3'b010;	//signal 10低电平波形显示
			else if(sigb_dis_h && sft_rb[dis_bit]) vga_rgb <= 3'b010;	//signal 11高电平波形显示
			else if(sigb_dis_l && !sft_rb[dis_bit]) vga_rgb <= 3'b010;	//signal 11低电平波形显示
			else if(sigc_dis_h && sft_rc[dis_bit]) vga_rgb <= 3'b010;	//signal 12高电平波形显示
			else if(sigc_dis_l && !sft_rc[dis_bit]) vga_rgb <= 3'b010;	//signal 12低电平波形显示
			else if(sigd_dis_h && sft_rd[dis_bit]) vga_rgb <= 3'b010;	//signal 13高电平波形显示
			else if(sigd_dis_l && !sft_rd[dis_bit]) vga_rgb <= 3'b010;	//signal 13低电平波形显示
			else if(sige_dis_h && sft_re[dis_bit]) vga_rgb <= 3'b010;	//signal 14高电平波形显示
			else if(sige_dis_l && !sft_re[dis_bit]) vga_rgb <= 3'b010;	//signal 14低电平波形显示
			else if(sigf_dis_h && sft_rf[dis_bit]) vga_rgb <= 3'b010;	//signal 15高电平波形显示
			else if(sigf_dis_l && !sft_rf[dis_bit]) vga_rgb <= 3'b010;	//signal 15低电平波形显示			
			else vga_rgb <= 3'b111;
		end
	else vga_rgb <= 3'b111;

	//r,g,b控制液晶屏颜色显示
assign vga_r[0] = vga_rgb[2];
assign vga_r[1] = vga_rgb[2];
assign vga_r[2] = vga_rgb[2];
assign vga_g[0] = vga_rgb[1];
assign vga_g[1] = vga_rgb[1];
assign vga_g[2] = vga_rgb[1];
assign vga_b[0] = vga_rgb[0];
assign vga_b[1] = vga_rgb[0];


endmodule
