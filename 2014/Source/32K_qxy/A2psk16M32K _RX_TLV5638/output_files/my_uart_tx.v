module my_uart_tx(clk_1M,rst,ad_up,Atx_data,Btx_data,rs232_tx);
input clk_1M;
input rst;
input ad_up;
input[7:0] Atx_data;
input[7:0] Btx_data;

output rs232_tx;

reg [4:0] num; 
reg rs232_tx_r;
reg [1:0]state;
always @(posedge clk_1M or negedge rst)
begin 
	if(!rst)
		begin
				num<=5'd0;
				rs232_tx_r<=1'b1;
				state<=1'b0;
			end
	else 
		begin
			case(state)
				1'b0:
					begin
					   num<=1'b0;
						if(ad_up)
							state<=1'b1;
						else 
							state<=1'b0;
					end 
				1'b1:
					begin 
						num<=num+1'b1;
						case(num)
							5'd0: 	rs232_tx_r<=1'b0;
							5'd1: 	rs232_tx_r<=1'b0;
							5'd2: 	rs232_tx_r<=Atx_data[1];
							5'd3: 	rs232_tx_r<=Atx_data[2];
							5'd4: 	rs232_tx_r<=Atx_data[3];
							5'd5: 	rs232_tx_r<=Atx_data[4];
							5'd6: 	rs232_tx_r<=Atx_data[5];
							5'd7: 	rs232_tx_r<=Atx_data[6];
							5'd8: 	rs232_tx_r<=Atx_data[7];
							
							5'd9: 	rs232_tx_r<=1'b0;
							5'd10: 	rs232_tx_r<=Btx_data[1];
							5'd11: 	rs232_tx_r<=Btx_data[2];
							5'd12: 	rs232_tx_r<=Btx_data[3];
							5'd13: 	rs232_tx_r<=Btx_data[4];
							5'd14: 	rs232_tx_r<=Btx_data[5];
							5'd15: 	rs232_tx_r<=Btx_data[6];
							5'd16: 	rs232_tx_r<=Btx_data[7];
							
							5'd17: 	rs232_tx_r<=1'b1;
							5'd18:	begin 
											rs232_tx_r<=1'b1; 
											state<=1'b0;
										end 
							default : 
									   begin 
											rs232_tx_r<=1'b1; 
											state<=1'b0;
										end 
						endcase
					end	
			endcase 		
		end 		
end

assign rs232_tx=rs232_tx_r;
endmodule 

