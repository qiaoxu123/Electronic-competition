module	uart_tx(
		//global clock
		input			clk,
		input			rst_n,
		//uart	interface
		output	reg		uart_tx,
		//user	interface
		input	[31:0]	pinlv,
		input	[31:0]	cycle,
		input	[31:0]	duty_cycle,
		output	reg     [3:0]	state
);

parameter	BPS_9600 = 5208;
//parameter	BPS_9600 = 10;
//count for bps_clk
reg		[14:0]		cnt_bps_clk;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_bps_clk <= 1'b0;
	else if(cnt_bps_clk == BPS_9600 - 1)
		cnt_bps_clk <= 1'b0;
	else
		cnt_bps_clk <= cnt_bps_clk + 1;
end

reg		[31:0]		cnt_bps_stop;
wire				stop_done;
wire				fresh_uart;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_bps_stop <= 0;
	else if(state == STOP)
		cnt_bps_stop <= 0;
	else if(cnt_bps_stop > 25_000_00)
		cnt_bps_stop <= 0;
	else
		cnt_bps_stop <= cnt_bps_stop + 1;

end
assign	stop_done = (cnt_bps_stop == 24_000_00) ? 1 : 0;
assign	fresh_uart = (cnt_bps_stop == 20_000_00) ? 1 : 0;
//clk for bps
reg					bps_clk;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		bps_clk <= 1'b0;
	else if(cnt_bps_clk == 1)
		bps_clk <= 1'b1;
	else
		bps_clk <= 1'b0;
end
//cnt for bps
reg		[14:0]		bps_cnt;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		bps_cnt <= 1'b0;
	else if(bps_cnt == 10)
		bps_cnt <= 0;
	else if(bps_clk)
		bps_cnt <= bps_cnt + 1'b1;
	else
		bps_cnt <= bps_cnt;
end



//tx state
localparam	IDLE		=	4'd0;
localparam	TX_1		=	4'd1;
localparam	TX_2		=	4'd2;
localparam	TX_3		=	4'd3;
localparam	TX_4		=	4'd4;
localparam	STOP		=	4'd5;
localparam	STOP_1		=	4'd6;
//cnt state
//reg		[3:0]		state;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state <= IDLE;
	else if(state == STOP_1 && stop_done)
		state <= IDLE;
	else if(bps_cnt == 10 && (state != STOP_1))
		state <= state + 1;
end


// state tx
always @(posedge clk )
begin
	if(bps_clk)
	begin
		case(state)
		IDLE :   // 't'  di -- gao
		begin
			case(bps_cnt)
			4'd0 	: uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_begin[0];//data
			4'd2 	: uart_tx <= uart_begin[1];
			4'd3 	: uart_tx <= uart_begin[2];
			4'd4 	: uart_tx <= uart_begin[3];
			4'd5 	: uart_tx <= uart_begin[4];
			4'd6	: uart_tx <= uart_begin[5];
			4'd7 	: uart_tx <= uart_begin[6];
			4'd8 	: uart_tx <= uart_begin[7];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase
		end
		
		TX_1 : //tx_1byte
		begin
			case(bps_cnt)
			4'd0 : uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_value[24];//data
			4'd2 	: uart_tx <= uart_value[25];
			4'd3 	: uart_tx <= uart_value[26];
			4'd4 	: uart_tx <= uart_value[27];
			4'd5 	: uart_tx <= uart_value[28];
			4'd6	: uart_tx <= uart_value[29];
			4'd7 	: uart_tx <= uart_value[30];
			4'd8 	: uart_tx <= uart_value[31];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase		
		end
		
		TX_2 : //tx_1byte
		begin
			case(bps_cnt)
			4'd0 : uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_value[16];//data
			4'd2 	: uart_tx <= uart_value[17];
			4'd3 	: uart_tx <= uart_value[18];
			4'd4 	: uart_tx <= uart_value[19];
			4'd5 	: uart_tx <= uart_value[20];
			4'd6	: uart_tx <= uart_value[21];
			4'd7 	: uart_tx <= uart_value[22];
			4'd8 	: uart_tx <= uart_value[23];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase		
		end	


		TX_3 : //tx_1byte
		begin
			case(bps_cnt)
			4'd0 : uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_value[8];//data
			4'd2 	: uart_tx <= uart_value[9];
			4'd3 	: uart_tx <= uart_value[10];
			4'd4 	: uart_tx <= uart_value[11];
			4'd5 	: uart_tx <= uart_value[12];
			4'd6	: uart_tx <= uart_value[13];
			4'd7 	: uart_tx <= uart_value[14];
			4'd8 	: uart_tx <= uart_value[15];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase				
		end	

		TX_4 : //tx_1byte
		begin
			case(bps_cnt)
			4'd0 : uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_value[0];//data
			4'd2 	: uart_tx <= uart_value[1];
			4'd3 	: uart_tx <= uart_value[2];
			4'd4 	: uart_tx <= uart_value[3];
			4'd5 	: uart_tx <= uart_value[4];
			4'd6	: uart_tx <= uart_value[5];
			4'd7 	: uart_tx <= uart_value[6];
			4'd8 	: uart_tx <= uart_value[7];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase					
		end
		
		STOP :   // 'x'  di -- gao
		begin
			case(bps_cnt)
			4'd0 : uart_tx <= 0; //begin
			
			4'd1 	: uart_tx <= uart_end[0];//data
			4'd2 	: uart_tx <= uart_end[1];
			4'd3 	: uart_tx <= uart_end[2];
			4'd4 	: uart_tx <= uart_end[3];
			4'd5 	: uart_tx <= uart_end[4];
			4'd6	: uart_tx <= uart_end[5];
			4'd7 	: uart_tx <= uart_end[6];
			4'd8 	: uart_tx <= uart_end[7];
			
			4'd9 	: uart_tx <= 1; //stop
			default : uart_tx <= 1;
			endcase
		end
		
		STOP_1 :
		begin
			uart_tx <= 1;
		end
		
		default :
			uart_tx <= 1;
		endcase
	end
	else
		uart_tx <= uart_tx;

end

//state order

	
reg		[2:0]	state_order;
reg		[31:0]	uart_value;
reg		[7:0]	uart_begin;
reg		[7:0]	uart_end;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_order <= 0;
	else 
	case(state_order)
	
	3'd0 :
	begin
		if(state == STOP_1 && stop_done)
			state_order <= state_order + 1;
		else
			state_order <= 0;
	end
	
	3'd1 :
	begin
		if(state == STOP_1 && stop_done)
			state_order <= state_order + 1;
		else
			state_order <= 1;
	end
	
	3'd2 :
	begin
		if(state == STOP_1 && stop_done)
			state_order <= 0;
		else
			state_order <= 2;
	end
	
	default :
		state_order <= 0;
	
	endcase
end


reg		[2:0]		state_ben;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_ben <= 0;
	else 
	case(state_ben)
	
	3'd0 :
	begin
		if(state == STOP_1 && fresh_uart)
			state_ben <= state_ben + 1;
		else
			state_ben <= 0;
	end
	
	3'd1 :
	begin
		if(state == STOP_1 && fresh_uart)
			state_ben <= state_ben + 1;
		else
			state_ben <= 1;
	end
	
	3'd2 :
	begin
		if(state == STOP_1 && fresh_uart)
			state_ben <= 0;
		else
			state_ben <= 2;
	end
	
	default :
		state_ben <= 0;
	
	endcase
end



always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		uart_value <= 0;
	else
	case(state_order)
	3'd0 : uart_value <= pinlv;
	3'd1 : uart_value <= pinlv[31:8];
	3'd2 : uart_value <= pinlv[7:0];
	default : ;
	endcase
end
//pinlv
//t    74
//x	   78
//cycle
//c    63
//y    79
//duty_cycle
//d    64
//u    75        
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		uart_begin <= 8'd0;
		uart_end   <= 8'd0;
	end
	else 
	case(state_ben)
	3'd0 :
	begin
		uart_begin <= 8'h74;
		uart_end   <= 8'h78;
	end
	
	3'd1 :
	begin
		uart_begin <= 8'h63;
		uart_end   <= 8'h79;
	end
	
	3'd2 :
	begin
		uart_begin <= 8'h64;
		uart_end   <= 8'h75;
	end
	
	default : ;
	endcase
end







endmodule