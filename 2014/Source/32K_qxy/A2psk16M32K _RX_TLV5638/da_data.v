module da_data(clk_16M,
done,clk_da,
in_data,
Aout_data,Bout_data
);


input clk_16M,done;
input [15:0]in_data;

output[7:0]Aout_data;
output[7:0]Bout_data;
output clk_da;

reg clk_da;
reg clk_r;
reg [7:0] A,B;
always@(posedge clk_16M)
begin
	clk_r<=done;
	clk_da <= clk_r;
	if(done)
	begin
		A <= in_data[7:0];
		B <= in_data[15:8];
	end	
end 

wire[7:0] Aout_data= A;
wire[7:0] Bout_data= B;

endmodule 