/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module storage
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//vga interface
	input			[9:0]	value_x,
	input			[9:0]	value_y,
	input			[7:0]	vga_data1,
	
	//button	interface
	
	input					sw0,    //存储电平
	input					sw1,	//显示波形
	input					sw2,	//single
	input					sw3,	//auto  1   single 0
	//user interface

	output	reg		[7:0]	vga_data,	//
	
	
	output			[7:0]	q_sig,
	output	reg		[7:0]	data_sig
	
); 


//--------------------------------
//Funtion : 		存储状态机              
reg		[1:0]		state_storage;
reg					flag;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_storage <= 0;
		flag          <= 0;
	end
	else 
	case(state_storage)
	3'd0 :					//打开存储开关
	begin
		flag <= 0;
		if(sw0 && ~sw1)      
			state_storage <= 1;
		else
			state_storage <= 0;
	end
	
	3'd1 :					//写数据
	begin	
		if(wr_addr == 199 )
		begin
			if(flag)
				state_storage <= 0;
			else
				state_storage <= 1;
			flag <= flag + 1;
				
		end
		else
			state_storage <= 1;
	end
	
	default : ;
	endcase
end

//--------------------------------
//Funtion : write addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_addr <= 0;
	else
	begin
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
		begin
			if(state_storage)
				wr_addr <= value_x - 100;
			else
				wr_addr <= wr_addr;
		end
		else
			wr_addr <= 0;
	end
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		data_sig <= 0;
	else if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
		data_sig <= vga_data1;
	else
		data_sig <= data_sig;
	
end
//--------------------------------
//Funtion :	read  addr
 
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_addr <= 0;
	else if(sw1)   //显示存储波形
	begin
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
			rd_addr <= value_x - 100;
		else
			rd_addr <= rd_addr;
	end
	else
		rd_addr <= rd_addr;
end

//--------------------------------
//Funtion :	wren
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wren <= 0;
	else if(sw1)
		wren <= 0;
	else
		wren <= 1;
end

//--------------------------------
//Funtion :    storage
reg			[7:0]		rd_addr;
reg			[7:0]		wr_addr;

reg						wren;

ram_storage	ram_storage_inst (
	.clock ( clk ),
	.data ( data_sig ),
	.rdaddress ( rd_addr ),
	.wraddress ( wr_addr ),
	.wren ( wren ),
	.q ( q_sig )
	);


//assign		vga_data = (sw1 == 1) ? q_sig : vga_data1;


//*************************************************************************//
//Funtion :    single

//--------------------------------
//Funtion : 		single_value

reg						single_buffer;
reg						single_buffer1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		single_buffer  <= 0;
		single_buffer1 <= 0;
	end
	else
	begin
		single_buffer  <= sw2;
		single_buffer1 <= single_buffer;
	end
end

wire	sigle_value;
assign	sigle_value = single_buffer ^ single_buffer1;








reg			[7:0]		rd_addr_single;
reg			[7:0]		wr_addr_single;
reg			[7:0]		data_sig_single;
reg						wren_single;
wire		[7:0]		q_sig_single;

ram_storage	ram_single (
	.clock ( clk ),
	.data ( data_sig_single ),
	.rdaddress ( rd_addr_single ),
	.wraddress ( wr_addr_single ),
	.wren ( wren_single ),
	.q ( q_sig_single )
	);


//--------------------------------
//Funtion : 		存储状态机              
reg		[1:0]		state_storage_s;
reg					flag_s;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_storage_s <= 0;
		flag_s			<= 0;
	end
	else 
	case(state_storage_s)
	3'd0 :					//打开存储开关
	begin
		flag_s <= 0;
		if(sigle_value)      
			state_storage_s <= 1;
		else
			state_storage_s <= 0;
	end
	
	3'd1 :					//写数据
	begin	
		if(wr_addr_single == 199 )
		begin
			if(flag_s)
				state_storage_s <= 0;
			else
				state_storage_s <= 1;
			flag_s <= flag_s + 1;
				
		end
		else
			state_storage_s <= 1;
	end
	
	default : ;
	endcase
end

//--------------------------------
//Funtion : write addr

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wr_addr_single <= 0;
	else
	begin
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
		begin
			if(state_storage_s)
				wr_addr_single <= value_x - 100;
			else
				wr_addr_single <= wr_addr_single;
		end
		else
			wr_addr_single <= 0;
	end
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		data_sig_single <= 0;
	else if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
		data_sig_single <= vga_data1;
	else
		data_sig_single <= data_sig_single;
	
end
//--------------------------------
//Funtion :	read  addr
 
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rd_addr_single <= 0;
	else 
	begin
		if((value_x >= 100 && value_x < 300) && (value_y >= 200 && value_y < 456))
			rd_addr_single <= value_x - 100;
		else
			rd_addr_single <= rd_addr_single;
	end

end

//--------------------------------
//Funtion :	wren
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		wren_single <= 0;
	else if(state_storage_s)
		wren_single <= 1;
	else
		wren_single <= 0;
end
//--------------------------------
//Funtion :	数据选择

	
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_data <= 0;
	else if(sw3)
	begin
		if(sw1)
			vga_data <= q_sig;
		else
			vga_data <= vga_data1;
	end
	else
		vga_data <= q_sig_single;
end
	



endmodule
	
