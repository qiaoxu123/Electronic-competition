module clk_1M(clk,rst,clk_1M);
input clk,rst;
output clk_1M;

reg[31:0]cnt;
reg clk_1M;
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt<=1'b0;
		end
	else if(cnt>=7)
		begin
			clk_1M<=~clk_1M;
			cnt<=1'b0;
		end 
	else  	
		begin
			cnt<=cnt+1'b1;
		end 
end 


endmodule 
