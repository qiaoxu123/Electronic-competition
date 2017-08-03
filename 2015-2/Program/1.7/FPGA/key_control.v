/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				
* 
* ==================================================================*/

module key_control(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [3:0]  key,
	
	output reg [31:0] fword,
	output reg [9:0]  pword
	);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 按键消抖 ****************************/
 	reg [3:0] key1;
	reg [3:0] key2;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		key1 <= 4'd0;
		key2 <= 4'd0;
	end 
	else begin 
		key1 <= key;
		key2 <= key1;
	end 
	
	assign key_state = ~key1 & key2;
	
	/************************* 参数控制模块 ****************************/
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		fword <= 32'd8589934;
		pword <= 8'd0;
	end 
	else case (key_state)
		4'b0001:fword <= fword + 32'd85899346;
		4'b0010:fword <= fword - 32'd85899346;
		4'b0100:pword <= pword + 8'd1;
		4'b1000:pword <= pword - 8'd1;
		default:fword <= fword;
	endcase
	

endmodule

