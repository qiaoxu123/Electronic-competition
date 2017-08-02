/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module sample_time
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//pinlv interface  	//
	input			[7:0]	ad_data,		//

	//user interface

	input					sample_sig,
	
	//vga	interface
	input			[9:0]	value_x,
	input			[9:0]	value_y,
	output	reg	    [7:0]	ad_data_value
	
); 
//*******************************//

reg			[7:0]		data_sig_vga;
reg			[7:0]		rd_add_vga;
reg			[7:0]		wr_add_vga;
reg						wren_vga;		//1 write	0read
wire		[7:0]		q_sig_vga;	


reg			[7:0]		data_sig_fre;
reg			[7:0]		rd_add_fre;
reg			[7:0]		wr_add_fre;
reg						wren_fre;		//1 write	0read
wire		[7:0]		q_sig_fre;


//--------------------------------
//Funtion :  sample_begin
reg			sample_buffer;
reg			sample_buffer1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sample_buffer <= 0;
		sample_buffer1 <= 0;
	end
	else
	begin
		sample_buffer <= sample_sig;
		sample_buffer1 <= sample_buffer;
	end
end
wire	sample_begin;
assign	sample_begin = (sample_buffer == 1 && sample_buffer1 == 0) ? 1 : 0;


//--------------------------------
//Funtion :  1Msample
reg			[7:0]		cnt_1m;
parameter				NUM_1m = 49;
reg			[7:0]		sample_1m_data;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_1m <= 0;
	else if(cnt_1m == NUM_1m)
		cnt_1m <= 0;
	else
		cnt_1m <= cnt_1m + 1;
end

wire	sample_1m;
assign	sample_1m = (cnt_1m == NUM_1m) ? 1 : 0;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sample_1m_data <= 0;
	else if(sample_1m)
		sample_1m_data <= ad_data;
	else
		sample_1m_data <= sample_1m_data;
end

//Funtion :  1ksample             
reg			[31:0]		cnt_1k;
//parameter				NUM_1K = 999;
parameter				NUM_1K = 49_999;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_1k <= 0;
	else if(cnt_1k == NUM_1K || (wr_add_fre == 255 && sample_begin ) || (wr_add_vga == 255 && sample_begin))
		cnt_1k <= 0;
	else 
		cnt_1k <= cnt_1k + 1;
end

wire					sample_1k;
assign		sample_1k = (cnt_1k == NUM_1K) ? 1 : 0;

//--------------------------------
//Funtion :  pingpang

reg		[1:0]		state_ping;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_ping <= 0;
	else 
	case(state_ping)
		2'd0 :    //wren_fre = 1
		begin
			if(wr_add_fre == 255 && sample_begin)
				state_ping <= 1;
			else
				state_ping <= 0;
		end
	
		2'd1 :  //wr_add_vga = 1
		begin
			if(wr_add_vga == 255 && sample_begin)
				state_ping <= 0;
			else
				state_ping <= 1;
		end
		
		default : state_ping <= 0;
	endcase
end

//--------------------------------
//Funtion :  sample_begin

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_add_fre <= 0;
	else 
	case(state_ping)
		2'd0 :    //wren_fre = 1
		begin
			if(wr_add_fre == 255 && sample_begin)
				wr_add_fre <= 0;
			else if(sample_1k && wr_add_fre != 255)
				wr_add_fre <= wr_add_fre + 1;
		end
	
		2'd1 :  //wr_add_vga = 1
		begin
			wr_add_fre <= wr_add_fre;
		end
		
		default : wr_add_fre <= 0;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_add_vga <= 0;
	else 
	case(state_ping)
		2'd0 :    //wren_fre = 1
		begin
			wr_add_vga <= wr_add_vga;
		end
	
		2'd1 :  //wr_add_vga = 1
		begin
			if(wr_add_vga == 255 && sample_begin)
				wr_add_vga <= 0;
			else if(sample_1k && wr_add_vga != 255)
				wr_add_vga <= wr_add_vga + 1;
		end
		
		default : wr_add_vga <= 0;
	endcase
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		data_sig_fre <= 0;
		data_sig_vga <= 0;
	end
	else if(sample_1k)
	begin
		data_sig_fre <= ad_data;
		data_sig_vga <= ad_data;
	end
	else
	begin
		data_sig_fre <= data_sig_fre;
		data_sig_vga <= data_sig_vga;
	end
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		wren_fre <= 0;
		wren_vga <= 0;
	end
	else
	case(state_ping)
		2'd0 :
		begin
			wren_fre <= 1;
			wren_vga <= 0;
		end
		
		2'd1 :
		begin
			wren_fre <= 0;
			wren_vga <= 1;
		end
		
		default :
		begin
			wren_fre <= 1;
			wren_vga <= 0;
		end
	endcase
end



//--------------------------------
//Funtion :  sample_read

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_add_fre <= 0;
	else if(state_ping == 1 )//&& vga_write_rom_value)
	begin
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
			rd_add_fre <= value_x - 100;
		else
			rd_add_fre <= rd_add_fre;
	end
	else
		rd_add_fre <= rd_add_fre;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_add_vga <= 0;
	else if(state_ping == 0 )//&& vga_write_rom_value)
	begin	
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
			rd_add_vga <= value_x - 100;
		else
			rd_add_vga <= rd_add_vga;
	end
	else
		rd_add_vga <= rd_add_vga;
end

//--------------------------------
//Funtion :  sample_read


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ad_data_value <= 0;
	else if(state_ping == 0)
		ad_data_value <= q_sig_vga;
	else
		ad_data_value <= q_sig_fre;
end

//--------------------------------
//Funtion : 两个ram		一个用来刷新数据 另一个vga显示


ram200_8	ram200_8_inst_fre (
	.clock ( clk ),
	.data ( data_sig_fre ),
	.rdaddress ( rd_add_fre ),
	.wraddress ( wr_add_fre ),
	.wren ( wren_fre ),
	.q ( q_sig_fre )
	);


	ram200_8	ram200_8_inst_vga (
	.clock ( clk ),
	.data ( data_sig_vga ),
	.rdaddress ( rd_add_vga ),
	.wraddress ( wr_add_vga ),
	.wren ( wren_vga ),
	.q ( q_sig_vga )
	);




endmodule
	
