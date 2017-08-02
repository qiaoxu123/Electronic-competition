/*-----------------------------------------------------------------------

Date				:		2017-07-29
Description			:		Design for M序列同步.
							clk = 200M
							pinlv 低效果还行，频率达到1M存在严重的相位抖动
-----------------------------------------------------------------------*/

module M_sync
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//sig_in interface
	input					sig_in,
	
	//sig_out	interface
	output		reg			M_sync_clk
	
); 


//--------------------------------
//Funtion :  检测 pos  neg             
reg					sig_in_r;
reg					sig_in_r1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		sig_in_r  <= 1'b0;
		sig_in_r1 <= 1'b1;
	end
	else
	begin
		sig_in_r  <= sig_in;
		sig_in_r1 <= sig_in_r;
	end
end

//pos
reg		sig_in_pos;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_pos <= 1'b0;
	else if((sig_in_r == 1'b1) && (sig_in_r1 == 1'b0))
		sig_in_pos <= 1'b1;
	else
		sig_in_pos <= 1'b0;
end


//neg

reg		sig_in_neg;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sig_in_neg <= 1'b0;
	else if((sig_in_r == 1'b0) && (sig_in_r1 == 1'b1))
		sig_in_neg <= 1'b1;
	else
		sig_in_neg <= 1'b0;
end
//--------------------------------
//Funtion :  state for high count
reg		[1:0]		state_sync;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		state_sync <= 2'd0;
	else 
		case(state_sync)
		
		//检测上升沿
		2'd0 :
		begin
			if(sig_in_pos)
				state_sync <= 2'd1;
			else
				state_sync <= 2'd0;
		end
			
		//count
		2'd1 :
		begin
			if(sig_in_neg)
				state_sync <= 2'd2;
			else
				state_sync <= 2'd1;
		end
		
		//cunchu
		2'd2 :
		begin
			state_sync <= 2'd0;
		end
		endcase
end     

//--------------------------------
//Funtion :  cnt for high count
//计数

reg			[31:0]		cnt_high;
reg			[31:0]		cnt_high_temp;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cnt_high <= 32'd0;
		cnt_high_temp <= 32'd0;
	end
	else
	case(state_sync)
		2'd0 :
		begin
			cnt_high <= 32'd1;
		end
		
		2'd1 :
		begin
			cnt_high <= cnt_high + 1'b1;
		end
		
		2'd2 :
		begin
			cnt_high_temp <= cnt_high;
		end
	endcase
end

//--------------------------------
//Funtion :  比较

parameter		TEM_MS = 32'd2_000_000;
reg		[31:0]	cnt_com;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_com <= 32'd0;
	else if(cnt_com > TEM_MS - 1'b1)
		cnt_com <= 32'd0;
	else
		cnt_com <= cnt_com + 1'b1; 
end

reg		[31:0]	compar;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		compar <= 32'd0;
	else if(cnt_com == 32'd0)
		compar <= 32'd10_000_000;
	else if(compar > cnt_high_temp)
		compar <= cnt_high_temp;
	else
		compar <= compar;
end

reg		[31:0]		num_sig;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		num_sig <= 32'd0;
	else if(cnt_com == TEM_MS - 2'd3)
		num_sig <= compar;
end

//--------------------------------
//Funtion : 	产生类似曼切斯特编码的clk
//				如过连续出现两个相同的电平 下一个跳变沿就是clk的上升沿

/* reg			[31:0]		cnt_man_clk;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_man_clk <= 32'd10;		//相位差
	else if(cnt_man_clk >= num_sig - 1'b1)
		cnt_man_clk <= 32'd0;
	else
		cnt_man_clk <= cnt_man_clk + 1'b1;
end

wire		man_clk_value;
assign		man_clk_value = (cnt_man_clk >= num_sig - 1'b1) ? 1'b1 : 1'b0; */

/* reg					man_clk_r;
reg					man_clk_r1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		man_clk_r  <= 1'b0;
		man_clk_r1 <= 1'b0;
	end
	else if(man_clk_value)
	begin
		man_clk_r  <= sig_in_r1;
		man_clk_r1 <= man_clk_r; 
	end
end

wire				clk_pos_value;
assign				clk_pos_value = ((man_clk_r == man_clk_r1) && (sig_in_pos || sig_in_neg)) ? 1'b1 : 1'b0;
 *///--------------------------------
//Funtion : 	sync_clk

reg		[31:0]		cnt_sync_clk;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_sync_clk <= 32'd0;
	else if((cnt_sync_clk >= (num_sig - 1'b1)) || sig_in_pos)
		cnt_sync_clk <= 32'd0;
	else
		cnt_sync_clk <= cnt_sync_clk + 1'd1;
end

/* wire	[31:0]		half_num;
assign				half_num   = num_sig >> 1; */


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		M_sync_clk <= 1'd0;
	else if((cnt_sync_clk >= (num_sig - 1'b1)) || sig_in_pos)
		M_sync_clk <= 1'd1;
	else if(cnt_sync_clk == (num_sig >> 1) - 1'b1)
		M_sync_clk <= 1'd0;
	else
		M_sync_clk <= M_sync_clk;
end





endmodule
	
