module	vga_control(
		clk,rst_n,
		value_x,value_y,
		rgb,vga_data
);
input				clk;
input				rst_n;
input		[10:0]	value_x;
input		[10:0]	value_y;
output	reg	[23:0]	rgb;
input		[7:0]	vga_data;


	
/**********display*************/
reg					is_ready;
always @(posedge clk or negedge rst_n)
	if(!rst_n)begin
		is_ready <= 'd0;
	end
	else if((value_x >= 0 && value_x < 200)&&(value_y >= 0 && value_y < 256))begin
		is_ready <= 1'd1;
	end
	else	
		is_ready <= 'd0;
always @(posedge clk or negedge rst_n)
	if(!rst_n)
		rgb <= 'd0;
	else if(is_ready && value_y == (255 - vga_data))
		rgb <= 24'hFF0000;
	else 
		rgb <= 24'hBBFFFF;
		
endmodule

	