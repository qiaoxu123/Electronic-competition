/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module rx
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//uart interface
	input					uart_rx,   	//

	//user interface
	input					bps_clk,
	output	reg		[31:0]	uart_rx_pinlv_data,		//
	output	reg		[31:0]	uart_rx_phase_data
); 


//--------------------------------
//Funtion :检测数据的下降沿               
reg			uart_buffer0;
reg			uart_buffer1;
wire		uart_neg;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		uart_buffer0 <= 0;
		uart_buffer1 <= 0;
	end
	else
	begin
		uart_buffer0 <= uart_rx;
		uart_buffer1 <= uart_buffer0;
	end
end

assign	uart_neg = (uart_buffer1 == 1 && uart_buffer0 == 0) ? 1 : 0;


//--------------------------------
//Funtion :接受数据标志位
reg		bps_start;
reg		[3:0]	num;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		bps_start <= 0;
	else if(uart_neg)
		bps_start <= 1;
	else if(num == 12)
		bps_start <= 0;
end

//--------------------------------
//Funtion :接受数据
reg		[7:0]		rx_data_temp;
reg		[7:0]		rx_data;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		num <= 0;
		rx_data_temp <= 0;
	end
	else if(bps_start)
	begin
		if(bps_clk)
		begin
			num <= num + 1;
			case(num)
				4'd1 : rx_data_temp[0] <= uart_rx;
				4'd2 : rx_data_temp[1] <= uart_rx;
				4'd3 : rx_data_temp[2] <= uart_rx;
				4'd4 : rx_data_temp[3] <= uart_rx;
				4'd5 : rx_data_temp[4] <= uart_rx;
				4'd6 : rx_data_temp[5] <= uart_rx;
				4'd7 : rx_data_temp[6] <= uart_rx;
				4'd8 : rx_data_temp[7] <= uart_rx;	
			default :;
			endcase
		end
		else if(num == 12)
		begin
			num <= 0;
			rx_data <=  rx_data_temp;
		end
	end
end




//--------------------------------
//Funtion :接受完一帧数据
reg			bps_start_buffer;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		bps_start_buffer <= 0;
	else
		bps_start_buffer <= bps_start;
end


wire		data_value;
assign		data_value = (bps_start == 0 && bps_start_buffer == 1) ? 1 : 0;


//--------------------------------
//Funtion :处理数据  pinlv
reg			[2:0]		rx_state;
reg			[31:0]		data_buffer_pinlv;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		rx_state <= 0;
		uart_rx_pinlv_data <= 0;
		data_buffer_pinlv <= 0;
	end
	else
	case(rx_state)
		3'd0 :
		begin
			if(data_value)
			begin
				if(rx_data == 8'haa)
					rx_state <= rx_state + 1;
				else
					rx_state <= rx_state;
			end
			else
				rx_state <= rx_state;
		end
		
		3'd1 :
		begin
			if(data_value)
			begin
				if(rx_data != 8'hbb)
				begin
					rx_state <= rx_state;
					data_buffer_pinlv <= data_buffer_pinlv << 8 + rx_data;
				end
				else if(rx_data == 8'hbb)
				begin
					rx_state <= 0;
					uart_rx_pinlv_data <= data_buffer_pinlv;
				end
			end
			else
				rx_state <= rx_data;
		end
		
		default : rx_state <= 0;		
		
	endcase
end


//--------------------------------
//Funtion :处理数据  phase
reg			[2:0]		rx_state_1;
reg			[31:0]		data_buffer_phase;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		rx_state_1 <= 0;
		uart_rx_phase_data <= 0;
		data_buffer_phase <= 0;
	end
	else
	case(rx_state_1)
		3'd0 :
		begin
			if(data_value)
			begin
				if(rx_data == 8'hcc)
					rx_state_1 <= rx_state_1 + 1;
				else
					rx_state_1 <= rx_state_1;
			end
			else
				rx_state_1 <= rx_state_1;
		end
		
		3'd1 :
		begin
			if(data_value)
			begin
				if(rx_data != 8'hdd)
				begin
					rx_state_1 <= rx_state_1;
					data_buffer_phase <= data_buffer_phase << 8 + rx_data;
				end
				else if(rx_data == 8'hdd)
				begin
					rx_state_1 <= 0;
					uart_rx_phase_data <= data_buffer_phase;
				end
			end
			else
				rx_state_1 <= rx_state_1;
		end
		
		default : rx_state_1 <= 0;		
		
	endcase
end







endmodule
	
