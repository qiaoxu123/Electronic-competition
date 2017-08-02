module	cycle(
		//system	interface
		input				clk,
		input				rst_n,
		//sig_in	interface
		input				sig_in,
		input				sig_in1,
		//user		interface
		output	reg	[31:0]	cycle
);

//±ßÑØ¼ì²â
wire				pulse_sig;
wire				pulse_sig1;
//Á½¼¶»º´æ
reg					buffer;
reg					r_buffer;
	
reg					buffer1;
reg					r_buffer1;
//sig_in
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		buffer   <= 0;
		r_buffer <= 0;
	end
	else
	begin
		buffer   <= sig_in;
		r_buffer <= buffer; 
	end
end
//posedge
assign	pulse_sig = (buffer == 1'b0 && r_buffer == 1'b1) ? 1'b1 : 1'b0;
//sig_in1
always @(posedge clk or negedge	rst_n)
begin
	if(!rst_n)
	begin
		buffer1   <= 0;
		r_buffer1 <= 0;
	end
	else
	begin
		buffer1   <= sig_in1;
		r_buffer1 <= buffer1;
	end
end
		
//sig_in1 posedge
assign	pulse_sig1 = (buffer1 == 1'b0 && r_buffer1 == 1'b1) ? 1'b1 : 1'b0;


//cnt
reg		[31:0]		cnt_cycle_temp;
reg		[31:0]		cnt_cycle;
//×´Ì¬±ä»¯
reg		[2:0]		state;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state     <= 0;
	else
	case(state)
	3'd0 :
	begin
		if(pulse_sig == 1)
			state <= 1;
		else  
			state <= 0;
	end
	
	3'd1 : 
	begin
		if(pulse_sig1 == 1)
			state <= 2;
		else
			state <= 1;
	end
	
	3'd2 :
	begin
		state     <= 0;
	end	
	
	default : state <= 0;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_cycle_temp <= 0;
		cnt_cycle      <= 0;
	end
	else
	case(state)
	3'd0 :
	begin
		cnt_cycle_temp <= 0;
	end
	3'd1 :
	begin
		cnt_cycle_temp <= cnt_cycle_temp + 1;
	end
	
	3'd2 :
	begin
		cnt_cycle <= cnt_cycle_temp;
	end
	
	default : ;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cycle <= 0;
	else
		cycle <= 5*cnt_cycle;
end

endmodule