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

module dds_ram(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [3:0]  key,
	
	output wire [9:0] data_out			
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire [31:0] fword;
	wire [9:0]  pword;


//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 按键模块 ****************************/
 	key_control key_control_module(
	
		.clk		(clk),	
		.rst_n	(rst_n),
		.key		(key),
		
		.fword	(fword),
		.pword	(pword)
	);
	
	/************************* 按键模块 ****************************/
	DDS_signal dds_signal_module(
	
		.clk(clk),	
		.rst_n(rst_n),
		.fword(fword),
		.pword(pword),
		
		.Data_out(data_out)
);

	


endmodule



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

module DDS_signal(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [31:0] fword,
	input wire [7:0]  pword,
	
	output wire [9:0] Data_out
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 相位累加器 ****************************/
 	reg [31:0] Fre_acc;
	reg [9:0]  Rom_addr;
	
	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		Fre_acc <= fword;
	else  
		Fre_acc <= Fre_acc + fword;
		
//	always @(posedge clk or negedge rst_n)
//	if(!rst_n)
//		Pre_acc <= 0;
//	else 
//		Pre_acc <= Pre_acc + pword;
		
	/************************* 生成查找表地址 ****************************/
	always @(posedge clk or negedge rst_n)
	if(!rst_n)
		Rom_addr <= 10'd0;
	else 
		Rom_addr <= Fre_acc[31:22] + pword;
		
	
	/************************* 例化查找表 ****************************/
	sin_rom sin(
		.address(Rom_addr),
		.clock(clk),
		.q(Data_out)
	);
	


endmodule



