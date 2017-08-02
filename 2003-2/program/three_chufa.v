/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module three_chufa
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//XXX interface
	input					key_sigle,
	input			[7:0]	q,
	input			[5:0]	q_set_three,
	input			[1:0]	q_two,
	//user interface

	output			[7:0]	q_sig_three	,	//
	
	input			[5:0]	vga_addr,
	
	output	reg				ram_flag_three
	
); 


//--------------------------------
//Funtion :  100HZ
//parameter		NUM_100HZ = 32'd499_999;
parameter	NUM_100HZ = 32'd49;
reg			[31:0]		cnt_100hz;
reg			[3:0]		three_state;


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_100hz <= 32'd0;
	else if(cnt_100hz == NUM_100HZ)
		cnt_100hz <= 32'd0;
	else if(three_state == 3'd1)
		cnt_100hz <= 32'd0;
	else
		cnt_100hz <= cnt_100hz + 1;
end

//--------------------------------
//Funtion :  100HZ  有效
wire		clk_100_value;

assign		clk_100_value = (cnt_100hz == NUM_100HZ >> 1) ? 1'b1 : 1'b0;

//--------------------------------
//Funtion :  缓存

reg			[7:0]		q_buffer;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		q_buffer <= 8'd0;
	else 
		q_buffer <= q;
end


//--------------------------------
//Funtion :  three_state


reg		[5:0]		w_addr;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		three_state <= 3'd0;
	else
		case(three_state)
		
		3'd0 :
		begin
			if(key_sigle)
				three_state <= 3'd1;
			else
				three_state <= 3'd0;
		end
		
		3'd1 :
		begin
			if(q_two == q_set_three[5:4])
				three_state <= 3'd2;
			else
				three_state <= 3'd1;
		end
		
		3'd2 :
		begin
			if(clk_100_value)
			begin
				if(q_two == q_set_three[3:2])
					three_state <= 3'd3;
				else
					three_state <= 3'd1;
			end
			else
				three_state <= 3'd2;
		end
		
		3'd3 :   
		begin
			if(clk_100_value)
			begin
				if(q_two == q_set_three[1:0])
					three_state <= 3'd4;
				else
					three_state <= 3'd1;
			end
			else
				three_state <= 3'd3;
		end
		
		3'd4  :
		begin
			if(w_addr == 42)
				three_state <= 3'd0;
			else
				three_state <= 3'd4;
		end
		default : ;
		endcase
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		w_addr <= 6'd0;
	else
		case(three_state)
		
		3'd0 :
		begin
			w_addr <= 6'd0;
		end
		
		3'd1 :
		begin
			w_addr <= 6'd0;
		end
		
		3'd2 :
		begin
			if(q_two == q_set_three[3:2])
				w_addr <= 6'd1;
			else
				w_addr <= 6'd0;
		end
		
		3'd3 :   
		begin

			if(q_two == q_set_three[1:0])
				w_addr <= 6'd2;
			else
				w_addr <= 6'd1;
		end
		
		3'd4  :
		begin
			if(clk_100_value)
				w_addr <= w_addr + 6'd1;
			else
				w_addr <= w_addr;
		end
		default : ;
	
		endcase
end


reg		[7:0]		data_sig;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		data_sig <= 8'd0;
	else
		data_sig <= q_buffer;
end	


reg					wren;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wren <= 1'd0;
	else if(key_sigle)
		wren <= 1'd1;
	else if(w_addr == 6'd42)
		wren <= 1'd0;
	else
		wren <= wren;
end

//--------------------------------
//Funtion :  ram

reg			[5:0]		r_addr;


ram_logic	ram_three_inst (
	.clock ( clk ),
	.data ( data_sig ),
	.rdaddress ( r_addr ),
	.wraddress ( w_addr ),
	.wren ( wren ),
	.q ( q_sig_three )
	);

//--------------------------------
//Funtion :  测试

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		r_addr <= 6'd0;
	else 
		r_addr <= vga_addr;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ram_flag_three <= 1'b0;
	else if(three_state == 3'd1)
		ram_flag_three <= 1'b0;
	else if(three_state == 3'd4)
		ram_flag_three <= 1'b1;
	else
		ram_flag_three <= ram_flag_three;
end


	

endmodule
	
