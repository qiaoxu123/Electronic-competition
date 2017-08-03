/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module phase_detect
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//fsanple interface
	input					clk_sample		//50.25M   测量精度200M

	//user interface

	
); 


//--------------------------------
//Funtion :   相位检测           
reg				sam_clk_buffer;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sam_clk_buffer <= 0;
	else
		sam_clk_buffer <= clk_sample;
end

reg				sam_clk_buffer1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sam_clk_buffer1 <= 0;
	else
		sam_clk_buffer1 <= sam_clk_buffer;
end

wire	phase_en;

assign	phase_en = (~sam_clk_buffer) & sam_clk_buffer1;






endmodule
	
