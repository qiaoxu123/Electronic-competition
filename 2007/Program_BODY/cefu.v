/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module cefu
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//XXX interface
	input			[9:0]	ad_data,

	//user interface

	output	reg		[10:0]	ad_mv		//
	
); 


//--------------------------------
//Funtion :               
//0.5S的方波

reg			[31:0]			cnt_half;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_half <= 0;
	else if(cnt_half == 24_999_999)
		cnt_half <= 0;
	else
		cnt_half <= cnt_half + 1;
end

wire						clk_half;

assign		clk_half = (cnt_half == 24_999_999) ? 1 : 0;

//--------------------------------
//Funtion :               
//clear and cunchu

wire						cunchu;
assign		cunchu =  (cnt_half == 24_000_000) ? 1 : 0;
//寻找最低值
reg		[9:0]		fuzhi_yuzhi;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fuzhi_yuzhi <= 255;
	else if(clk_half)
		fuzhi_yuzhi <= 255;
	else if(fuzhi_yuzhi > ad_data)
		fuzhi_yuzhi <= ad_data;
	else
		fuzhi_yuzhi <= fuzhi_yuzhi;
end 

//寻找最高值
reg		[9:0]		fuzhi_yuzhi1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fuzhi_yuzhi1 <= 0;
	else if(clk_half)
		fuzhi_yuzhi1 <= 0;
	else if(fuzhi_yuzhi1 < ad_data)
		fuzhi_yuzhi1 <= ad_data;
	else
		fuzhi_yuzhi1 <= fuzhi_yuzhi1;
end


reg		[31:0]		buffer_1;
reg		[31:0]		buffer_2;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		buffer_1 <= 0;
		buffer_2 <= 0;
	end
	else if(cunchu)
	begin
		buffer_1 <= fuzhi_yuzhi;
		buffer_2 <= buffer_1;
	end
end


reg		[31:0]		buffer_3;
reg		[31:0]		buffer_4;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		buffer_3 <= 0;
		buffer_4 <= 0;
	end
	else if(cunchu)
	begin
		buffer_3 <= fuzhi_yuzhi1;
		buffer_4 <= buffer_3;
	end
end
	




reg		[9:0]		fuzhi_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fuzhi_temp <= 0;
	else if(cunchu && (buffer_1 == buffer_2) )
		fuzhi_temp <= fuzhi_yuzhi;
	else
		fuzhi_temp <= fuzhi_temp;
end

reg		[9:0]		fuzhi_temp1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fuzhi_temp1 <= 0;
	else if(cunchu && (buffer_3 == buffer_4) )
		fuzhi_temp1 <= fuzhi_yuzhi1;
	else
		fuzhi_temp1 <= fuzhi_temp1;
end

reg		[31:0]		ad_mv1;
reg		[31:0]		ad_mv2;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ad_mv1 <= 0;
	else
		ad_mv1 <= fuzhi_temp * 1000;
end

	
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ad_mv2 <= 0;
	else
		ad_mv2 <= ad_mv1 / fuzhi_temp1;
end

always @(posedge clk )
	ad_mv <= ad_mv2;

endmodule
