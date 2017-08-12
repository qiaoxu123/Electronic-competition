module M_array
(clk_mar,rst,
m_data,
m_out
); 

input clk_mar,rst;
output [3:0]m_data;
output m_out;

reg[1:0]state;
reg[3:0]m_data_r;
always@(posedge clk_mar or negedge rst)
begin
	if(!rst)
		begin
			m_data_r<=4'd0;
			state<=2'b00;
		end
	else 
		case(state)
			2'b00:
				begin
					m_data_r<=4'b0001;
					state<=2'b01;
				end
			2'b01:
				begin
					m_data_r<={{m_data_r[3]+m_data_r[0]},m_data_r[3:1]};
					state<=2'b01;
				end
		endcase			
end

assign m_data=m_data_r;
assign m_out=m_data[0];

endmodule 
