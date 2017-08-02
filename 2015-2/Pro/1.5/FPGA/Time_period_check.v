/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/6/22
* Function:				时间间隔检测模块，并将检测到的数据传送到Uart发送端
* 
* ==================================================================*/

module Time_period_check(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire 		   One_Signal_in,	//待测信号1
	input wire 			Two_Signal_in,	//待测信号2
	
	output reg [31:0] Time_interval  //1000个周期内，两信号的时间间隔总长
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================





//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 上升沿&下降沿检测 ****************************/
	//采集A路信号的上升沿与下降沿
	reg One_flag1;
	reg One_flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		One_flag1 <= 1'b0;
		One_flag2 <= 1'b0;
	end 
	else begin 
		One_flag1 <= One_Signal_in;
		One_flag2 <= One_flag1;
	end 
	
	assign One_Rising_edge = (~One_flag1) & One_flag2;
	assign One_falling_edge = One_flag1 & (~One_flag2);
	
	
	//采集B路信号的上升沿与下降沿
	reg Two_flag1;
	reg Two_flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		Two_flag1 <= 1'b0;
		Two_flag2 <= 1'b0;
	end 
	else begin 
		Two_flag1 <= Two_Signal_in;
		Two_flag2 <= Two_flag1;
	end 
	
	assign Two_Rising_edge = (~Two_flag1) & Two_flag2;
	assign Two_falling_edge = Two_flag1 & (~Two_flag2);


	/************************* Function ****************************/
 	//将两路待测信号进行异或操作
	reg  First_Signal;
	reg  Second_Signal;
	reg  Mix_Signal;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		First_Signal <= 32'd0;
		Second_Signal <= 32'd0;
	end 
	else begin 
		First_Signal <= One_flag1;
		Second_Signal <= Two_flag1;
		Mix_Signal <= First_Signal^Second_Signal;
	end
	
	
	/************************* 计数器 ****************************/
	//检测异或后信号的上升沿和下降沿
	reg flag1,flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		flag1 <= 1'b0;
		flag2 <= 1'b0;
	end 
	else begin 
		flag1 <= Mix_Signal;
		flag2 <= flag1;
	end 

	assign Rising_edge  = (~flag2) & flag1; //检测信号的下降沿
	assign Falling_edge = flag2 & (~flag1);//检测信号的上升沿
	
	
	
	//对异或后的信号进行计数，从而计算信号周期
	reg [9:0] SignalCount ;				//计算上升沿的个数，到达1000个上升沿停止
	reg [31:0] Numcount;					//上升沿开始计数，下降沿停止计数
	reg [31:0] r_Single_TimePeriod;	//计算1000个混合信号的周期总长
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		SignalCount <= 10'd0;
		r_Single_TimePeriod  <= 32'd0;
		Numcount		<= 32'd0;
	end 
	else begin
		if(Mix_Signal) begin 
			Numcount <= Numcount + 1'b1;
			if(Rising_edge) begin 
				SignalCount <= SignalCount + 1'b1;
				if(SignalCount == 10'd1000) begin 
					SignalCount <= 10'd0;
					Time_interval <= r_Single_TimePeriod;
					r_Single_TimePeriod <= 10'd0;
				end 
			end
		end
		if(Falling_edge) begin 
			r_Single_TimePeriod <= r_Single_TimePeriod + Numcount;
			Numcount <= 32'd0;
		end 
	end	
		

endmodule

