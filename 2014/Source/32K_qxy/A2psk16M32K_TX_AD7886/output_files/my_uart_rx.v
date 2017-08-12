module my_uart_rx(clk,rst,rs232_rx,rx_data_out,clk_bps,bps_start);
input clk;	// 50MHz主时钟
input rst;	//低电平复位信号
input rs232_rx;	// RS232接收数据信号
input clk_bps;	// clk_bps的高电平为接收或者发送数据位的中间采样点

output bps_start;	//接收到数据后，波特率时钟启动信号置位
output[3:0] rx_data_out;	//接收数据寄存器，保存直至下一个数据来到 
//output rx_int;	//接收数据中断信号,接收到数据期间始终为高电平


reg rs232_rx0,rs232_rx1,rs232_rx2,rs232_rx3;	//接收数据寄存器，滤波用
always @ (posedge clk or negedge rst) begin
	if(!rst) begin
			rs232_rx0 <= 1'b1;
			rs232_rx1 <= 1'b1;
			rs232_rx2 <= 1'b1;
			rs232_rx3 <= 1'b1;
		end
	else begin
			rs232_rx0 <= rs232_rx;
			rs232_rx1 <= rs232_rx0;
			rs232_rx2 <= rs232_rx1;
			rs232_rx3 <= rs232_rx2;
		end
end

wire neg_rs232_rx;	//表示数据线接收到下降沿
assign neg_rs232_rx = rs232_rx3&&rs232_rx2&&~rs232_rx1&&~rs232_rx0;	//接收到下降沿后neg_rs232_rx置高一个时钟周期

reg bps_start;
reg[3:0] num;
reg rx_int;
  
  
always@(posedge clk or negedge rst)
	if(!rst)
	begin
		bps_start<=1'b0;
		rx_int<=1'b0;
	end
	else if(neg_rs232_rx)//接收到串口接收线的下降沿
	begin
		bps_start<=1'b1;
		rx_int<=1'b1;
	end
	else if(num==4'd12)//接受完数据位
	begin
		bps_start<=1'b0;
		rx_int<=1'b0;
	end

	
reg[7:0] rx_data;
reg a;	//数据移位标志

always @ (posedge clk or negedge rst)
 begin
	if(!rst) 
		 begin
			a<= 1'b0;
			num <= 4'd0;
			rx_data <= 8'd0;
		 end
	else if(rx_int) 
	   begin	//接收数据处理
			if(clk_bps) 
				begin	//读取并保存数据,接收数据为一个起始位，8bit数据，一个结束位		
					a<= 1'b1;
					num <= num+1'b1;
					if(num<=4'd8) 
					rx_data[7]<= rs232_rx;	//锁存9bit（1bit起始位，8bit数据）
				end
			else if(a) //数据移位处理	
				begin	
					a<= 1'b0;
					if(num<=4'd8) rx_data<=rx_data>>1'b1;	//移位8次，第1bit起始位移除，剩下8bit正好时接收数据
					else if(num==4'd12) num <= 4'd0;	//接收到STOP位后结束,num清零	end
				end
		 end
end

assign rx_data_out=rx_data[3:0];
endmodule
