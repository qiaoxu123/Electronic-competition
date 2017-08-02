/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module pro_2003
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//key interface

	
	//key_board interface
	input			[3:0]	row,
	output			[3:0]	col,
	//time_line
	input					key_add,
	input					key_sub,
	//ceshi

	//vga	interface
	output					vga_clk,
	output		[7:0]		vga_b,
	output		[7:0]		vga_g,
	output		[7:0]		vga_r,
	output					vga_blank,
	output					vga_sync,
	output					vga_hs,
	output					vga_vs
); 

//--------------------------------
//Funtion :   信号源测试
wire		[7:0]		shift_sig;

shift_sig	U1
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//shift_sig interface
	.	shift_sig(shift_sig)   	//
	
); 


//--------------------------------
//Funtion :   字触发           
wire		[7:0]		q_sig;
wire					ram_flag_one;
//wire		[7:0]		one_set = 8'b1111_1111;
single_chufa	U2
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//q0 ~ q7 interface
	.	key_sigle(key_value),
	.	q(shift_sig),
	.	q_set(one_chufa_data),
	.	q_sig(q_sig),
	//user interface
	.	vga_addr(vga_addr),
	.	ram_flag_one(ram_flag_one)

	
); 

//--------------------------------
//Funtion :   三级触发
wire		[1:0]			q_two   		=		shift_sig[7:6];
wire		[7:0]			q_sig_three;
wire						ram_flag_three;
//wire		[5:0]		q_set_three = 6'b10_01_10;
three_chufa		U3
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//XXX interface
	.	key_sigle(key_value),
	.	q(shift_sig),
	.	q_set_three(many_chufa_data),
	.	q_two(q_two),
	//user interface
	.	q_sig_three(q_sig_three),		//
	.	vga_addr(vga_addr),
	.	ram_flag_three(ram_flag_three)
); 


//--------------------------------
//Funtion :   key_board 驱动程序
wire		[7:0]	row_col;
wire				key_value;

key_board		U4
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//key_board	interface
	
	.	row(row),
	.	col(col),
	
	//user		interface
	
	.	key_value(key_value),
	.	row_col(row_col)
	
); 
//--------------------------------
//Funtion :   key_control
wire		[7:0]		one_chufa_data;
wire		[5:0]		many_chufa_data;//预设数据
wire		[9:0]		time_line;
wire		[7:0]		vga_data;
wire		[5:0]		vga_addr;
wire					next_ye;
wire		[9:0]		value_x;
wire		[7:0]		time_line_data;

key_control		U5
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//key interface
	.	row_col(row_col),
	.	key_value(key_value),
   
	//触发 interface

	.	one_chufa_data(one_chufa_data),
	.	many_chufa_data(many_chufa_data),
	
	//time	line interface
	
	.	key_add(key_add),
	.	key_sub(key_sub),
	.	time_line(time_line),
	.	time_line_data(time_line_data),
	//ram	data
	
	.	q_sig(q_sig),
	.	q_sig_three(q_sig_three),
	
	.	vga_data(vga_data),

	.	vga_addr(vga_addr),
	
	//翻页
	
	.	next_ye(next_ye),
	
	//vga		interface
	
	.	value_x(value_x),
	
	.	ram_flag_one(ram_flag_one),
	.	ram_flag_three(ram_flag_three)
);

//--------------------------------
//Funtion :   key_control


vga_top			U6(
	
	.	clk(clk),	
	.	rst_n(rst_n),
	
	//
	.	value_x(value_x),
	.	vga_data(vga_data),
	.	time_line(time_line),
	.	time_line_data(time_line_data),
	.	one_chufa_data(one_chufa_data),
	.	many_chufa_data(many_chufa_data),
	.	next_page(next_ye),
	
	
	//ga引脚定义
	.	VGA_CLK(vga_clk),
	.	VGA_BLANK_N(vga_blank),
	.	VGA_SYNC_N(vga_sync),
	.	VGA_R(vga_r),
	.	VGA_B(vga_b),
	.	VGA_G(vga_g),
	.	VGA_HS(vga_hs),
	.	VGA_VS(vga_vs)		


);

endmodule
	
