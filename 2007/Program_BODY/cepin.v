/*-----------------------------------------------------------------------

Date				:		2017-07-04
Description			:		Design for 等精度测频.

-----------------------------------------------------------------------*/

module cepin
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//pinlv interface
	input					sig_in,

	//user interface

	output	reg		[31:0]	pinlv
	
); 




//--------------------------------
//Funtion : 对实际闸门的下降沿进行检测
reg			sig_in_buffer;
reg			sig_in_buffer1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_buffer <= 0;
	else
		sig_in_buffer <= start_cnt;
end
assign		start_cnt_neg = (sig_in_buffer1 == 0 && sig_in_buffer == 1) ? 1 : 0;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_buffer1 <= 0;
	else
		sig_in_buffer1 <= sig_in_buffer;
end


//--------------------------------
//Funtion : 预制闸门占空比可调
parameter	F_1S = 199_999_999; //200M
//fgate
reg		fgate;
reg		[31:0]		fgate_cnt;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate_cnt <= 0;
	else if(fgate)
	begin
		if(fgate_cnt >= F_1S)
			fgate_cnt <= 0;
		else
		fgate_cnt <= fgate_cnt + 1;
	end
	else if(!fgate)
	begin
		if(fgate_cnt >= F_1S || start_cnt_neg)
			fgate_cnt <= 0;
		else
			fgate_cnt <= fgate_cnt + 1;
	end
	else
		fgate_cnt <= fgate_cnt;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate <= 0;
	else if(fgate)
	begin
		if(fgate_cnt >= F_1S)
			fgate <= 0;
		else
			fgate <= fgate;
	end
	else if(!fgate)
	begin
		if(fgate_cnt >= F_1S || start_cnt_neg)
			fgate <= 1;
		else
			fgate <= fgate;
	end
	else
		fgate <= fgate;
end

//--------------------------------
//Funtion : 实际闸门
reg		start_cnt;
always @(posedge sig_in)
begin
	if(fgate)
		start_cnt <= 1;
	else
		start_cnt <= 0;
end

//--------------------------------
//Funtion : 被测信号Fc的个数
reg		[31:0]		fx_cnt_temp;
always @(posedge sig_in or negedge rst_n)
begin
	if(!rst_n)
		fx_cnt_temp <= 0;
	else if(start_cnt)
		fx_cnt_temp <= fx_cnt_temp + 1;
	else
		fx_cnt_temp <= 0;
end

//--------------------------------
//Funtion : 被测信号的频率
always @(negedge start_cnt)
begin
	pinlv <= fx_cnt_temp;
end



endmodule