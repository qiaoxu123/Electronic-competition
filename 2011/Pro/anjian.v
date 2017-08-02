/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 按键.

-----------------------------------------------------------------------*/

module anjian
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//button interface
	input					button_add,   	//
	input					button_sub,		//

	//user interface

	output	reg		[3:0]	button_data		//
); 


//--------------------------------
//Funtion :    分频  50Hz
reg		[31:0]		cnt_50hz;
parameter			CNT_50HZ_1 = 500_000;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_50hz <= 0;
	else if(cnt_50hz == CNT_50HZ_1 -1)
		cnt_50hz <= 0;
	else
		cnt_50hz <= cnt_50hz + 1;
end		
  

//--------------------------------
//Funtion :   clk  使能
wire			clk_50hz_value;
assign			clk_50hz_value = (cnt_50hz == CNT_50HZ_1 - 1) ? 1 : 0;


//--------------------------------
//Funtion :   消抖
reg				button_add_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		button_add_buffer <= 0;
	end
	else if(clk_50hz_value)
	begin
		button_add_buffer <= button_add;	
	end
	else
		button_add_buffer <= button_add_buffer;
end

reg				button_sub_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		button_sub_buffer <= 0;
	end
	else if(clk_50hz_value)
	begin
		button_sub_buffer <= button_sub;	
	end
	else
		button_sub_buffer <= button_sub_buffer;
end
 
 
//--------------------------------
//Funtion :   anjian value
wire		button_add_value;
wire		button_sub_value;

assign		button_add_value = (button_add && !button_add_buffer && clk_50hz_value) ? 1 : 0;
assign		button_sub_value = (button_sub && !button_sub_buffer && clk_50hz_value) ? 1 : 0;


//--------------------------------
//Funtion :   anjian data

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		button_data <= 2;
	else if(button_add_value)
	begin
		if(button_data == 9)
			button_data <= 0;
		else
			button_data <= button_data + 1;
	end
	else if(button_sub_value)
	begin
		if(button_data == 0)
			button_data <= 9;
		else
			button_data <= button_data - 1;
	end
	else
		button_data <= button_data;
	
end

endmodule
	
