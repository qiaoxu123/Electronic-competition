`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: 特权 franchise.3
// Create Date	: 2009.04.09
// Design Name	: 
// Module Name	: sampling_ctrl
// Project Name	: logic_analysis
// Target Device: Cyclone EP1C3T144C8
// Tool versions: Quartus II 8.1
// Description	: DIY逻辑分析仪信号采集模块
//					
// Revision		: V1.0
// Additional Comments	:  请尊重他人的劳动成果，
//				未经允许请勿上传源码，谢谢您的支持
////////////////////////////////////////////////////////////////////////////////
module sampling_ctrl(
				clk_100m,rst_n,
				signal,trigger,
				tri_mode,sampling_mode,add_key,dec_key,sampling_clr_n,
				disp_ctrl,sampling_rate,
				sft_r0,sft_r1,sft_r2,sft_r3,sft_r4,sft_r5,sft_r6,sft_r7,
				sft_r8,sft_r9,sft_ra,sft_rb,sft_rc,sft_rd,sft_re,sft_rf
			);

input clk_100m;	//FPAG输入时钟信号100MHz
input rst_n;	//系统复位信号

input[15:0] signal;	//16路采样信号
input trigger;		//1路触发信号，可配置为上升沿或者下降沿触发
input tri_mode;		//触发信号模式选择，1--上升沿触发，0--下降沿触发
input[2:0] sampling_mode;	//采样模式选择,mode[0]--MODE1，mode[1]--MODE2，mode[2]--MODE3
input add_key;		//按键用于控制采样周期的提高，低电平表示按下
input dec_key;		//按键用于控制采样周期的减低，低电平表示按下
input sampling_clr_n;		//采样清除信号，用于清除当前采样数据，低有效

output disp_ctrl;			//VGA触发且采用完成，显示波形使能
output[3:0] sampling_rate;	//采样率设置寄存器，0-100M，1-50M，……，9-10K
output[63:0] sft_r0;		//移位寄存器组0,送给VGA显示的数据
output[63:0] sft_r1;		//移位寄存器组1,送给VGA显示的数据
output[63:0] sft_r2;		//移位寄存器组2,送给VGA显示的数据
output[63:0] sft_r3;		//移位寄存器组3,送给VGA显示的数据
output[63:0] sft_r4;		//移位寄存器组4,送给VGA显示的数据
output[63:0] sft_r5;		//移位寄存器组5,送给VGA显示的数据
output[63:0] sft_r6;		//移位寄存器组6,送给VGA显示的数据
output[63:0] sft_r7;		//移位寄存器组7,送给VGA显示的数据
output[63:0] sft_r8;		//移位寄存器组8,送给VGA显示的数据
output[63:0] sft_r9;		//移位寄存器组9,送给VGA显示的数据
output[63:0] sft_ra;		//移位寄存器组a,送给VGA显示的数据
output[63:0] sft_rb;		//移位寄存器组b,送给VGA显示的数据
output[63:0] sft_rc;		//移位寄存器组c,送给VGA显示的数据
output[63:0] sft_rd;		//移位寄存器组d,送给VGA显示的数据
output[63:0] sft_re;		//移位寄存器组e,送给VGA显示的数据
output[63:0] sft_rf;		//移位寄存器组f,送给VGA显示的数据

wire sampling_start;			//移位寄存器使能信号，高有效
//wire[3:0] shiftout;		//移位寄存器输出,(该设计中不使用，没有连接)

//----------------------------------------------
//采样频率设置控制按键检测
reg[20:0] delay;	//延时计数器
reg[1:0] key_valuer1,key_valuer2;	//键值寄存器,每20ms锁存一次，用于键值改变检测
wire[1:0] key_change;	//判定前后20ms的键值是否发生了改变，若是，则key_change置高

	//20ms计数器
always @ (posedge clk_100m or negedge rst_n)
	if(!rst_n) delay <= 21'd0;
	else delay <= delay+1'b1;	//不断计数，周期为20ms左右

	//每20ms进行一次键值采样
always @ (posedge clk_100m or negedge rst_n)
	if(!rst_n) begin
			key_valuer1 <= 2'b11;	
			key_valuer2 <= 2'b11;
		end
	else if(delay == 21'h1fffff) begin
			key_valuer1 <= {add_key,dec_key};	//delay 20ms，锁定键值
			key_valuer2 <= key_valuer1;
		end

assign key_change = (delay == 21'd1) ? (key_valuer1 & (~key_valuer2)) : 2'b00;//check key_value negedge 1 clk_100m

//----------------------------------------------
//采样频率设置控制逻辑
/*	该模块的时钟即基本的采样时钟为PLL_c0 = 100MHz
	可调的采样频率以及采样周期如下： 共10级
频率：	100M	50M		25M		10M		2M		1M		500K	200K	100K	10K
周期：	10ns	20ns	40ns	100ns	500ns	1us		2us		5us		10us	100us
计数：	0		1		3		9		49		99		199		499		999		9999
	计数为PLL_c0计数值，使用时钟使能方式控制采样时刻
*/
reg[13:0] sapdiv_cnt;	//采样率分频计数器 0-9999
reg[3:0] sampling_rate;	//采样率设置寄存器，0-100M，1-50M，……，9-10K
reg[13:0] sapdiv_max;	//采样率对应的分频计数值
wire sapdiv_end;		//采样点到置高一个时钟周期

	//采样频率控制按键处理
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sampling_rate <= 4'd0;
	else if(key_change[1] && (sampling_rate < 4'd9)) sampling_rate <= sampling_rate+1'b1;	//采样周期模式最大到9
	else if(key_change[0] && (sampling_rate > 4'd0)) sampling_rate <= sampling_rate-1'b1;	//采样周期模式最小到0

	//计算采样率对应的分频计数值
always @(sampling_rate)
		case(sampling_rate)
			4'd0: sapdiv_max <= 14'd0;
			4'd1: sapdiv_max <= 14'd1;
			4'd2: sapdiv_max <= 14'd3;
			4'd3: sapdiv_max <= 14'd9; 
			4'd4: sapdiv_max <= 14'd49; 
			4'd5: sapdiv_max <= 14'd99; 
			4'd6: sapdiv_max <= 14'd199; 
			4'd7: sapdiv_max <= 14'd499; 
			4'd8: sapdiv_max <= 14'd999; 
			4'd9: sapdiv_max <= 14'd9999; 
			default: sapdiv_max <= 14'd0;
			endcase
			
	//采样频率分频计数
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sapdiv_cnt <= 14'd0;
	else if(sapdiv_cnt == sapdiv_max) sapdiv_cnt <= 14'd0;	//采样率计数最大值到
	else sapdiv_cnt <= sapdiv_cnt+1'b1; 	

assign sapdiv_end = (sapdiv_cnt == 14'd0);	//采样点到

//----------------------------------------------
//产生64*16个移位寄存器
reg[63:0] sft_r0;		//移位寄存器组0
reg[63:0] sft_r1;		//移位寄存器组1
reg[63:0] sft_r2;		//移位寄存器组2
reg[63:0] sft_r3;		//移位寄存器组3
reg[63:0] sft_r4;		//移位寄存器组4
reg[63:0] sft_r5;		//移位寄存器组5
reg[63:0] sft_r6;		//移位寄存器组6
reg[63:0] sft_r7;		//移位寄存器组7
reg[63:0] sft_r8;		//移位寄存器组8
reg[63:0] sft_r9;		//移位寄存器组9
reg[63:0] sft_ra;		//移位寄存器组a
reg[63:0] sft_rb;		//移位寄存器组b
reg[63:0] sft_rc;		//移位寄存器组c
reg[63:0] sft_rd;		//移位寄存器组d
reg[63:0] sft_re;		//移位寄存器组e
reg[63:0] sft_rf;		//移位寄存器组f

//采集信号signal[0]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r0 <= 64'd0;
	else if(sampling_start) sft_r0 <= {signal[0],sft_r0[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[1]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r1 <= 64'd0;
	else if(sampling_start) sft_r1 <= {signal[1],sft_r1[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[2]	
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r2 <= 64'd0;
	else if(sampling_start) sft_r2 <= {signal[2],sft_r2[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[3]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r3 <= 64'd0;
	else if(sampling_start) sft_r3 <= {signal[3],sft_r3[63:1]};	//向右移位，最高位输入新数据		
//采集信号signal[4]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r4 <= 64'd0;
	else if(sampling_start) sft_r4 <= {signal[4],sft_r4[63:1]};	//向右移位，最高位输入新数据		
//采集信号signal[5]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r5 <= 64'd0;
	else if(sampling_start) sft_r5 <= {signal[5],sft_r5[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[6]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r6 <= 64'd0;
	else if(sampling_start) sft_r6 <= {signal[6],sft_r6[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[7]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r7 <= 64'd0;
	else if(sampling_start) sft_r7 <= {signal[7],sft_r7[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[8]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r8 <= 64'd0;
	else if(sampling_start) sft_r8 <= {signal[8],sft_r8[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[9]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_r9 <= 64'd0;
	else if(sampling_start) sft_r9 <= {signal[9],sft_r9[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[10]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_ra <= 64'd0;
	else if(sampling_start) sft_ra <= {signal[10],sft_ra[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[11]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_rb <= 64'd0;
	else if(sampling_start) sft_rb <= {signal[11],sft_rb[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[12]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_rc <= 64'd0;
	else if(sampling_start) sft_rc <= {signal[12],sft_rc[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[13]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_rd <= 64'd0;
	else if(sampling_start) sft_rd <= {signal[13],sft_rd[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[14]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_re <= 64'd0;
	else if(sampling_start) sft_re <= {signal[14],sft_re[63:1]};	//向右移位，最高位输入新数据
//采集信号signal[15]
always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sft_rf <= 64'd0;
	else if(sampling_start) sft_rf <= {signal[15],sft_rf[63:1]};	//向右移位，最高位输入新数据
		
//----------------------------------------------
//触发信trigger边沿检测
reg trigger_r1,trigger_r2,trigger_r3;
wire pos_tri;	//trigger上升沿标志位，高有效一个时钟周期
wire neg_tri;	//trigger下降沿标志位，高有效一个时钟周期

always @(posedge clk_100m or negedge rst_n) 
	if(!rst_n) begin
		trigger_r1 <= 1'b0;
		trigger_r2 <= 1'b0;
		trigger_r3 <= 1'b0;
		end
	else begin
		trigger_r1 <= trigger;
		trigger_r2 <= trigger_r1;
		trigger_r3 <= trigger_r2;
		end

assign pos_tri = trigger_r2 & ~trigger_r3;
assign neg_tri = ~trigger_r2 & trigger_r3;

//----------------------------------------------
//触发有效信号trigger_valid检测逻辑
reg trigger_valid;	//设定的触发条件满足后,该标志位拉高

always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) trigger_valid <= 1'b0;
	else if(!sampling_clr_n) trigger_valid <= 1'b0;			//复位触发有效信号，等待下一次触发
	else if(tri_mode && pos_tri) trigger_valid <= 1'b1;		//上升沿触发
	else if(!tri_mode && neg_tri) trigger_valid <= 1'b1;	//下降沿触发
	
//----------------------------------------------
//采样结束信号sampling_end产生逻辑
//sampling_end低时作为移位寄存器时钟使能信号，高时作为VGA显示移位寄存器数据信号
reg sampling_end;	//在特定的采样模式下采样结束条件满足，则拉高该寄存器
reg[5:0] cnt;		//64计数寄存器

always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) cnt <= 6'd0;
	else if(!sampling_clr_n) cnt <= 6'd0;	////复位计数器，等待下一次计数启动
	else if(trigger_valid) cnt <= cnt+1'b1;	//一旦触发后，启动计数

always @(posedge clk_100m or negedge rst_n)
	if(!rst_n) sampling_end <= 1'b0;
	else if(!sampling_clr_n) sampling_end <= 1'b0;		//复位采样结束信号，等待下一次采样结束
	else if((sampling_mode == 3'b001) && (cnt == 6'd63)) sampling_end <= 1'b1;
	else if((sampling_mode == 3'b010) && (cnt == 6'd31)) sampling_end <= 1'b1;
	else if((sampling_mode == 3'b100) && (cnt == 6'd1)) sampling_end <= 1'b1;
		
//----------------------------------------------
//移位寄存器使能信号sampling_start控制逻辑
assign sampling_start = ~sampling_end & sapdiv_end;

//----------------------------------------------
//采样波形显示标志位dis_ctrl控制逻辑
assign disp_ctrl = sampling_end;

endmodule

