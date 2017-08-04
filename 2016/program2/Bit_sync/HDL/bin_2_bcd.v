/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5/25
* Function:				实现Bin转BCD
* 
* ==================================================================*/

module bin_2_bcd(
	
	input wire 			clk,
	input	wire			rst_n,
	
	input wire [29:0]	data_in,
	
	//每3位二进制转换为1位十进制
	output reg [3:0]	data_1,data_2,data_3,data_4,data_5,
							data_6,data_7,data_8,data_9,data_10

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	
//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* Function ****************************/
	reg	[29:0]	num;
	reg 	[39:0]	bcd;
	
	integer n;
	
	always @(posedge clk) begin 
		
		num	=	data_in;
		bcd	=	1'b0;
		
		for(n = 0;n <29;n = n + 1) begin 
			bcd = {bcd[39:0],num[29]};
			if(bcd[39:36]>3'd4)
				bcd[39:36] = bcd[39:36] + 2'd3;
			if(bcd[35:32]>3'd4)
				bcd[35:32] = bcd[35:32] + 2'd3;
			if(bcd[31:28]>3'd4)
				bcd[31:28] = bcd[31:28] + 2'd3;
			if(bcd[27:24]>3'd4)
				bcd[27:24] = bcd[27:24] + 2'd3;				
			if(bcd[23:20]>3'd4)
				bcd[23:20] = bcd[23:20] + 2'd3;				
			if(bcd[19:16]>3'd4)
				bcd[19:16] = bcd[19:16] + 2'd3;			
			if(bcd[15:12]>3'd4)
				bcd[15:12] = bcd[15:12] + 2'd3;		
			if(bcd[11:8]>3'd4)
				bcd[11:8] = bcd[11:8] + 2'd3;	
			if(bcd[7:4]>3'd4)
				bcd[7:4] = bcd[7:4] + 2'd3;			
			if(bcd[3:0]>3'd4)
				bcd[3:0] = bcd[3:0] + 2'd3;	
				
			{data_1,data_2,data_3,data_4,data_5,data_6,data_7,data_8,data_9,data_10} = {bcd[39:0],num[0]};
			num = num << 1'b1;
		
		end 
	
	end 
	
	
	

endmodule
