/*-----------------------------------------------------------------------

Date				:		2017-07-04
Description			:		Design for 等精度测频.

-----------------------------------------------------------------------*/

module phase
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//pinlv interface
	input					sig_in,			//a
	input					sig_in1,		//b

	//user interface
	output			[31:0]	phase,
	output	reg		[31:0]	pinlv
	
); 

reg		start_cnt;


//--------------------------------
//Funtion : 对实际闸门的下降沿进行检测
reg			sig_in_buffer;
reg			sig_in_buffer1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_buffer <= 0;
	else
		sig_in_buffer <= start_cnt;
end
wire		start_cnt_neg;
assign		start_cnt_neg = (sig_in_buffer1 == 0 && sig_in_buffer == 1) ? 1 : 0;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_buffer1 <= 0;
	else
		sig_in_buffer1 <= sig_in_buffer;
end


//--------------------------------
//Funtion : 预制闸门占空比可调
parameter	F_1S = 49_999_999; //200M
//fgate
reg		fgate;
reg		[31:0]		fgate_cnt;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate_cnt <= 0;
	else if(fgate)
	begin
		if(fgate_cnt >= F_1S)
			fgate_cnt <= 0;
		else
		fgate_cnt <= fgate_cnt + 1;
	end
	else if(!fgate)
	begin
		if(fgate_cnt >= F_1S || start_cnt_neg)
			fgate_cnt <= 0;
		else
			fgate_cnt <= fgate_cnt + 1;
	end
	else
		fgate_cnt <= fgate_cnt;
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fgate <= 0;
	else if(fgate)
	begin
		if(fgate_cnt >= F_1S)
			fgate <= 0;
		else
			fgate <= fgate;
	end
	else if(!fgate)
	begin
		if(fgate_cnt >= F_1S || start_cnt_neg)
			fgate <= 1;
		else
			fgate <= fgate;
	end
	else
		fgate <= fgate;
end

//--------------------------------
//Funtion : 实际闸门

always @(posedge sig_in)
begin
	if(fgate)
		start_cnt <= 1;
	else
		start_cnt <= 0;
end

//--------------------------------
//Funtion : 被测信号Fc的个数
reg		[31:0]		fx_cnt_temp;
always @(posedge sig_in or negedge rst_n)
begin
	if(!rst_n)
		fx_cnt_temp <= 0;
	else if(start_cnt)
		fx_cnt_temp <= fx_cnt_temp + 1;
	else
		fx_cnt_temp <= 0;
end



//--------------------------------
//Funtion : 被测信号的频率
always @(negedge start_cnt)
begin
	pinlv <= fx_cnt_temp;
end


//--------------------------------
//Funtion : 打两拍
reg					sig0_in_buffer;
reg					sig0_in_buffer1;
wire				sig_in_pos;
always	@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sig0_in_buffer <= 0;
		sig0_in_buffer1 <= 0;
	end
	else
	begin
		sig0_in_buffer <= sig_in;
		sig0_in_buffer1 <= sig0_in_buffer;
	end
end

assign	sig_in_pos = (sig0_in_buffer1 == 0 && sig0_in_buffer == 1) ? 1 : 0;


reg					sig_in1_buffer;
reg					sig_in1_buffer1;
wire				sig_in1_pos;
always	@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sig_in1_buffer <= 0;
		sig_in1_buffer1 <= 0;
	end
	else
	begin
		sig_in1_buffer <= sig_in1;
		sig_in1_buffer1 <= sig_in1_buffer;
	end
end

assign	sig_in1_pos = (sig_in1_buffer1 == 0 && sig_in1_buffer == 1) ? 1 : 0;

//--------------------------------
//Funtion : phase all
//cnt
reg		[31:0]		cnt_cycle_temp;
reg		[31:0]		cnt_cycle;
//状态变化
reg		[2:0]		state;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state     <= 0;
	else
	case(state)
	3'd0 :
	begin
		if(sig_in1_pos == 1)
			state <= 1;
		else  
			state <= 0;
	end
	
	3'd1 : 
	begin
		if(sig_in_pos == 1)
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

reg		[2:0]		state1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state1     <= 0;
	else
	case(state1)
	3'd0 :
	begin
		if(sig_in1_pos == 1)
			state1 <= 1;
		else  
			state1 <= 0;
	end
	
	3'd1 : 
	begin
		if(sig_in1_pos == 1)
			state1 <= 2;
		else
			state1 <= 1;
	end
	
	3'd2 :
	begin
		state1     <= 0;
	end	
	
	default : state1 <= 0;
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


reg		[31:0]		cnt_al_temp;
reg		[31:0]		cnt_al;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_al_temp <= 0;
		cnt_al      <= 0;
	end
	else
	case(state1)
	3'd0 :
	begin
		cnt_al_temp <= 0;
	end
	3'd1 :
	begin
		cnt_al_temp <= cnt_al_temp + 1;
	end
	
	3'd2 :
	begin
		cnt_al <= cnt_al_temp;
	end
	
	default : ;
	endcase
end


//--------------------------------
//Funtion : 低频与高频分开测量  

reg		[31:0]		fenmu;
reg		[31:0]		fenmu_temp;
reg		[7:0]		cnt_fenmu;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		fenmu_temp <= 0;
		cnt_fenmu <= 0;
	end
	else
	if(pinlv <= 100_000)
	begin
		fenmu_temp <= cnt_al;
	end
	else
	begin
		if(state1 == 2)
		begin
			if(cnt_fenmu == 99)
			begin
				fenmu_temp <= 0;
				cnt_fenmu <= 0;
			end
			else
			begin
				fenmu_temp <= fenmu_temp + cnt_al;
				cnt_fenmu <= cnt_fenmu + 1;
			end
		end
	end
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fenmu <= 0;
	else if(pinlv <= 100_000)
		fenmu <= fenmu_temp;
	else
	begin
		if(cnt_fenmu == 99)
			fenmu <= fenmu_temp;
		else
			fenmu <= fenmu;
	end
end

reg		[31:0]		fenzi;
reg		[31:0]		fenzi_temp;
reg		[7:0]		cnt_fenzi;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		fenzi_temp <= 0;
		cnt_fenzi <= 0;
	end
	else
	if(pinlv <= 100_000)
	begin
		fenzi_temp <= cnt_cycle;
	end
	else
	begin
		if(state == 2)
		begin
			if(cnt_fenzi == 99)
			begin
				fenzi_temp <= 0;
				cnt_fenzi <= 0;
			end
			else
			begin
				fenzi_temp <= fenzi_temp + cnt_cycle;
				cnt_fenzi <= cnt_fenzi + 1;
			end
		end
	end
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		fenzi <= 0;
	else if(pinlv <= 100_000)
		fenzi <= fenzi_temp * 36;
	else
	begin
		if(cnt_fenzi == 99)
			fenzi <= fenzi_temp*36;
		else
			fenzi <= fenzi;
	end
end




//--------------------------------
//Funtion : jisuna


wire	[31:0]		phase_1;
div_32_32	div_32_32_inst (
	.denom ( cnt_al ),
	.numer ( fenzi ),
	.quotient ( phase_1 )
	);
	
	
	
	
	

assign	phase = phase_1 * 10;

endmodule