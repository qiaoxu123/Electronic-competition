/*-----------------------------------------------------------------------

Date				:		2017-07-20
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module pr_2007
(
	//global clock
	input					clk,			//system clock
	input					rst_n,    		//sync reset
	
	//ad interface
	input		[9:0]		ad_data_in,
	output					ad_clk,

	//sample interface
	input					sample_sig,

	//button interface
	input					button_chui,   	//
	input					button_v,		//
	
	//vga	interface
	input					sw0,
	input					sw1,
	input					sw2,	//single
	input					sw3,	//auto  1   single 0

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
//Funtion :  pll             

wire			clk_200;
clk_sam clk_inst_u1(
		.  refclk(clk),   //  refclk.clk
		.  rst(!rst_n),      //   reset.reset
		.  outclk_0(clk_200) // outclk0.clk
		//.  locked    //  locked.export
	);

	
//--------------------------------
//Funtion :  detect_phase	
/* phase_detect	phase_inst_u2
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//fsanple interface
	.	clk_sample(clk_sample)

	//user interface

	
);  */

//--------------------------------
//Funtion :  ad
wire	[7:0]		ad_data;
wire	[7:0]		vga_data1;
ad		ad_u3
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//ad828 interface
	.	ad_data_in(ad_data_in),
	.	ad_clk(ad_clk),
	//user interface
	.	ad_data(ad_data)
); 

//--------------------------------
//Funtion :  vga	

wire		[23:0]		rgb;
wire		[9:0]		value_x;
wire		[9:0]		value_y;

/* vga_qudong		vga(
		.clk(clk),
		.rst_n(rst_n),
		.vga_clk(vga_clk),
		.vga_b(vga_b),
		.vga_g(vga_g),
		.vga_r(vga_r),
		.vga_blank(vga_blank),
		.vga_sync(vga_sync),
		.vga_hs(vga_hs),
		.vga_vs(vga_vs),
		.value_x(value_x),
		.value_y(value_y),
		.rgb(rgb)
); 


vga_control		vga_control(
		.clk(clk),
		.rst_n(rst_n),
		.value_x(value_x),
		.value_y(value_y),
		.rgb(rgb),
		.vga_data(vga_data)
); */
//--------------------------------
//Funtion :  实时采样	

wire		[7:0]		ad_data_sample_time;
sample_time		sample_time_u4
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//pinlv interface  	//
	.	ad_data(ad_data),		//

	//user interface

	.	sample_sig(sample_sig),
	
	//vga	interface
	.	value_x(value_x),
	.	value_y(value_y),
	.	ad_data_value(ad_data_sample_time)
	
);	
	
//--------------------------------
//Funtion :  dds

/* wire	[31:0]		fword_a;
wire	[11:0]		pword_a;
wire	[11:0]		da_out_a;	
dds				dds_tb
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//da interface
	.	da_out_a(da_out_a),			//da输出
	
	//user interface

	.	fword_a(fword_a),			//频率控制字
	.	pword_a(pword_a)			//相位控制字
	
	
);   */
	
//--------------------------------
//Funtion :  key

wire		[31:0]		pinlv;
wire		[7:0]		ad_data_dx_2;
wire		[7:0]		ad_data_dx_100;
wire		[1:0]		button_v_data;
wire		[1:0]		button_chui_data;






key		key_u5		
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//button interface
	.	button_chui(button_chui),   	//
	.	button_v(button_v),		//

	//user interface

	.	ad_data_dx_2(ad_data_dx_2),
	.	ad_data_dx_100(ad_data_dx_100),
	.	ad_data_sample_time(ad_data_sample_time),
	.	vga_data(vga_data1),
	.	pinlv(pinlv),
	.	button_v_data(button_v_data),
	.	button_chui_data(button_chui_data)
	
);	
	
//--------------------------------
//Funtion :  100ns/div等效采样


dengxiao_sample		u6
(
	//global clock
	.	clk(clk_200),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//sig interface
	.	sample_sig(sample_sig),   	//
	.	ad_data(ad_data),		//

	//vga interface
	.	value_x(value_x),
	.	value_y(value_y),

	//user interface

	.	ad_data_dx_100(ad_data_dx_100)		//
	
); 
	
	
//--------------------------------
//Funtion :  2us/div等效采样	

dengxiao_2us		tb_2us
(
	//global clock
	.	clk(clk_200),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//sig interface
	.	sample_sig(sample_sig),   	//
	.	ad_data(ad_data),		//

	//vga interface
	.	value_x(value_x),
	.	value_y(value_y),

	//user interface

	.	ad_data_dx_2(ad_data_dx_2)		//
	
);	
	
//--------------------------------
//Funtion :  等精度测频

cepin	cepin_u7
(
	//global clock
	.	clk(clk_200),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//pinlv interface
	.	sig_in(sample_sig),

	//user interface

	.	pinlv(pinlv)
	
); 

//--------------------------------
//Funtion :  测幅值
wire		[10:0]		ad_mv;
cefu		cefu_u8
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//XXX interface
	.	ad_data(ad_data_in),

	//user interface

	.	ad_mv(ad_mv)		//
); 
	
//--------------------------------
//Funtion : vga
vga_top		U9(
	
			.clk(clk),	
			.rst_n(rst_n),

			.VGA_CLK(vga_clk),
			.VGA_BLANK_N(vga_blank),
			.VGA_SYNC_N(vga_sync),
			.VGA_R(vga_r),
			.VGA_B(vga_b),
			.VGA_G(vga_g),
			.VGA_HS(vga_hs),
			.VGA_VS(vga_vs),			

			.vga_data(vga_data),
			.key_state2(button_v_data),
			.key_state1(button_chui_data),

			.value_x(value_x),
			.value_y(value_y),
			.freq(pinlv),
			.ad_level(ad_mv)

);


//--------------------------------
//Funtion :  存储

wire				[7:0]	vga_data;
storage		storage_u10
(
	//global clock
	.	clk(clk),			//system clock
	.	rst_n(rst_n),     		//sync reset
	
	//vga interface
	.	value_x(value_x),
	.	value_y(value_y),
	.	vga_data1(vga_data1),
	//button	interface
	
	.	sw0(sw0),    //存储电平
	.	sw1(sw1),	//显示波形
	.	sw2(sw2),
	.	sw3(sw3),
	//user interface

	.	vga_data(vga_data)	//
	
); 




	
endmodule
	
