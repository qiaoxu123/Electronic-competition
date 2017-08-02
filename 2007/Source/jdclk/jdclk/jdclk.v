module jdclk(rst,c0,cyclk,jdclk,locked);
input c0,cyclk,rst;
input locked;
output jdclk;
reg jdclk;
initial jdclk=0;
reg[7:0]m,i;
reg n;
initial i=0;
initial n=1;
initial m=0;
always@(posedge c0)
begin
if(!locked)
i=1'b0;
else if(i==m)
begin
i=0;
jdclk=1;
end
if(n==1)
begin
i=i+8'b1;
end
end
always@( posedge cyclk )
begin
if(!rst)
begin
m=0;
end
begin
n<=1'b0;
m<=m+8'b1;
end
end
always@(n)
n=~n;
endmodule

