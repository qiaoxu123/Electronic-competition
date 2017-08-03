/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 按键.

-----------------------------------------------------------------------*/

module key
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//button interface
	input					button_chui,   	//
	input					button_v,		//
//	input					button_storage,
	//user interface
	
	input			[7:0]	ad_data_dx_2,
	input			[7:0]	ad_data_dx_100,
	input			[7:0]	ad_data_sample_time,
	
	input			[31:0]	pinlv,
	
	output	reg		[7:0]	vga_data,

	output	reg		[1:0]	button_v_data,
	output	reg		[1:0]	button_chui_data
//	output	reg				button_storage_data
	
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
reg				button_chui_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		button_chui_buffer <= 0;
	end
	else if(clk_50hz_value)
	begin
		button_chui_buffer <= button_chui;	
	end
	else
		button_chui_buffer <= button_chui_buffer;
end

reg				button_v_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		button_v_buffer <= 0;
	end
	else if(clk_50hz_value)
	begin
		button_v_buffer <= button_v;	
	end
	else
		button_v_buffer <= button_v_buffer;
end
 
/* reg				button_storage_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		button_storage_buffer <= 0;
	end
	else if(clk_50hz_value)
	begin
		button_storage_buffer <= button_storage;	
	end
	else
		button_storage_buffer <= button_storage_buffer;
end
  */
//--------------------------------
//Funtion :   anjian value
wire		button_chui_value;
wire		button_v_value;
wire		button_storage_value;

assign		button_chui_value = (button_chui && !button_chui_buffer && clk_50hz_value) ? 1 : 0;
assign		button_v_value    = (button_v && !button_v_buffer && clk_50hz_value) ? 1 : 0;


//--------------------------------
//Funtion :   anjian data

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		button_chui_data <= 0;
	else if(button_chui_value)
	begin
		if(button_chui_data == 2)
			button_chui_data <= 0;
		else
			button_chui_data <= button_chui_data + 1;
	end
	else
		button_chui_data <= button_chui_data;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		button_v_data <= 0;		
	else if(button_v_value)
	begin
		if(button_v_data == 2)
			button_v_data <= 0;
		else
			button_v_data <= button_v_data + 1;
	end
	else
		button_v_data <= button_v_data;
end

/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		button_storage_data <= 0;
	else if(button_storage_value)
		button_storage_data <= button_storage + 1;
	else
		button_storage_data <= button_storage_data;
end */
//--------------------------------
//Funtion :   vga_data

reg		[7:0]		vga_data1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_data1 <= 0;
	else if((pinlv < 50_000) && button_v_data == 0)  //实时采样
		vga_data1 <= ad_data_sample_time;
	else if((pinlv >= 50_000) && button_v_data == 2)		//100ns/div
		vga_data1 <= ad_data_dx_100;
	else if((pinlv >= 50_000) && button_v_data == 1)		//2us/div
		vga_data1 <= ad_data_dx_2;
	else
		vga_data1 <= vga_data1;
end

reg		[7:0]		vga_fu1; //8V

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_fu1 <= 0;
	else
		vga_fu1 <= vga_data1 >> 2;
end

reg		[7:0]		vga_fu2_1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_fu2_1 <= 0;
	else
		vga_fu2_1 <= vga_data1 << 1;
end

reg		[7:0]		vga_fu2_2;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_fu2_2 <= 0;
	else
		vga_fu2_2 <=  vga_data1 >> 1;
end

reg		[7:0]		vga_fu2;

always @(posedge clk or negedge rst_n)	//0.8V
begin
	if(!rst_n)
		vga_fu2 <= 0;
	else
		vga_fu2 <= vga_fu2_1 + vga_fu2_2;
end

reg		[7:0]		vga_fu3;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_fu3 <= 0;
	else
		vga_fu3 <= vga_data1 << 7;
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_data <= 0;
	else
	case(button_chui_data)

		2'd0 :
			vga_data <= 128 - vga_fu2 - 75; //0.8v
		2'd1 :
			vga_data <= 128 - vga_fu3; //16mv
		2'd2 :
			vga_data <= 128 - vga_fu1 - 96;//2v
		default :
			vga_data <= 0;
	endcase
end














endmodule
	
