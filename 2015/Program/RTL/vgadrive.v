
module vgadrive(
                 clk, rst_n,
                 RGB, VGA_B, 
					  VGA_BLANK_N, VGA_CLK, 
					  VGA_G, VGA_HS,
					  VGA_R,VGA_SYNC_N, 
					  VGA_VS, 
					  hx, vy
					  );
   input   clk, rst_n;
	input   [23:0]  RGB;
   output  [7:0]	VGA_B;
	output  VGA_BLANK_N;
	output  VGA_CLK;
	output  [7:0]	VGA_G;
	output  VGA_HS;
	output  [7:0]  VGA_R;
	output  VGA_SYNC_N;
	output  VGA_VS;
	output [9:0] hx, vy;



parameter HEND = 11'd1056;
parameter HA=11'd80,HB=11'd160,HC=11'd800,HD=11'd16; 
parameter VEND =11'd625;
parameter VO=11'd3,VP=11'd21,VQ=11'd600,VR=11'd1;





reg [10:0] hscount;
always @(posedge clk or negedge rst_n)
begin 
  if(!rst_n)
    hscount <= 1'b0;
  else if (hscount ==HEND)
    hscount <=1'b0;
  else 
    hscount <=hscount+1'b1;
end

reg [9:0] vscount;
always @(posedge clk or negedge rst_n)
 if(!rst_n)
  vscount <=1'b0;
 else if(vscount == VEND)
   vscount <=1'b0;
 else if(hscount ==HEND)
   vscount <=1'b1+vscount;
wire hs,vs;   
assign hs =(hscount <= HA)? 1'b0 : 1'b1;
assign vs =(vscount <= VO)? 1'b0 : 1'b1;

reg isok;
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
    isok<=1'b0;
  else if((hscount > HA+HB && hscount <HA+HB+HC)&&(vscount > VO + VP && vscount <VO+VP+VQ))
    isok<=1'b1;
  else 
    isok<=1'b0;
 end 
 

wire [10:0] x,y;
assign x = isok ? hscount-HA-HB : 1'b0;

assign y = isok ? vscount-VO-VP : 1'b0;
assign hx = x[9:0];
assign vy = y[9:0];

assign  VGA_BLANK_N	=	hs;
assign  VGA_SYNC_N	=	vs;
assign  VGA_CLK		=	clk;
assign  VGA_VS			=	vs;
assign  VGA_HS			=	hs;

assign VGA_R = RGB[23:16];			 
assign VGA_G = RGB[15:8];
assign VGA_B = RGB[7:0]; 
endmodule  
  
   
    
    