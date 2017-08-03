module	duty_cycle(
		//system	interface
		input				clk,
		input				rst_n,
		//sig		interface
		input				sig_in,
		//user		interface
		output	reg	[15:0]	duty_cycle,
		output				pos_pulse,
		output				neg_pulse
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

assign	pos_pulse = (sig_buffer1 == 1 && sig_buffer2 == 0) ? 1'b1 : 1'b0;
assign	neg_pulse = (sig_buffer1 == 0 && sig_buffer2 == 1) ? 1'b1 : 1'b0;

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

//ce duty all
reg		[31:0]		cnt_high_temp;
reg		[31:0]		cnt_high;

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
reg		[31:0]		cnt_low;

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

//累加 low
reg		[7:0]		cnt_low_100;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_low_100 <= 0;
		cnt_low <= 0;
	end
	else
	begin
		if(cnt_low_100 < 100)
		begin
			if(state2 == 2)
			begin
				cnt_low <= cnt_low + cnt_low_temp;
				cnt_low_100 <= cnt_low_100 + 1;
			end
			else
			begin
				cnt_low <= cnt_low;
				cnt_low_100 <= cnt_low_100;
			end
		end
		else
		begin
			cnt_low_100 <= 0;
			cnt_low <= 0;
		end
			
	end
end
reg		[31:0]		cnt_low_all;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_low_all <= 0;
	else if(cnt_low_100 == 100)
		cnt_low_all <= cnt_low;
	else
		cnt_low_all <= cnt_low_all;		
end


//累加   high
reg		[7:0]		cnt_high_100;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_high_100 <= 0;
		cnt_high <= 0;
	end
	else
	begin
		if(cnt_high_100 < 100)
		begin
			if(state1 == 2)
			begin
				cnt_high <= cnt_high + cnt_high_temp;
				cnt_high_100 <= cnt_high_100 + 1;
			end
			else
			begin
				cnt_high <= cnt_high;
				cnt_high_100 <= cnt_high_100;
			end
		end
		else
		begin
			cnt_high_100 <= 0;
			cnt_high <= 0;
		end
			
	end
end
reg		[31:0]		cnt_high_all;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_high_all <= 0;
	else if(cnt_high_100 == 100)
		cnt_high_all <= cnt_high;
	else
		cnt_high_all <= cnt_high_all;		
end



always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		duty_cycle <= 0;
	else if(state1 == 0)
		duty_cycle <= cnt_high_all*1000/(cnt_high_all + cnt_low_all);
	else
		duty_cycle <= duty_cycle;
end




endmodule