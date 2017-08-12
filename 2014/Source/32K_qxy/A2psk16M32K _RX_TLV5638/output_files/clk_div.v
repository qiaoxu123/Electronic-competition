module clk_div(clk,rst,clk_AD,clk_mar);
input clk,rst;
output clk_AD;
output clk_mar;

reg[31:0]cnt;
reg clk_32K;
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt<=1'b0;
		end
	else if(cnt>=1563)
		begin
			clk_32K<=~clk_32K;
			cnt<=1'b0;
		end 
	else  	
		begin
			cnt<=cnt+1'b1;
		end 
end 
wire clk_AD=clk_32K;


reg[31:0]cnt1;
reg clk_1K;
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt1<=1'b0;
		end
	else if(cnt1>=24999)
		begin
			clk_1K<=~clk_1K;
			cnt1<=1'b0;
		end 
	else  	
		begin
			cnt1<=cnt1+1'b1;
		end 
end 

wire clk_mar=clk_1K;
endmodule 
