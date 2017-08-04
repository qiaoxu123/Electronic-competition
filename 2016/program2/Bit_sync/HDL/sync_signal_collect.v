/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5/25
* Function:				根据M_Receive模块提取出的最小时钟周期，提取出同步时钟信号
* 
* ==================================================================*/

module sync_signal_collect(
	
	input wire 			clk,
	input	wire			rst_n,	
	
	input wire			sw,			//根据不同时钟速率，手动按键进行调整计算
	input wire [31:0]	M_period,		//A机得出的最小时钟周期
	
	input wire			M_edge,		//提取出的M序列边沿
	output reg			bit_sync,	//输出提取出的位同步时钟
	output reg [19:0]	sync_period	//提取出的位同步时钟的周期，进入下一个模块进行译码显示

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	
	parameter T1s = 26'd49_999_999;
	
//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 提取位同步信号 ****************************/
	reg [31:0]		count;
	reg [31:0]		cnt;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		bit_sync	<= 1'b0;
		
	//ck信号频率为动态 	
	else if(!sw) begin		
		if(M_edge) begin 
			bit_sync <= 1'b1;
			count 	<= 32'd0;
		end 
		else if(count == (M_period >> 2'd2)) begin 
			bit_sync <= ~bit_sync;
			count 	<= 32'd0;
		end 
		else begin 
			bit_sync	<= bit_sync;
			count 	<= count + 1'b1;
		end 
	
	end 
	
	//ck信号频率为200khz
	else if(sw) begin			 
		if(M_edge) begin 
			cnt		<= 32'd0;
			bit_sync	<= 1'b1;
		end 
		else if(cnt == 32'd124) begin //200khz，一个时钟周期为5000ns。50M时钟，一个周期为20ns.
			cnt		<= 32'd0;			//效果：产生一个200khz的时钟信号
			bit_sync <= ~bit_sync;
		end 
		else 
			cnt 		<= cnt + 1'b1;
	end 
	
	
	/************************* 计算位同步时钟的频率 ****************************/
	
	//检测位同步时钟的下降沿
	reg flag1,flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		flag1	<= 1'b0;
		flag2 <= 1'b0;
	end 	
	else begin 
		flag1	<= bit_sync;
		flag2 <= flag1;
	end 
	
	wire clk_edge;
	assign clk_edge = flag1 & (~flag2);	//检测位同步时钟的下降沿
	
	
	//设置定时器，1s输出一次频率
	reg [31:0]	count_reflesh;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		count_reflesh <= 32'd0;
	else if(count_reflesh == T1s)
		count_reflesh <= 32'd0;
	else 
		count_reflesh <= count_reflesh + 1'd1;
		
	//设置定时器，提取位同步时钟的周期
	reg [19:0] count_sync;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		count_sync 	<= 1'b0;
	else if(count_reflesh == T1s) begin 
		count_sync	<= 1'b0;
		sync_period <= count_sync;
	end 
	else if(clk_edge)
		count_sync	<= count_sync + 1'b1;
	

endmodule
