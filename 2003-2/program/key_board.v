/*-----------------------------------------------------------------------

Date				:		2017-07-27
Description			:		Design for key_board.

TCL
set_location_assignment PIN_AD20 -to row[3]
set_location_assignment PIN_AK21 -to row[2]
set_location_assignment PIN_AJ20 -to row[1]
set_location_assignment PIN_AC20 -to row[0]
set_location_assignment PIN_AA19 -to col[3]
set_location_assignment PIN_AG17 -to col[2]
set_location_assignment PIN_AE16 -to col[1]
set_location_assignment PIN_AH17 -to col[0] 

-----------------------------------------------------------------------*/

module key_board
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//key_board	interface
	
	input			[3:0]	row,
	output	reg		[3:0]	col,
	
	//user		interface
	
	output					key_value,
	output	reg		[7:0]	row_col
	
); 


//--------------------------------
//Funtion :  1K  延时
reg                      clk_1k;
reg            [20:0]    cnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        clk_1k <= 1'd1;
        cnt    <= 21'd0;
    end
    else if(cnt < 21'd24999)
        cnt <= cnt + 21'b1;
    else begin
        cnt <= 21'd0;
        clk_1k <= ~clk_1k;
    end
end


//--------------------------------
//Funtion :  状态机
reg            [4:0]    cnt_time;
reg            [2:0]    state;
reg                    flag;//输出值有效标志
always @(posedge clk_1k or negedge rst_n)
    if(!rst_n)begin
        flag <= 1'd0;
        state <= 3'd0;
        cnt_time <= 5'd0;
        row_col <= 8'd0;
        col <= 4'd0;
    end 
    else begin
        case(state)
		3'd0: begin
            if(row != 4'b1111)begin
                if(cnt_time < 5'd19) //延时20ms
                    cnt_time <= cnt_time + 5'd1;
                else begin
                    cnt_time <= 5'd0;
                    state <= state + 1'b1;
                    col <= 4'b1110;   //扫描第一列
                end
            end
            else     cnt_time <= 5'd0;
        end
		3'd1: begin
                if(row != 4'b1111)begin
                    row_col <= {row,col};//储存键值
                    flag <= 1'd1;
                    state <= state + 3'd1;
                    col <= 4'b0000;
                end
                else    col <= {col[2:0],col[3]};
        end
		3'd2: begin
                if(row == 4'b1111)begin
                    if(cnt_time < 5'd19)begin
                        cnt_time <= cnt_time + 5'd1;
                        flag <= 1'd0;
                    end
                    else begin
                        cnt_time <= 5'd0;
                        state <= 3'd0;
                        col <= 4'b0000;
                    end
                end
                else begin
                    cnt_time <= 5'd0;
                    flag <= 1'd0;
                end
        end
        default : state <= 3'd0;        
        endcase
    end
	
//--------------------------------
//Funtion :  边沿检测
reg                    next_flag;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        next_flag <= 1'd0;
    else 
        next_flag <= flag;
end

assign	key_value = (next_flag == 1'b1 && flag == 1'b0) ? 1'b1 : 1'b0;

endmodule