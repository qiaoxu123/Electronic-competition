/*-----------------------------------------------------------------------

Date				:		2017-07-26
Description			:		Design for 逻辑分析仪.

-----------------------------------------------------------------------*/

module shift_sig
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//shift_sig interface
	output	reg		[7:0]	shift_sig   	//
	
); 


//--------------------------------
//Funtion :  100HZ
//parameter		NUM_100HZ = 32'd499_999;
parameter	NUM_100HZ = 32'd49;
reg			[31:0]		cnt_100hz;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_100hz <= 32'd0;
	else if(cnt_100hz == NUM_100HZ)
		cnt_100hz <= 32'd0;
	else
		cnt_100hz <= cnt_100hz + 1;
end

//--------------------------------
//Funtion :  100HZ  有效
wire		clk_100_value;

assign		clk_100_value = (cnt_100hz == NUM_100HZ) ? 1'b1 : 1'b0;

//--------------------------------
//Funtion :  shift_sig 输出

reg			[2:0]		shift_state;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		shift_state <= 3'd0;
	else if(clk_100_value)
		shift_state <= shift_state + 3'd1;
end		


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		shift_sig <= 8'd0;
	else
	case(shift_state)
	3'd0 : shift_sig <= 8'b00000101;
	3'd1 : shift_sig <= 8'b10000010;	
	3'd2 : shift_sig <= 8'b01000001;
	3'd3 : shift_sig <= 8'b10100000;
	3'd4 : shift_sig <= 8'b01010000;
	3'd5 : shift_sig <= 8'b00101000;
	3'd6 : shift_sig <= 8'b00010100;
	3'd7 : shift_sig <= 8'b00001010;
	default : ;
	endcase
end

endmodule
	
