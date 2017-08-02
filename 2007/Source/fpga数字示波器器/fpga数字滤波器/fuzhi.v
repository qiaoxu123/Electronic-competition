module fuzhi (clk,rst_n,data_out,f1,f2,f3,f4);
input clk,rst_n;
input[9:0] data_out;
output[3:0] f1,f2,f3,f4;
//********************************8
reg[25:0] cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) cnt<=1'b0;
	else if(cnt==26'd49_999_999)
		cnt<=1'b0;
	else 
		cnt<=cnt+1'b1;
end
		
wire t=(cnt==26'd49_999_999) ? 1'b1:1'b0;	
	
reg[9:0] datamax,datamin;
reg[10:0]fuzhi_r;
reg[9:0] data_r;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		data_r<=1'b0;
	else if(t)
	begin
		datamax<=1'b1;
		datamin<=10'd1023;
		if((datamax-datamin)>=9'd495)
			fuzhi_r<=(((datamax-datamin)*21)/6);
		else if((datamax-datamin)>=9'd440 && (datamax-datamin)<9'd495)
			fuzhi_r<=((((datamax-datamin)<<2'd3)+((datamax-datamin)<<1'b1))/3);
		else if((datamax-datamin)>=8'd237&&(datamax-datamin)<9'd440)
			fuzhi_r<=(((datamax-datamin)<<3'd4)/5);
		else if((datamax-datamin)<8'd237&&(datamax-datamin)>=7'd120)
			fuzhi_r<=(((datamax-datamin)<<1'd1)+(datamax-datamin));
		else
			fuzhi_r<=(((datamax-datamin)<<2'd3)/3);
	end
	else
	begin
		data_r<=data_out;
		if(datamax<data_r)	
			datamax<=data_r;
		else if(datamin>data_r) 
			datamin<=data_r;
	end
end
//*****************************************8
reg[10:0] fuzhi;
reg[3:0] f1_r,f2_r,f3_r,f4_r;
reg[15:0] temp;
integer i;

always@(posedge clk)
begin
	fuzhi=fuzhi_r;
	temp = 0;
	for(i = 0;i < 10;i = i + 1)
	begin
		 temp = {temp[14:0],fuzhi[10]}; 
		 if(temp[3:0] > 4'd4) 
			temp[3:0] = temp[3:0]+4'd3;
         if(temp[7:4] > 4'd4) 
            temp[7:4] = temp[7:4]+4'd3;
         if(temp[11:8] > 4'd4) 
            temp[11:8] = temp[11:8]+4'd3;
         if(temp[15:12] > 4'd4) 
            temp[15:12] = temp[15:12]+4'd3;
		 fuzhi=fuzhi<<1;  
          {f1_r,f2_r,f3_r,f4_r}={temp[14:0],fuzhi[0]};
      end
end

assign f1=f1_r;
assign f2=f2_r;
assign f3=f3_r;
assign f4=f4_r;

endmodule
