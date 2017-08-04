/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/5/25
* Function:				将sync_signal_collect模块提取出的位同步信号的周期，进行解码输出到数码管上。
* 
* ==================================================================*/

module freq_smg(
	
	input wire 			clk,
	input	wire			rst_n,	
	input wire [19:0] sync_period,		//位同步时钟的周期
	
	//输出到数码管相应位
	output wire [6:0] One_hundred_thousand_data,	//十万
	output wire [6:0]	Ten_thousand_data,			//万
	output wire [6:0]	Thousand_data,					//千
	output wire [6:0]	Hundred_data,					//百
	output wire [6:0]	Ten_data,						//十
	output wire [6:0]	One_data							//个
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	//数码管对应位
	parameter   _0   = 7'b1000000,
					_1   = 7'b1111001,
					_2   = 7'b0100100,
					_3   = 7'b0110000,
					_4   = 7'b0011001,
					_5   = 7'b0010010,
					_6   = 7'b0000010,
					_7   = 7'b1111000,
					_8   = 7'b0000000,
					_9   = 7'b0010000;
					
	wire [3:0] One_hundred_thousand;	//十万
	wire [3:0] Ten_thousand;			//万
	wire [3:0] Thousand;					//千
	wire [3:0] Hundred;					//百
	wire [3:0] Ten;							//十
	wire [3:0] One;						//个

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* Bin_2_Bcd 译码 ****************************/
	//将输入的周期转为相应的十进制
	bin_2_bcd bin_2_bcd_test(
	
		.clk		(clk),
		.rst_n	(rst_n),
		
		.data_in	({10'b0,sync_period}),
		
		//每3位二进制转换为1位十进制
//		.data_1	(),
//		.data_2	(),
//		.data_3	(),
//		.data_4	(),
		.data_5	(One_hundred_thousand),
		.data_6	(Ten_thousand),
		.data_7	(Thousand),
		.data_8	(Hundred),
		.data_9	(Ten),
		.data_10	(One)
	);
		
	/************************* 输出到对应的数码管 ****************************/
	
	//十万
	reg [6:0]	r_One_hundred_thousand_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_One_hundred_thousand_data <= 7'b1000_000;
	else 
		case(One_hundred_thousand)
			4'd0:	r_One_hundred_thousand_data <= _0;
			4'd1:	r_One_hundred_thousand_data <= _1;
			4'd2:	r_One_hundred_thousand_data <= _2;
			4'd3:	r_One_hundred_thousand_data <= _3;
			4'd4:	r_One_hundred_thousand_data <= _4;
			4'd5:	r_One_hundred_thousand_data <= _5;
			4'd6:	r_One_hundred_thousand_data <= _6;
			4'd7:	r_One_hundred_thousand_data <= _7;
			4'd8:	r_One_hundred_thousand_data <= _8;
			4'd9:	r_One_hundred_thousand_data <= _9;
			default:;
		endcase
		
	//万
	reg [6:0]	r_Ten_thousand_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_Ten_thousand_data <= 7'b1000_000;
	else 
		case(Ten_thousand)
			4'd0:	r_Ten_thousand_data <= _0;
			4'd1:	r_Ten_thousand_data <= _1;
			4'd2:	r_Ten_thousand_data <= _2;
			4'd3:	r_Ten_thousand_data <= _3;
			4'd4:	r_Ten_thousand_data <= _4;
			4'd5:	r_Ten_thousand_data <= _5;
			4'd6:	r_Ten_thousand_data <= _6;
			4'd7:	r_Ten_thousand_data <= _7;
			4'd8:	r_Ten_thousand_data <= _8;
			4'd9:	r_Ten_thousand_data <= _9;
			default:;
		endcase
		
	//千
	reg [6:0]	r_Thousand_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_Thousand_data <= 7'b1000_000;
	else 
		case(Thousand)
			4'd0:	r_Thousand_data <= _0;
			4'd1:	r_Thousand_data <= _1;
			4'd2:	r_Thousand_data <= _2;
			4'd3:	r_Thousand_data <= _3;
			4'd4:	r_Thousand_data <= _4;
			4'd5:	r_Thousand_data <= _5;
			4'd6:	r_Thousand_data <= _6;
			4'd7:	r_Thousand_data <= _7;
			4'd8:	r_Thousand_data <= _8;
			4'd9:	r_Thousand_data <= _9;
			default:;
		endcase
		
	//百
	reg [6:0]	r_Hundred_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_Hundred_data <= 7'b1000_000;
	else 
		case(Hundred)
			4'd0:	r_Hundred_data <= _0;
			4'd1:	r_Hundred_data <= _1;
			4'd2:	r_Hundred_data <= _2;
			4'd3:	r_Hundred_data <= _3;
			4'd4:	r_Hundred_data <= _4;
			4'd5:	r_Hundred_data <= _5;
			4'd6:	r_Hundred_data <= _6;
			4'd7:	r_Hundred_data <= _7;
			4'd8:	r_Hundred_data <= _8;
			4'd9:	r_Hundred_data <= _9;
			default:;
		endcase
		
	//十
	reg [6:0]	r_Ten_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_Ten_data <= 7'b1000_000;
	else 
		case(Ten)
			4'd0:	r_Ten_data <= _0;
			4'd1:	r_Ten_data <= _1;
			4'd2:	r_Ten_data <= _2;
			4'd3:	r_Ten_data <= _3;
			4'd4:	r_Ten_data <= _4;
			4'd5:	r_Ten_data <= _5;
			4'd6:	r_Ten_data <= _6;
			4'd7:	r_Ten_data <= _7;
			4'd8:	r_Ten_data <= _8;
			4'd9:	r_Ten_data <= _9;
			default:;
		endcase
		
	//个
	reg [6:0]	r_One_data;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		r_One_data <= 7'b1000_000;
	else 
		case(One)
			4'd0:	r_One_data<= _0;
			4'd1:	r_One_data <= _1;
			4'd2:	r_One_data <= _2;
			4'd3:	r_One_data <= _3;
			4'd4:	r_One_data <= _4;
			4'd5:	r_One_data <= _5;
			4'd6:	r_One_data <= _6;
			4'd7:	r_One_data <= _7;
			4'd8:	r_One_data <= _8;
			4'd9:	r_One_data <= _9;
			default:;
		endcase
			
	assign One_hundred_thousand_data = r_One_hundred_thousand_data;	//十万
	assign Ten_thousand_data 			= r_Ten_thousand_data;				//万
	assign Thousand_data 				= r_Thousand_data;					//千
	assign Hundred_data 					= r_Hundred_data;						//百
	assign Ten_data 						= r_Ten_data;							//十
	assign One_data 						= r_One_data;							//个		
	

endmodule
