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
	
	input wire 				clk,	
	input	wire				rst_n,
	input wire 				wr_en,
	
	output wire [9:0]		q	
			


);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================





//====================================================================
// ************************* Main Code *************************
//====================================================================

 	/************************* DDS信号产生部分 ****************************/
	dds_ram dds(
	
		.clk				(clk),	
		.rst_n			(rst_n),
		.key				(key),
		
		.data_out		(data_out)			
	);
	
	/************************* ram存取部分 ****************************/
	reg [9:0] raddr;
	reg [9:0] waddr;
	reg 		 wr_en;
	
	ram_dds ram_dds(
		.clock			(clk),
		.data				(data_out),
		.rdaddress		(raddr),
		.wraddress		(waddr),
		.wren				(wr_en),
		.q					(q)
	);
	
	/************************* VGA读取部分 ****************************/
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			raddr <= 10'd0;
			waddr <= 10'd0;
		end 
		else if
	end 
	
	
	
	
	
	
	


endmodule

