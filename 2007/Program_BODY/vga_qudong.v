module	vga_qudong(
		clk,rst_n,
		vga_clk,vga_b,
		vga_g,vga_r,
		vga_blank,vga_sync,
		vga_hs,vga_vs,
		value_x,value_y,
		rgb
);
input					clk;
input					rst_n;
input			[23:0]	rgb;
output					vga_clk;
output	wire	[7:0]	vga_b;
output	wire	[7:0]	vga_g;
output	wire	[7:0]	vga_r;
output	wire			vga_blank;
output	wire			vga_sync;
output	wire			vga_hs;
output	wire			vga_vs;
output	reg		[10:0]	value_x;
output	reg		[10:0]	value_y;

parameter		X_ALL = 11'd1056;
parameter		XA = 11'd80,XB = 11'd160,XC = 11'd800,XD = 11'd16;
parameter		Y_ALL = 11'd625;
parameter		YO = 11'd3,YP = 11'd21,YQ = 11'd600,YR = 11'd1;

reg		[10:0]			x_cnt;
always @(posedge clk or negedge rst_n)
	if(!rst_n)
		x_cnt <= 'd0;
	else if(x_cnt == X_ALL)
		x_cnt <= 'd0;
	else 
		x_cnt <= x_cnt + 1'd1;
		
reg		[9:0]			y_cnt;
always	@(posedge clk or negedge rst_n)
	if(!rst_n)
		y_cnt <= 'd0;
	else if(y_cnt == Y_ALL)
		y_cnt <= 'd0;
	else if(x_cnt == X_ALL)
		y_cnt <= y_cnt + 1'b1;
		

reg						isvalue;
always @(posedge clk or negedge rst_n)
	if(!rst_n)
		isvalue <= 'd0;
	else if((x_cnt > XA + XB && x_cnt < XA + XB + XC)&&(y_cnt > YO + YP && y_cnt < YO + YP + YQ))
		isvalue <= 1'd1;
	else
		isvalue <= 1'd0;
		
always @(posedge clk or negedge rst_n)
	if(!rst_n)
		value_x <= 'd0;
	else if(isvalue)
		value_x <= x_cnt - XA - XB;
	else
		value_x <= 'd0;

always @(posedge clk or negedge rst_n)
	if(!rst_n)
		value_y <= 'd0;
	else if(isvalue)
		value_y <= y_cnt - YO - YP;
	else
		value_y <= 'd0;		

wire 	xs,ys;   
assign xs =(x_cnt <= XA)? 1'b0 : 1'b1;
assign ys =(y_cnt <= YO)? 1'b0 : 1'b1;	
		
assign  vga_blank	=	xs;
assign  vga_sync	=	ys;
assign  vga_clk		=	clk;
assign  vga_vs		=	ys;
assign  vga_hs		=	xs;	

assign	vga_r = isvalue ? rgb[23:16]: 8'd0;
assign	vga_g = isvalue ? rgb[15:8] : 8'd0;
assign	vga_b = isvalue ? rgb[7:0]  : 8'd0;

endmodule
		
		
		
		
		
















 





