/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for 数字信号发生器.

-----------------------------------------------------------------------*/

module M_1
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset

	//sig interface

	output	reg				signal_v1_man,
	output	reg				signal_v1_clk,
	output	reg				signal_v1
	
); 


//--------------------------------
//Funtion : 选择数据率频率
wire		[31:0]			cnt_v_number;


iss1	iss1_inst (
	//.probe ( probe_sig ),
	.source ( cnt_v_number )
	);
/* always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_v_number <= 0;
	else
		cnt_v_number <= 532 <<2;	//90K
end */

//--------------------------------
//Funtion : signal_v1_clk
reg		[31:0]		cnt_v;
wire				signal_v1_clk_en;
wire				signal_v1_en;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_v <= 0;
	else if(cnt_v >= cnt_v_number - 1)
		cnt_v <= 0;
	else
		cnt_v <= cnt_v + 1;
end

assign	signal_v1_clk_en = (cnt_v == cnt_v_number - 1 || cnt_v == (cnt_v_number >> 1) - 1) ? 1 : 0;
assign	signal_v1_en     = (cnt_v == cnt_v_number - 1) ? 1 : 0;
//--------------------------------
//Funtion : M1 clk

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		signal_v1_clk <= 0;
	else if(signal_v1_clk_en)
		signal_v1_clk <= ~signal_v1_clk;
	else
		signal_v1_clk <= signal_v1_clk;
end

//--------------------------------
//Funtion : signal_v1


reg		[8:0]	shift;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		shift <= 9'b1_0000_0000;
		signal_v1 <= 0;
	end
	else if(signal_v1_en)
	begin
		shift     <= shift >> 1;
		shift[8]  <= (shift[0] ^ shift[4] ^ shift[5] ^ shift[6] ^ shift[8]);
		signal_v1 <= shift[0];
	end
	else
	begin
		shift <= shift;
		signal_v1   <= signal_v1;
	end
end

//--------------------------------
//Funtion : signal_v1  曼切斯特编码
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		signal_v1_man <= 0;
	else
		signal_v1_man <= signal_v1 ^ signal_v1_clk;
end

endmodule






	