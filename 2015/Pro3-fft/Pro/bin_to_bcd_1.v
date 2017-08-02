module bin_to_bcd_1(clk_100M,shu,ge,shi,bai,qian);
input clk_100M;
input [11:0] shu;                             
output[3:0] ge;
output[3:0] shi;
output[3:0] bai;
output[3:0]qian;

reg[3:0]  ge_r,shi_r,bai_r,qian_r;
reg[11:0] shu_r;
reg[15:0] temp;
integer i;
assign ge =  ge_r;
assign shi = shi_r;
assign bai = bai_r;
assign qian =qian_r;

always @(posedge clk_100M)
begin
      shu_r = shu;
      temp = 0;
      for(i = 0;i < 11;i = i + 1)
      begin
             temp = {temp[14:0],shu_r[11]}; 
             if(temp[3:0] > 4'd4) 
                    temp[3:0] = temp[3:0]+4'd3;
             if(temp[7:4] > 4'd4) 
                    temp[7:4] = temp[7:4]+4'd3;
             if(temp[11:8] > 4'd4) 
                    temp[11:8] = temp[11:8]+4'd3;
             if(temp[15:12] > 4'd4) 
                    temp[15:12] = temp[15:12]+4'd3;
             shu_r=shu_r<<1;  
             {qian_r,bai_r,shi_r,ge_r}={temp[14:0],shu[0]};
         end
end
endmodule 