module qudou
(
    input clk_16M,
	 input dat_i,
	 output reg dat_o
);

reg [1:0] h_cnt,l_cnt;
always @(posedge clk_16M)
begin
	if(dat_i)
	begin
		if(h_cnt == 2'd2)
		begin
			h_cnt <= 1'b0;
			l_cnt <= 1'b0;
			dat_o <= 1'b1;
		end
		else begin
			h_cnt <= h_cnt + 1'b1;
		end 
	end
	else begin
		if(l_cnt == 2'd2)
		begin
			l_cnt <= 1'b0;
			h_cnt <= 1'b0;
			dat_o <= 1'b0;
		end
		else begin
			l_cnt <= l_cnt + 1'b1;
		end
		
	end
end

endmodule
