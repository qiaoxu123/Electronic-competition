/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module dengxiao_2us
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//sig interface
	input					sample_sig,   	//
	input			[7:0]	ad_data,		//

	//vga interface
	input			[9:0]	value_x,
	input			[9:0]	value_y,

	//user interface

	output	reg		[7:0]	ad_data_dx_2		//
	
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
//Funtion :   sample_begin
           
reg				sample_buffer;
reg				sample_buffer1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sample_buffer  <= 0;
		sample_buffer1 <= 0;
	end
	else
	begin
		sample_buffer  <= sample_sig;
		sample_buffer1 <= sample_buffer; 
	end
end

wire		sample_begin;
assign		sample_begin = (sample_buffer == 1 && sample_buffer1 == 0) ? 1 : 0;



//--------------------------------
//Funtion :  100ns/div 采样状态机

reg		[31:0]		cnt_2us;
reg		[7:0]		num_2us;
reg		[31:0]		num_2us_all;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		num_2us <= 0;
	else if(cnt_2us >= num_2us_all)
	begin
		if(num_2us == 200)
			num_2us <= 0;
		else
			num_2us <= num_2us + 1;
	end
	else
		num_2us <= num_2us;
end
//200_000     20
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		num_2us_all <= 0;
	else
		num_2us_all <= num_2us*20;
end





always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_2us <= 0;
	else if(cnt_2us == 0 && sample_begin)
		cnt_2us <= cnt_2us + 1;
	else if(cnt_2us != 0)
	begin
		if(cnt_2us >= num_2us_all)
			cnt_2us <= 0;
		else
			cnt_2us <= cnt_2us + 1;
	end
end

wire	num_2us_value;

assign	num_2us_value = ((cnt_2us >= num_2us_all) || (num_2us == 0 && sample_begin) ) ? 1 : 0;

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
			if(wr_add_fre == 200 && sample_begin)
				state_ping <= 1;
			else
				state_ping <= 0;
		end
	
		2'd1 :  //wr_add_vga = 1
		begin
			if(wr_add_vga == 200 && sample_begin)
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
			if(wr_add_fre == 200 && sample_begin)
				wr_add_fre <= 0;
			else if(num_2us_value && wr_add_fre != 200)
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
			if(wr_add_vga == 200 && sample_begin)
				wr_add_vga <= 0;
			else if(num_2us_value && wr_add_vga != 200)
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
	else if(num_2us_value)
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
/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		rd_add_fre <= 0;
		rd_add_vga <= 0;
	end
	else if(rd_add_fre == 200)
	begin
		rd_add_fre <= 0;
		rd_add_vga <= 0;
	end
	else
	begin
		rd_add_fre <= rd_add_fre + 1;
		rd_add_vga <= rd_add_vga + 1;
	end
end
  */

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
		ad_data_dx_2 <= 0;
	else if(state_ping == 0)
		ad_data_dx_2 <= q_sig_vga;
	else
		ad_data_dx_2 <= q_sig_fre;
end

//--------------------------------
//Funtion : 两个ram		一个用来刷新数据 另一个vga显示


ram200_8	ram200_8_inst_fre_deng (
	.clock ( clk ),
	.data ( data_sig_fre ),
	.rdaddress ( rd_add_fre ),
	.wraddress ( wr_add_fre ),
	.wren ( wren_fre ),
	.q ( q_sig_fre )
	);


	ram200_8	ram200_8_inst_vga_deng (
	.clock ( clk ),
	.data ( data_sig_vga ),
	.rdaddress ( rd_add_vga ),
	.wraddress ( wr_add_vga ),
	.wren ( wren_vga ),
	.q ( q_sig_vga )
	);




endmodule




	
