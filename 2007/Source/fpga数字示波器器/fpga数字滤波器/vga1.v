module vga1(clk,rst_n,hsync_vga,vsync_vga,x_pos,y_pos,valid,y_cnt);
input clk,rst_n;
output vsync_vga;
output hsync_vga;
output valid;
output [10:0] x_pos;
output [10:0] y_pos;
output[10:0] y_cnt;

reg[10:0] x_cnt;
reg[10:0] y_cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) x_cnt<=11'd0;
	else if(x_cnt==11'd1040) x_cnt<=11'd0;
	else x_cnt<=x_cnt+1'd1;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) y_cnt<=11'd0;
	else if(y_cnt==11'd666)y_cnt<=11'd0;	
	else if(x_cnt==11'd1040)y_cnt<=y_cnt+1'd1;
end

reg hsync_r,vsync_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)hsync_r<=1'b1;
	else if(x_cnt==11'd0)hsync_r<=1'b0;
	else if(x_cnt==11'd120)hsync_r<=1'b1;
end	


always @(posedge clk or negedge rst_n)
begin	
	if(!rst_n)vsync_r<=1'b1;
	else if(y_cnt==11'd0)vsync_r=1'b0;
	else if(y_cnt==11'd6)vsync_r<=1'b1;		
end

assign hsync_vga=hsync_r;
assign vsync_vga=vsync_r;

wire[10:0] x_pos=valid ? x_cnt-11'd184 : 1'b0;
wire[10:0] y_pos=valid ? y_cnt-11'd29 : 1'b0;
wire valid=(x_cnt>=11'd184)&&(x_cnt<11'd984)&&(y_cnt>=11'd29)&&(y_cnt<11'd629);

endmodule 