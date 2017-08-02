module ads828(clk,rst_n,data_in,data_out,clk_out);
input clk,rst_n;
input[9:0]data_in;
output[9:0]data_out;
output clk_out;

reg[9:0]data_out_r; 
always@(negedge clk2 or negedge rst_n)
begin
	if(!rst_n)data_out_r<=10'd0;
	else data_out_r<=data_in;
end

wire[9:0]data_out;
assign data_out=data_out_r; 

wire clk_out;
assign clk_out=clk2;

wire clk2;
pll  a1(
		.inclk0(clk),
		.c2(clk2)
		);
endmodule 