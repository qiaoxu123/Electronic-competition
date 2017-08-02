module	pinlv(
		//system	interface
		input					clk,
		input					rst_n,
		//sig		interface
		input					sig_in,
		//user		interface
		output	reg	[31:0]		pinlv

);

parameter	F_1S = 199_999_999; //200M
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
		if(fgate_cnt >= F_1S>>4)
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
		if(fgate_cnt >= F_1S>>4)
			fgate <= 1;
		else
			fgate <= fgate;
	end
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
//Ëø´æ
always @(negedge start_cnt)
begin
	pinlv <= fx_cnt_temp;
end



endmodule