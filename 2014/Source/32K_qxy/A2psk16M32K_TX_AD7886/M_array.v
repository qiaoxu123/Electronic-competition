module M_array
(clk,rst,
m_out
); 

input clk,rst;
output m_out;

reg[1:0]state;
reg[3:0]m_data_r;


reg[31:0]cnt1;
reg clk_1K;
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt1<=1'b0;
		end
	else if(cnt1>=24999)
		begin
			clk_1K<=~clk_1K;
			cnt1<=1'b0;
		end 
	else  	
		begin
			cnt1<=cnt1+1'b1;
		end 
end 
wire clk_mar=clk_1K;

reg[31:0]cnt2;
reg clk_4K;//
always@(posedge clk or negedge rst)
begin
	if(!rst)
		begin
			cnt2<=1'b0;
		end
	else if(cnt2>=6249)
		begin
			clk_4K<=~clk_4K;
			cnt2<=1'b0;
		end 
	else  	
		begin
			cnt2<=cnt2+1'b1;
		end 
end 

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

wire[3:0] m_data=m_data_r;
//assign m_out=m_data[0];
reg[1:0]i;
reg m_out;
reg[3:0]m_data1,m_data2;
always@(posedge clk_4K or negedge rst)
begin
	if(!rst)
		begin
			m_out<=1'b0;
			i<=1'b0;
		end
	else 
		begin
			m_data1<=m_data;
			if(m_data1!=m_data)
				begin
					i<=1'b0;
					m_out<=m_data1[i];
				end
			else 
				begin
					i<=i+1'b1;
					m_out<=m_data1[i];
				end
		end
end

endmodule 
