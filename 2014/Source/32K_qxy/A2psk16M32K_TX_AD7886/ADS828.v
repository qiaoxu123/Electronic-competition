module ADS828(clk_AD,rst,
Adata_in,
Bdata_in,

Acode_AD,
Bcode_AD
);


input clk_AD,rst;
input[9:0]Adata_in;
input[9:0]Bdata_in;

output[7:0]Acode_AD;
output[7:0]Bcode_AD;

reg[9:0]Adata_out_r; 
reg[9:0]Bdata_out_r; 

always@(negedge clk_AD or negedge rst)
begin
	if(!rst)
		begin 	
			Adata_out_r<=10'd0;
			Bdata_out_r<=10'd0;
		end 
	else 
		begin 
			Adata_out_r<=Adata_in;
			Bdata_out_r<=Bdata_in;
		end 
end

wire[9:0]Adata_out=Adata_out_r; 
wire[9:0]Bdata_out=Bdata_out_r; 

wire[7:0]Acode_AD=Adata_out[9:2];
wire[7:0]Bcode_AD=Bdata_out[9:2];
endmodule 
