/*-----------------------------------------------------------------------

Date				:		2017-07-17
Description			:		Design for DDS.

-----------------------------------------------------------------------*/
module dds
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//da interface
	output			[11:0]	da_out_a,			//da输出
	
	//user interface

	output			[31:0]	fword_a,			//频率控制字
	output			[11:0]	pword_a			//相位控制字
	
	
); 

assign				fword_a = 85899346;
assign				pword_a = 0;
//--------------------------------
//Funtion : 频率控制字
//reg		[31：0]		fcnt;
//reg		[31：0]		fcnt;
//always @(posedge clk or negedge rst_n)
reg			[31:0]		fcnt;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fcnt <= 0;
	else 
		fcnt <= fcnt + fword_a;
end

//--------------------------------
//Funtion : 频率控制字  
reg		[11:0]	rom_sin_addr_a;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rom_sin_addr_a <= 0;
	else
		rom_sin_addr_a <= fcnt[31:20] + pword_a;
end


//--------------------------------
//Funtion : 频率控制字  

//--------------------------------
//Funtion : rom

rom_12_12	rom_12_12_inst (
	.address ( rom_sin_addr_a ),
	.clock ( clk ),
	.q ( da_out_a )
	);
			
		
endmodule

