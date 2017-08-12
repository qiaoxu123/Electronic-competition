/*module da_data(clk_16M,
done,clk_da,
in_data,
Aout_data,Bout_data
);


input clk_16M,done;
input [15:0]in_data;

output[7:0]Aout_data;
output[7:0]Bout_data;
output clk_da;

//reg clk_da;
//reg clk_r;
reg [7:0]Aout_data;
reg [7:0]Bout_data;
always@(negedge clk_16M)
begin
	if(done)
		begin
			Aout_data<=in_data[7:0];
			Bout_data<=in_data[15:8];
		end 
	//clk_r<=done;
	//clk_da <= clk_r;
end 

wire clk_da = clk_16M;

//wire[7:0] Aout_data=in_data[7:0];
//wire[7:0] Bout_data=in_data[15:8];
endmodule
*/
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

wire[7:0] Aout_data= A;//in_data[7:0];
wire[7:0] Bout_data= B;//in_data[15:8];

endmodule 