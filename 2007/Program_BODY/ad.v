/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module ad
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//ad828 interface
	input			[9:0]	ad_data_in,
	output					ad_clk,
	//user interface
	output			[7:0]	ad_data
); 


//--------------------------------
//Funtion :	ad               
reg			[9:0]		ad_data_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ad_data_temp <= 0;
	else
		ad_data_temp <= ad_data_in;
end

assign		ad_data = ad_data_temp[9:2];

assign		ad_clk =~ clk;


endmodule
	
