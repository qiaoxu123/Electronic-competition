module		hex(
			//system		interface
			input				clk,
			input				rst_n,
			//hex			interface
			output	reg	[31:0]	hex_data	
);
//cnt	for		1S
reg		[31:0]		cnt_s;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_s <= 32'd0;
	else if(cnt_s == 50_000_000 - 1)
		cnt_s <= 32'd0;
	else
		cnt_s <= cnt_s + 1'b1;
end

//hex	data
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		hex_data <= 0;
	else if(hex_data == 256)
		hex_data <= 0;
	else if(cnt_s == 1)
		hex_data <= hex_data + 1'b1;
	else
		hex_data <= hex_data;
end




endmodule

