/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for sync clk.

-----------------------------------------------------------------------*/

module sync
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	input					clk_phase90,
	
	//manqiesite interface
	input					signal_v1_man,					

	//sync		 interface
	output		reg			sync_clk
	
); 


//--------------------------------
//Funtion :  缓存两拍             
reg			signal_v1_man_buffer;
reg			signal_v1_man_buffer1;
wire		signal_pos;
wire		signal_neg;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		signal_v1_man_buffer <= 0;
		signal_v1_man_buffer1 <= 0;
	end
	else
	begin
		signal_v1_man_buffer  <= signal_v1_man;
		signal_v1_man_buffer1 <= signal_v1_man_buffer;
	end
end

assign		signal_pos = (signal_v1_man_buffer == 1 && signal_v1_man_buffer1 == 0) ? 1 : 0;
assign		signal_neg = (signal_v1_man_buffer == 0 && signal_v1_man_buffer1 == 1) ? 1 : 0;

//--------------------------------
//Funtion :  100ms
reg			[31:0]		cnt_100ms;
wire					cnt_done;
wire					cnt_init;
//parameter				CNT_100MS_NUM = 50_000_00 << 2 ;
parameter				CNT_100MS_NUM = 50_000 <<2;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_100ms <= 0;
	else if(cnt_100ms == CNT_100MS_NUM - 1)
		cnt_100ms <= 0;
	else
		cnt_100ms <= cnt_100ms + 1;
end

assign		cnt_done = (cnt_100ms == CNT_100MS_NUM - 1) ? 1 : 0;
//assign		cnt_init = (cnt_100ms == 100 ) ? 1 : 0; 

//--------------------------------
//Funtion :  最小时间
reg		[1:0]		state_sync_1;
reg		[31:0]		cnt_temp;
reg		[31:0]		cnt_m_r;
reg		[31:0]		cnt_m;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_sync_1 <= 0;
		cnt_temp <= 0;
		cnt_m_r <= 0;
		cnt_m <= 0;
	end
	else
		case(state_sync_1)
			2'd0 :
			begin
				cnt_temp <= 1;
				if(cnt_done)
				begin
					cnt_m <= 100_000>>2;
				end
				else if(signal_pos)
					state_sync_1 <= 1;
				else
					state_sync_1 <= 0;
			end
			
			2'd1 :
			begin
				cnt_temp <= cnt_temp + 1;
				if(signal_neg)
				begin
					cnt_m_r <= cnt_temp;
					cnt_m   <= (cnt_m <= cnt_m_r) ? cnt_m : cnt_m_r;
					state_sync_1   <= 0;
				end
				else
				begin
					state_sync_1 <= 1;
				end
			end
			
			default : state_sync_1 <= 0;
		endcase
end

reg		[31:0]		min_temp;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		min_temp <= 0;
	else if(cnt_done)
		min_temp <= cnt_m;
	else
		min_temp <= min_temp;
end



//--------------------------------
//Funtion :  clk同步
reg			[31:0]		cnt_sync;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_sync <= 0;
	else if(cnt_sync >= min_temp )
		cnt_sync <= 0;
	else
		cnt_sync <= cnt_sync + 1;
end
wire			sync_en;
assign			sync_en = (cnt_sync >= min_temp) ? 1 : 0;

reg		man_buffer;
reg		man_buffer1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		man_buffer <= 0;
		man_buffer1 <= 0;
	end
	else if(sync_en)
	begin
		man_buffer <= signal_v1_man;
		man_buffer1 <= man_buffer;
	end
	else
	begin
		man_buffer <= man_buffer ;
		man_buffer1 <= man_buffer1;	
	end
end

reg		[1:0]		state_sync;
reg					sig_there;
reg		[31:0]		cnt_there;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		state_sync <= 0;
		sig_there <= 0;
		cnt_there <= 0;
	end
	else
		case(state_sync)
			2'd0 :
			begin
				sig_there <= 0;
				if(signal_v1_man && !man_buffer && !man_buffer1)
					state_sync <= 1;
				else
					state_sync <= 0;
			end	
			
			2'd1 :
			begin
				if(cnt_there >= min_temp)
				begin
					state_sync <= 0;
					cnt_there <= 0;
					sig_there <= 1;
				end
				else 
				begin
					cnt_there <= cnt_there + 1;
					state_sync <= 1;
					sig_there <= 0;
				end
			end
			
/* 			2'd2 :
			begin
				if(signal_neg || signal_pos)
				begin
					state_sync <= 0;
					sig_there <= 1;
				end
				else
					state_sync <= 2;
			end */
			default : ;
		endcase
end

wire		[31:0]		cnt_div = (min_temp << 1);
reg			[31:0]		sync_cnt;
// >=  否则会跑飞
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sync_cnt <= 0;
	else if(sync_cnt >= min_temp - 1 ||(sync_clk == 0 &&(signal_neg || signal_pos)))
		sync_cnt <= 0;
	else
		sync_cnt <= sync_cnt + 1;
end




always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sync_clk <= 0;
	// else if(sync_cnt == cnt_div - 1 )
		// sync_clk <= 0;
	else if(sync_cnt >= min_temp -1 )
		sync_clk <= ~sync_clk;
	else
		sync_clk <= sync_clk;
end







endmodule
	
