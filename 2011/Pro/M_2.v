/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for 伪随机信号.

-----------------------------------------------------------------------*/

module M_2
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//V3 interface
	output			reg		signal_v3  
); 


//--------------------------------
//Funtion :   cnt
reg			[31:0]		cnt_signal_v3;              
//parameter				CNT_SIGNAL_V3_NUM = 20;  10M
parameter				CNT_SIGNAL_V3_NUM = 200;  //10M
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_signal_v3 <= 0;
	else if(cnt_signal_v3 >= CNT_SIGNAL_V3_NUM - 1)
		cnt_signal_v3 <= 0;
	else
		cnt_signal_v3 <= cnt_signal_v3 + 1;
end

//--------------------------------
//Funtion :   signal_v3_en
wire			signal_v3_en;

assign			signal_v3_en = (cnt_signal_v3 == 1) ? 1 : 0;

//--------------------------------
//Funtion :   signal_v3


reg		[12:0]	shift;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		shift <= 13'b1_0000_0000_0000;
		signal_v3 <= 0;
	end
	else if(signal_v3_en)
	begin
		shift     <= shift >> 1;
		shift[12] <= (shift[0] ^ shift[7] ^ shift[8] ^ shift[11] ^ shift[12]);
		signal_v3 <= shift[0];
	end
	else
	begin
		shift <= shift;
		signal_v3   <= signal_v3;
	end
end

endmodule
	
