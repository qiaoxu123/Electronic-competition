module	duty(
		//system	interface
		input				clk,
		input				rst_n,
		//sig		interface
		input				sig_in,
		//pinlv		interface
		input		[31:0]	pinlv,
		//user		interface
		output	reg	[15:0]	duty,
		output	reg	[31:0]	cnt_high,
		output	reg	[31:0]	cnt_low,
		output				high_pulse,
		output				low_pulse,
		output		[31:0]	duty_alter
);

//buffer
reg		sig_in_buffer;
reg		sig_in_buffer1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sig_in_buffer  <= 0;
		sig_in_buffer1 <= 0;
	end
	else
	begin
		sig_in_buffer  <= sig_in;
		sig_in_buffer1 <= sig_in_buffer;
	end
end
assign		high_pulse =  (sig_in_buffer == 1 && sig_in_buffer1 == 0) ? 1 : 0;
assign		low_pulse  =  (sig_in_buffer == 0 && sig_in_buffer1 == 1) ? 1 : 0;
//parameter		CNT_1S = 32'd199_9;
parameter		CNT_1S = 32'd199_999_999;
reg		[31:0]	cnt_1s;
reg				fgate;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_1s <= 0;
	else if(cnt_1s >= CNT_1S)
		cnt_1s <= 0;
	else 
		cnt_1s <= cnt_1s + 1;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate <= 0;
	else if(cnt_1s == CNT_1S)
		fgate <= ~fgate;
	else
		fgate <= fgate;
end


reg		fstart;
always @(posedge sig_in_buffer1 or negedge rst_n)
begin
	if(!rst_n)
		fstart <= 0;
	else if(fgate)
		fstart <= 1;
	else
		fstart <= 0;
end
reg		[2:0]		state_high;
reg		[2:0]		state_low;
//cnt
reg		[31:0]		cnt_high_temp;
reg		[31:0]		cnt_low_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_high <= 0;
	else
	case(state_high)
	2'd0 :
	begin
		if(high_pulse)
			state_high <= 2'd1;
		else
			state_high <= 2'd0;
	end
	
	2'd1 :
	begin
		if(low_pulse)
			state_high <= 2'd0;
		else
			state_high <= 2'd1;
	end
	
	default : ;
	endcase
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_low <= 0;
	else
	case(state_low)
	2'd0 :
	begin
		if(low_pulse)
			state_low <= 2'd1;
		else
			state_low <= 2'd0;
	end
	
	2'd1 :
	begin
		if(high_pulse)
			state_low <= 2'd0;
		else
			state_low <= 2'd1;
	end

	default : ;
	endcase
end
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_high_temp <= 0;
	else if(fstart)
	begin
		if(state_high == 1)
			cnt_high_temp <= cnt_high_temp + 1;
		else
			cnt_high_temp <= cnt_high_temp;
	end
	else
		cnt_high_temp <= 0;	
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_low_temp <= 0;
	else if(fstart)
	begin
		if(state_low == 1)
			cnt_low_temp <= cnt_low_temp + 1;
		else
			cnt_low_temp <= cnt_low_temp;
	end
	else
		cnt_low_temp <= 0;	
end
wire	[31:0]	pinlv1;
assign	pinlv1     = pinlv << 1;
assign	duty_alter =  pinlv << 1;

always @(negedge fstart or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_high <= 0;
		cnt_low <= 0;
	end
	else
	begin
		cnt_high <= cnt_high_temp + duty_alter ;
		cnt_low  <= cnt_low_temp  - duty_alter ; 
	end
end






endmodule