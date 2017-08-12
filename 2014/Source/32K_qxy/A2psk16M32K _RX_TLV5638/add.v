module add(	
				input clk,
				input [11:0]a,
				output reg [11:0]result
				);
	always @(posedge clk)
	begin
		result = 12'hfff - a;
	end					
endmodule
