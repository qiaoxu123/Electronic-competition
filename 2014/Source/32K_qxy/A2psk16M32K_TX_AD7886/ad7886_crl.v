	module ad7886_crl(
		//input
		clk,
		rst_n,
		A_sdi,
		B_sdi,
		//output
		A_sclk,
		B_sclk,
		
		Acs_n,
		Bcs_n,
		
		A_data,
		B_data
);

input 	clk,rst_n;
input	A_sdi;
input	B_sdi;

output	A_sclk,Acs_n;
output	B_sclk,Bcs_n;

output	[11:0] A_data;
output	[11:0] B_data;



//-----------------------------------------------  
// 分频信号  50M / 4  
reg sclk;
reg	[4:0]	cnt;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		begin
		sclk <= 0;
		cnt <= 0;
		end
	else if(cnt == 5'd1)
		begin
		cnt <= 1'd0;
		sclk <= ~sclk;	
		end	
	else	
		cnt <= cnt + 1'b1;
				
end
wire A_sclk=sclk;
wire B_sclk=sclk;

//-----------------------------------------------
reg 	cs_n;
reg	[15:0]Ardout;
reg	[11:0]Adout;
reg	[15:0]Brdout;
reg	[11:0]Bdout;

//the state
reg	[4:0]i;
reg	[1:0]state;
always @(posedge sclk)
	if (!rst_n)
			begin
				Ardout <= 1'b0;
				Brdout <= 1'b0;
				i <= 1'b0;
				cs_n <= 1'b1;
				state <= 1'b0;
			end
	else	
	case (state) 
	2'b00:	begin
				cs_n <= 1'b1;
				state <= 2'b01;
			end
	2'b01:  begin
				cs_n <= 1'b0;
				state <= 2'b10;
				i <= 5'd16;
			end
	2'b10:	begin
			if( i == 5'd0 )
				begin
					cs_n <= 1'b1;
					state <= 2'b11;
					//Ardout <= {Ardout[14:0],A_sdi};
					//Brdout <= {Brdout[14:0],B_sdi};
				end
			else
				begin
					Ardout <= {Ardout[14:0],A_sdi};
					Brdout <= {Brdout[14:0],B_sdi};
					i <= i - 1'b1;	
					state <= 2'b10;
				end
			
			end	
	2'b11:	begin
				Adout  <= Ardout[11:0];
				Bdout  <= Brdout[11:0];
				state <= 2'b00;
			end
		endcase
wire[11:0]A_data = Adout;
wire[11:0]B_data = Bdout;

wire Acs_n=cs_n;
wire Bcs_n=cs_n;
		
endmodule


