module FIFO_clk(
						clk,
						rst_n,
						sw,				
						wr_clk
					);
					
input clk,rst_n;//clk 150M
input [1:0] sw;
output reg wr_clk;

parameter n1 = 16'd36621,    //2.048KHz
			 n2 = 12'd3662,     //20.48KHz
			 n3 = 9'd366,      //204.8KHz
			 n4 = 6'd36;		 //2.048MHz
			 
			 

reg [15:0] n;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		n <= n1;
	else
		case(sw)
			2'b00: n <= n1;
			2'b01: n <= n2;
			2'b10: n <= n3;
			2'b11: n <= n4;
		endcase
end 

reg [15:0]count;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin 
		wr_clk <= 1'b0;
		count <= 1'b0; end 
	else if(count == n) begin   
			wr_clk <= ~wr_clk;
			count <= 1'b0;
		end	
    else   
		 count <= count + 1'b1;
end		

endmodule 