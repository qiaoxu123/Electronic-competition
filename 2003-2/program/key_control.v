/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module key_control
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//key interface
	input		[7:0]		row_col,
	input					key_value,

	//触发 interface

	output	reg	[7:0]		one_chufa_data,
	output	reg	[5:0]		many_chufa_data,
	
	//time	line interface
	
	input					key_add,
	input					key_sub,
	output	reg	[9:0]		time_line,
	output	reg	[7:0]		time_line_data,
	
	//ram	data
	
	input		[7:0]		q_sig,
	input		[7:0]		q_sig_three,
	
	output	reg	[7:0]		vga_data,
	
	output		[5:0]		vga_addr,
	
	//翻页
	
	output	reg				next_ye,
	
	//vga		interface
	
	input		[9:0]		value_x,
	
	//ram flag value_x
	
	input					ram_flag_one,
	input					ram_flag_three


); 


//--------------------------------
//Funtion :  选择键 单级触发 or 多级触发            
reg			choice_flag;		//1 单级  0  多级

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		choice_flag <= 1'd0;
	else if(key_value)
	begin
		if(row_col == 8'h77)
			choice_flag <= ~choice_flag;
		else
			choice_flag <= choice_flag;
	end
	else
		choice_flag <= choice_flag;
end

//--------------------------------
//Funtion :  单级触发 数据
   
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		one_chufa_data <= 8'd0;
	else if(key_value && choice_flag)//1
	begin
		if(row_col == 8'h7b)			//0
			one_chufa_data <= {one_chufa_data[6:0],1'd0};
		else if(row_col == 8'h7d)
			one_chufa_data <= {one_chufa_data[6:0],1'd1};
		else
			one_chufa_data <= one_chufa_data;
	end
	else
		one_chufa_data <= one_chufa_data;
end


//--------------------------------
//Funtion :  多级触发 数据

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		many_chufa_data <= 6'd0;
	else if(key_value && !choice_flag) //0
	begin
		if(row_col == 8'h7b)
			many_chufa_data <= {many_chufa_data[4:0],1'd0};
		else if(row_col == 8'h7d)
			many_chufa_data <= {many_chufa_data[4:0],1'd1};
		else
			many_chufa_data <= many_chufa_data;
	end
	else
		many_chufa_data <= many_chufa_data;
end

//--------------------------------
//Funtion : 	time_line
// 0xbb 左移  0xb7 右移
reg		[20:0]		cnt_time_line;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_time_line <= 21'd0;
	else
		cnt_time_line <= cnt_time_line + 21'd1;
end

wire	cnt_time_line_value;
assign	cnt_time_line_value = (cnt_time_line == 21'd1) ? 1'b1 : 1'b0;


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		time_line <= 10'd105;
	else if(!key_add)
	begin
		if(cnt_time_line_value)
		begin
			if(time_line >= 10'd800)
				time_line <= 10'd800;
			else
				time_line <= time_line + 10'd1;
		end
		else	
			time_line <= time_line;
	end
	else if(!key_sub)
	begin
		if(cnt_time_line_value)
		begin
			if(time_line <= 10'd1)
				time_line <= 10'd1;
			else
				time_line <= time_line - 10'd1;
		end
	end
	else
		time_line <= time_line;
end

reg		[5:0]		time_line_addr;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		time_line_addr <= 6'd0;
	else if(time_line > 104)
		time_line_addr <= time_line / 6'd35 - 3;
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		time_line_data <= 8'd0;
	else if(time_line_addr == vga_addr)
		time_line_data <= vga_data;
end


//--------------------------------
//Funtion : 清屏 0xbd  1 清屏

reg				clear_lcd;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		clear_lcd <= 1'd1;
	else if(key_value)
	begin
		if(row_col == 8'hbd)
			clear_lcd <= ~clear_lcd;
		else
			clear_lcd <= clear_lcd;
	end
	else
		clear_lcd <= clear_lcd;
end


//--------------------------------
//Funtion : 选择 data
//choice_flag 1  单极  choice_flag 0 多级触发

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_data <= 8'd0;
	else if(clear_lcd)
		vga_data <= 8'd0;
	else if(!clear_lcd)
	begin
		if(choice_flag)
		begin
			if(ram_flag_one)
				vga_data <= q_sig;
			else
				vga_data <= 8'd0;
		end
		else
		begin
			if(ram_flag_three)
				vga_data <= q_sig_three;
			else
				vga_data <= 8'd0;
		end
	end
end

//--------------------------------
//Funtion :	addr

reg		[5:0]	addr_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		addr_temp <= 6'd0;
	else if(value_x >= 105 && value_x < 800)
		addr_temp <= value_x / 35 - 3;
/* 	else if(value_x >= 10'd0 && value_x < 10'd35)
		addr_temp <= 6'd0;
	else if(value_x >= 10'd35 && value_x < 10'd70)
		addr_temp <= 6'd1;
	else if(value_x >= 10'd70 && value_x < 10'd105)
		addr_temp <= 6'd2; */
/* 	else if(value_x >= 10'd105 && value_x < 10'd140)
		addr_temp <= 6'd3;
	else if(value_x >= 10'd140 && value_x < 10'd175)
		addr_temp <= 6'd4;
	else if(value_x >= 10'd175 && value_x < 10'd210)
		addr_temp <= 6'd5;
	else if(value_x >= 10'd210 && value_x < 10'd245)
		addr_temp <= 6'd6;
	else if(value_x >= 10'd245 && value_x < 10'd280)
		addr_temp <= 6'd7;
	else if(value_x >= 10'd280 && value_x < 10'd315)
		addr_temp <= 6'd8;
	else if(value_x >= 10'd315 && value_x < 10'd350)
		addr_temp <= 6'd9;
	else if(value_x >= 10'd350 && value_x < 10'd385)
		addr_temp <= 6'd10;
	else if(value_x >= 10'd385 && value_x < 10'd420)
		addr_temp <= 6'd11;
	else if(value_x >= 10'd420 && value_x < 10'd455)
		addr_temp <= 6'd12;
	else if(value_x >= 10'd455 && value_x < 10'd490)
		addr_temp <= 6'd13;
	else if(value_x >= 10'd490 && value_x < 10'd525)
		addr_temp <= 6'd14;
	else if(value_x >= 10'd525 && value_x < 10'd560)
		addr_temp <= 6'd15;
	else if(value_x >= 10'd560 && value_x < 10'd595)
		addr_temp <= 6'd16;
	else if(value_x >= 10'd595 && value_x < 10'd630)
		addr_temp <= 6'd17;
	else if(value_x >= 10'd630 && value_x < 10'd665)
		addr_temp <= 6'd18;
	else if(value_x >= 10'd665 && value_x < 10'd700)
		addr_temp <= 6'd19; */
end


//--------------------------------
//Funtion : 翻页  0xbe


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		next_ye <= 1'd0;
	else if(key_value)
	begin
		if(row_col == 8'hbe)
			next_ye <= ~next_ye;
		else
			next_ye <= next_ye;
	end
	else
		next_ye <= next_ye;
end

assign	vga_addr = (next_ye == 1'b0) ? addr_temp  : addr_temp + 6'd20;


endmodule
	
