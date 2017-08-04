/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5
* Function:				
* 
* ==================================================================*/

module M_Receive(
	
	input wire 			clk,
	input	wire			rst_n,	
	
	input wire			M_in,			//输入产生的M序列
			
	output wire			M_edge,		//输出提取出的码元脉冲边沿
	
	output reg [31:0]	M_period		//根据不同的ck时钟速率，提取出M序列不同的最小时钟周期

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	parameter T200ms = 32'd4999_999; 


//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 码元脉冲边沿提取 ****************************/
	reg flag1,flag2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		flag1 <= 1'b0;
		flag2 <= 1'b0;
	end 
	else begin 
		flag1 <= M_in;
		flag2 <= flag1;
	end 
	
	assign M_edge = flag1 & (~flag2);		//检测码元脉冲的下降沿
	
	
	/************************* 位同步时钟周期计算 ****************************/
	//计数器1：200khz时钟信号，最小周期
	reg [31:0]		count;
	
	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		count <= 32'd0;
	else if(count == T200ms)
		count <= 32'd0;
	else 
		count <= count + 1'b1;
	
	//计数器2：通过M序列边沿，计算最小时钟周期
	reg [31:0]		cnt;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt	<= 32'd0;
	else if(M_edge)
		cnt 	<= 32'd0;
	else 
		cnt 	<= cnt + 32'd1;
		
	//根据系统开始输入的不同ck信号频率，来调整不同的最小时钟周期
	reg [31:0]		p_temp;
	
	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		p_temp <= 1000;
	else if(M_edge && (cnt < p_temp))
		p_temp <= cnt;
	else if(count == T200ms) begin 
		p_temp <= 1000;		//Why?
		M_period <= p_temp;
	end  
		
	
	

endmodule
