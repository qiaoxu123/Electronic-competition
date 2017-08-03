module ad_ctrl(
			//system
		input							clk			, //系统时钟
		input							rst_n			, //复位
			//da signal	 
		output						ad_clk		, //ad采样时钟					
		input		  	 [9:0]		data_in		, //数据输入
			//fifo signal 
		input							rempty		, //fifo读空标志
		input							wfull			, //fifo写满标志
		output	wire				wren			, //fifo写使能
		output	wire				rden			, //fifo读使能
		output	reg [11:0]		data_out		, //数据输出		
			//fft signal
		input		wire		 		sink_ready	, //fft准备好接受数据标志			
		output	wire		 		sink_sop		, //fft一帧数据尅是标志
		output	wire		 		sink_eop		, //fft一帧数据结束标志
		output	reg		 		valid			 //fft数据有效标志

);

reg				write_en;
reg				read_en;
reg	[11:0] 	cnt;
reg 	[1:0]		state, next_state;

assign  ad_clk= ~clk;


assign	sink_sop = (cnt == 11'd1) ? 1'b1 : 1'b0; 		
assign	sink_eop = (cnt == 12'd2046) ? 1'b1 : 1'b0; 		

//data_out
always @(negedge  clk)
begin 
 data_out<={1'b0,data_in,1'b0};
end 



//cnt
always @(posedge clk or negedge rst_n)
begin 
	if (!rst_n)
		cnt <= 1'b0;
	else if(read_en)
		cnt <= cnt + 1'b1;	
	else
		cnt <= 1'b0;
end 

//fifo  状态机
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		next_state = 2'b00;
	else 
		next_state <= state;
end 

always @(posedge clk or negedge rst_n)
if (!rst_n)
	begin
		state		 <= 2'b00;
		read_en	 <= 1'b0;
		write_en  <= 1'b1;
	end	
else
	case (next_state)
	2'b00:if  ( wfull && sink_ready )
					begin
					read_en <= 1'b1;				
					write_en <= 1'b0;
					state <= 2'b01;
					valid <= 1'b1;
					end
			else 	begin
					read_en <= 1'b0;
					write_en <= 1'b1;				
					state <= 2'b00;
					valid <= 1'b0;
					end
	2'b01:if	 (rempty)
					begin
					read_en <= 1'b0;
					write_en <= 1'b1;
					state <= 2'b10;
					end
			else 	begin	
					read_en <= 1'b1;
					write_en <= 1'b0;
					state <= 2'b01;
					end

	2'b10:if (!wfull) 
					begin 
					valid <= 1'b0; 
					state <= 2'b00;
					end 
			else	
				state <= 2'b10;
	endcase
	
assign  rden = read_en;
assign  wren = write_en;

endmodule 