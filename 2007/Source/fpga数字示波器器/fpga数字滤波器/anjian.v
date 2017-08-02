module anjian(clk,rst_n,sw,sw_an);
input clk,rst_n;
input[7:0] sw;
output[7:0] sw_an;
	
reg [7:0] key;
always @ (posedge clk or negedge rst_n)
	if (!rst_n) key<=8'b11111111;
	else key<={sw[0],sw[1],sw[2],sw[3],sw[4],sw[5],sw[6],sw[7]};
	
reg [7:0] key_r;
always @ (posedge clk or negedge rst_n)
	if (!rst_n) key_r<=8'b11111111;
	else key_r<=key;
		
wire[7:0] key_an=key_r&(~key);
	
reg[19:0] cnt;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt<=20'd0;
	else if(key_an) cnt<=20'd0;
	else cnt<=cnt+1'b1;
	
reg[7:0] sw1;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) sw1<=8'b11111111;
	else if (cnt==20'hfffff) 
		sw1={sw[7],sw[6],sw[5],sw[4],sw[3],sw[2],sw[1],sw[0]};
	
reg[7:0] sw_r;
always @ (posedge clk or negedge rst_n)
	if(!rst_n) sw_r<=8'b11111111;
	else sw_r<=sw1;
	
wire[7:0] sw_an=sw_r&(~sw1);

endmodule 