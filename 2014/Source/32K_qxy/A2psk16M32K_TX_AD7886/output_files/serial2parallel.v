module serial2parallel(
						input clk,
						input rst_n,
						input data_i,
						
						output reg [15:0] data_o,
						output reg done,
						output reg [2:0]state
						);
	parameter FREQ_CLK = 16_000_000;
	parameter FREQ_DATA_I = 1_000_000;
	parameter PERIOD = FREQ_CLK / FREQ_DATA_I;
	parameter NUM_SAMPLE_EN = PERIOD / 2;
	
	//detecte the edge of data_i	
	reg data_i_edge;
	reg data_i_r;
	always @(posedge clk)
	begin
		data_i_r <= data_i;
		data_i_edge <= data_i_r ^ data_i;
	end
	//correct the timer when data_i_edge is high	
	reg [3:0] timer;
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			timer <= 4'd0;
		else begin
			if(data_i_edge )//|| (timer >= PERIOD))		最大记至 16
				timer <= 4'd0;
			else
				timer <= timer + 4'd1;
		end
	//the sample enable pulse 
	reg data_en;
	always @(posedge clk)
		if(timer == NUM_SAMPLE_EN - 4'd3)
			data_en <= 1'b1;
		else 
			data_en <= 1'b0;
	reg [7:0]idle_cnt;
	reg idle_flag;
	always @(posedge clk)
		if(idle_cnt == 8'd160)
		begin
			idle_cnt = 0;
			idle_flag = 1;
		end
		else if(data_i)
		begin
			idle_cnt = idle_cnt + 1'b1;
			idle_flag = 1'b0;
		end
		else begin
			idle_cnt = 1'b0;
			idle_flag = 1'b0;
		end			
	//
 //reg [2:0]state;
	parameter 	IDLE = 3'd1,
					S1 = 3'd2,
					S2 = 3'd4;
					
	reg [3:0]cnt;
	reg [15:0]data;
	always @(posedge clk)// or negedge rst_n)
		if(!rst_n || idle_flag)
		begin
			state <= IDLE;
			cnt <= 4'd0;
			data <= 16'd0;
			//data_o <= 16'd0;
			done <= 1'b0;
		end
		else case(state)
			IDLE	:	begin
							if(data_en && !data_i)
								state <= S1;
							cnt <= 4'd0;
							data <= 16'd0;
							done <= 1'b0;
						end
			S1 	:	begin
							if(data_en)
							begin
								data[15] <= data_i;
								data[14:0] <= data[15:1];
								cnt <= cnt + 4'd1;
								if(cnt == 4'd15)
								begin
									state <= S2;
									cnt <= 4'd0;
								end
							end
						end
			S2		:	begin
//							if(data_en && data_i)
							if(data_en)
							begin
								if(cnt && data_i)
								begin
									data_o <= data;
									done <= 1'b1;
								end
								if(cnt)
								begin
									state <= IDLE;
								end
								cnt <= cnt + 4'd1;
								
								//state <= IDLE;
							end
//							else if(data_en && !data_i)
//							begin
//								state <= IDLE;
//							end
						end
			default :	state <= IDLE;
		endcase
	
endmodule
