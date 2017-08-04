/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5//22
* Function:				实现m序列信号发生器.同时A机运行程序，生成序列经过硬件电路滤波后，再接到B机
*							进行位同步检测。
* 
* ==================================================================*/

module M_sequence(
	
	input			clk,
	input			rst_n,
	
	input			bit_sync_clk,		//外部输入的位同步信号，频率分为200kh和200~240khz两种情况。
	
	output		M_out				//输出产生的M序列

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* M序列信号发生器 ****************************/
	reg			m_out;
	reg [8:0] 	A;
	reg [8:0]	counter;
	
	always @(posedge bit_sync_clk or negedge rst_n) begin 
	if(!rst_n)
		A <= 9'b1_0000_0000;
	else begin 
		A <= A>>1;		//Register right shift
		A[8] <= (A[0]^A[4]^A[5]^A[6]^A[8]);		//模2相加
		
		m_out <= A[0];
	
	end 
	end 
	
	assign M_out = m_out;
	

endmodule



