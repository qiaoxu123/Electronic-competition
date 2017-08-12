module speed_select_tx(clk,rst,bps_start,clk_bps);

input clk;	// 50MHz主时钟
input rst;	//低电平复位信号
input bps_start;	//接收到数据后，波特率时钟启动信号置位
output clk_bps;	// clk_bps的高电平为接收或者发送数据位的中间采样点 

`define bps_para    6 
`define bps_para_1  3

reg[12:0] cnt;
reg clk_bps_r;
reg[2:0]uart_ctrl;

always@(posedge clk or negedge rst)
if(!rst) cnt <=13'd0;
else if((cnt==`bps_para)||!bps_start) cnt<=13'd0;
else cnt<=cnt+13'd1;

always@(posedge clk or negedge rst)
if(!rst) clk_bps_r <=1'b0;
else if(cnt==`bps_para_1) clk_bps_r<=1'b1;
else clk_bps_r <=1'b0;

assign clk_bps=clk_bps_r; 
endmodule 




