module	duty_cycle(
		//system	interface
		input				clk,
		input				rst_n,
		//sig		interface
		input				sig_in,
		//user		interface
		output	reg	[31:0]	duty_cycle,
		output				pos_pulse,
		output				neg_pulse,
		output	reg	[31:0]	duty_high,
		output	reg	[31:0]	duty_low
);

// wire				pos_pulse;
// wire				neg_pulse;

reg					sig_buffer;
reg					sig_buffer1;
reg					sig_buffer2;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sig_buffer  <= 0;
		sig_buffer1 <= 0;
		sig_buffer2 <= 0;
	end
	else
	begin
		sig_buffer  <= sig_in;
		sig_buffer1 <= sig_buffer;
		sig_buffer2 <= sig_buffer1;
	end
end
assign pos_pulse = (sig_buffer1 == 1 && sig_buffer2 == 0) ? 1 : 0;
assign neg_pulse = (sig_buffer1 == 0 && sig_buffer2 == 1) ? 1 : 0;
/*
parameter	F_1S = 199_999_999; //200M
//fgate
reg		fgate;
reg		[31:0]		fgate_cnt;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate_cnt <= 0;
	else if(fgate_cnt >= F_1S)
		fgate_cnt <= 0;
	else
		fgate_cnt <= fgate_cnt + 1;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate <= 0;
	else if(fgate_cnt >= F_1S)
		fgate <= ~fgate;
	else
		fgate <= fgate;
end

//fact	gate
reg		start_cnt;
always @(posedge sig_in)
begin
	if(fgate)
		start_cnt <= 1;
	else
		start_cnt <= 0;
end
//fx++
reg		[31:0]		high_cnt_temp;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		high_cnt_temp <= 0;
	else if(start_cnt)
	begin
		if(sig_buffer1)
			high_cnt_temp <= high_cnt_temp + 1;
		else
			high_cnt_temp <= high_cnt_temp;
	end
	else
		high_cnt_temp <= 0;
end

reg		[31:0]		low_cnt_temp;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		low_cnt_temp <= 0;
	else if(start_cnt)
	begin
		if(sig_buffer1)
			low_cnt_temp <= low_cnt_temp ;
		else
			low_cnt_temp <= low_cnt_temp + 1;
	end
	else
		low_cnt_temp <= 0;
end
//锁存
always @(negedge start_cnt)
begin
	duty_high <= high_cnt_temp;
	duty_low <=  low_cnt_temp;
end */
 //high
reg		[2:0]	state1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state1 <= 0;
	else
	case(state1)
	
	3'd0 : 
	begin
		if(pos_pulse)
			state1 <= 1'b1;
		else
			state1 <= 0;
	end
	
	3'd1 :
	begin
		if(neg_pulse)
			state1 <= 2;
		else
			state1 <= state1;
	end
	
	3'd2 :
	begin
		state1 <= 0;
	end
	
	default : state1 <= 0;
	endcase
end


reg		[31:0]		cnt_high_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
	//	cnt_high      <= 0;
		cnt_high_temp <= 0;
	end
	else
	case(state1)
	3'd0 :
	begin
		cnt_high_temp <= 0;
	end
	
	3'd1 :
	begin
		cnt_high_temp <= cnt_high_temp + 1;
	end
	
	3'd2 :
	begin
		cnt_high_temp <= cnt_high_temp;
	end
	
	default : ;
	endcase
end



//half pulse
reg		[2:0]	state2;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state2 <= 0;
	else
	case(state2)	
	3'd0 : 
	begin
		if(neg_pulse)
			state2 <= 1'b1;
		else
			state2 <= 0;
	end
	
	3'd1 :
	begin
		if(pos_pulse)
			state2 <= 2;
		else
			state2 <= state2;
	end
	
	3'd2 :
	begin
		state2 <= 0;
	end
	
	default : state2 <= 0;
	endcase
end


//ce duty  half
reg		[31:0]		cnt_low_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
//		cnt_low      <= 0;
		cnt_low_temp <= 0;
	end
	else
	case(state2)
	3'd0 :
	begin
		cnt_low_temp <= 0;
	end
	
	3'd1 :
	begin
		cnt_low_temp <= cnt_low_temp + 1;
	end
	
	3'd2 :
	begin
		cnt_low_temp <= cnt_low_temp;
	end
	
	default : ;
	endcase
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		duty_high <= 0;
	else if(state1 == 2)
		duty_high <= cnt_high_temp;
	else
		duty_high <= duty_high;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		duty_low <= 0;
	else if(state2 == 2)
		duty_low <= cnt_low_temp;
	else
		duty_low <= duty_low;
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		duty_cycle <= 0;
	else if(state2 == 1)
		duty_cycle <= (duty_high + 4)*1000/(duty_high + duty_low + 4);
end


endmodule