module  control (
				clk,rst_n,sw,sw_an,
				f1,f2,f3,f4,
				p1,p2,p3,p4,p5,p6,p7,
				x_pos,y_pos,valid,y_cnt,data_out,
				red,green,blue,cf
				);
input clk;
input rst_n;
input[7:0] sw,sw_an;
input[9:0] data_out;//下降沿AD送进来的数据
input[10:0] x_pos,y_pos,y_cnt;
input valid;
input[3:0] f1,f2,f3,f4;
input[3:0] p1,p2,p3,p4,p5,p6,p7;
output[2:0] red,green,blue;
output cf;

//********************软件触发设置出发点********************************************************
reg cf,cf_1,cf_2;
//reg cfdset;
reg[11:0]cnt1;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) cf<=1'b0;
	else if(data_out<10'd512)
		cf<=1'b0;
	else if(data_out>10'd512 && data_out<=10'd1023)
		cf<=1'b1;
	else
		cf<=cf;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		cf_1<=1'b1;
		cf_2<=1'b1;
	end
	else 
	begin
		cf_1<=cf;
		cf_2<=cf_1;
	end
end
wire cfd = cf_1 & (~cf_2);//触发信号

/*always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) 
		cfdset<=1'b0;
	else if(cfd )//&& y_cnt==11'd630)//	vga出错，不信就改个数试试。
		cfdset<=1'b1;
	else if(cnt1==12'd2100)
		cfdset<=1'b0;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) cnt1<=1'b0;
	else if(cnt1==12'd2101)
		cnt1<=1'b0;
	else if(cfdset)
		cnt1<=cnt1+1'b1;
end*/
//**************************************************************8
reg[8:0] rgb;
assign red=rgb[8:6];
assign green=rgb[5:3];
assign blue=rgb[2:0];
/*
rgb = 000  	黑色	rgb = 100	红色
	= 001  	蓝色		= 101	紫色
	= 010	绿色		= 110	黄色
	= 011	青色		= 111	白色
*/
reg [10:0] wr_addr;
reg [10:0] rd_addr; 
reg[16:0] wave;
reg[9:0] hengyi;//波形横移控制
reg[3:0]tiaopin;//调频
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) 
	begin
		romaddr1<=6'd0;	
		romaddr2<=4'd0;	
		romaddr3<=5'd0;	
		romaddr4<=5'd0;	
		romaddr5<=6'd0;	
		romaddr6<=6'd0;	
		romaddr7<=4'd0;	
		rgb<=9'd0;
		wen<=1'b1;
		wr_addr<=11'd0;
		rd_addr<=11'd0;
	end
	else if (rden)
	begin
		wen<=1'b1;
		if(wr_addr==11'd2047) wr_addr<=11'd2047;
		else 
			wr_addr<=wr_addr+1'b1;
	end
	else if(valid)
	begin
		rgb<=9'b111_111_111;
		if((x_pos>11'd2 && x_pos<11'd513)&&(y_pos>11'd2 && y_pos<11'd513))//显示字符“示波器波形”
		begin
			rgb<=9'd0;
			wr_addr<=12'd0; 
			wen<=1'b0;//读RAM的信号
			rd_addr<= hengyi;
			rd_addr<=rd_addr+1'd1;//tiaopin;
			if((shu-y_pos-shuyi_2+shuyi_1)== wave) 
				rgb<=9'b000_111_000;
			//else if(y_pos==11'd512)
				//rgb<=9'b000_111_001;
			else if(y_pos==9'd257||y_pos==9'd258)
				rgb<=9'b111_111_111;
			else if(y_pos==9'd65||y_pos==9'd129||y_pos==9'd193||y_pos==9'd321||y_pos==9'd385||y_pos==9'd449||
					x_pos==9'd65||x_pos==9'd129||x_pos==9'd193||x_pos==9'd257||x_pos==9'd321||x_pos==9'd385||x_pos==9'd449)
				rgb<=9'b001_001_001;
			else rgb<=9'd0;
		end
		else if((x_pos>=11'd100&&x_pos<11'd420)&&(y_pos>=11'd520&&y_pos<11'd584))//显示“数字示波器”
		begin
			romaddr1<=y_pos-11'd520;
			if(romdata1[11'd420-x_pos]==1'b1)
			rgb<=9'b111_000_000;
			else rgb<=9'b111_111_111;
		end
		else if((x_pos>=11'd550&&x_pos<11'd614)&&(y_pos>=11'd120&&y_pos<11'd152))//显示字符“频率”
		begin
			romaddr3<=y_pos-11'd120;
			if(romdata3[11'd710-x_pos]==1'b1)
			rgb<=9'b111_000_000;
			else rgb<=9'b111_111_111;
		end
		else if((x_pos>=11'd550&&x_pos<11'd646)&&(y_pos>=11'd220&&y_pos<11'd252))//显示字符“峰峰值”
		begin
			romaddr3<=y_pos-11'd220;
			if(romdata3[11'd646-x_pos]==1'b1)
			rgb<=9'b111_000_000;
			else rgb<=9'b111_111_111;
		end
		else if((x_pos>=11'd550&&x_pos<11'd710)&&(y_pos>=11'd320&&y_pos<11'd352))//显示字符“垂直分辨率”
		begin
			romaddr4<=y_pos-11'd320;
			if(romdata4[11'd838-x_pos]==1'b1)
			rgb<=9'b111_000_000;
			else rgb<=9'b111_111_111;
		end
		else if((x_pos>=11'd550&&x_pos<11'd678)&&(y_pos>=11'd420&&y_pos<11'd452))//显示字符“扫描速率”
		begin
			romaddr4<=y_pos-11'd420;
			if(romdata4[11'd678-x_pos]==1'b1)
			rgb<=9'b111_000_000;
			else rgb<=9'b111_111_111;
		end
		else if((x_pos>=11'd600&&x_pos<11'd720)&&(y_pos>=11'd370&&y_pos<11'd386))//显示“垂直分辨率”
		begin
			romaddr5<=y_pos+addr5-11'd370;
			if(romdata5[11'd720-x_pos]==1'b1)
			rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else if((x_pos>=11'd600&&x_pos<11'd744)&&(y_pos>=11'd470&&y_pos<11'd486))//显示“扫描速率”
		begin
			romaddr6<=y_pos+addr6-11'd470;
			if(romdata6[11'd744-x_pos]==1'b1)
			rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else if((x_pos>=11'd720&&x_pos<11'd752)&&(y_pos>=11'd180&&y_pos<11'd196))//显示字符hz
		begin
			romaddr7<=y_pos-11'd180;
			if(romdata7[11'd783-x_pos]==1'b1)
			rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else if((x_pos>=11'd670&&x_pos<11'd702)&&(y_pos>=11'd280&&y_pos<11'd296))//显示字符mv
		begin
			romaddr7<=y_pos-11'd280;
			if(romdata7[11'd702-x_pos]==1'b1)
			rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else if((x_pos>=11'd600&&x_pos<11'd720)&&(y_pos>=11'd180&&y_pos<11'd196))//显示频率值
		begin
			romaddr2<=y_pos-11'd180;
			if(((romdata2[11'd616+((11'd9-p1)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd600&&x_pos<11'd616)) 
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd632+((11'd9-p2)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd616&&x_pos<11'd632)) 
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd648+((11'd9-p3)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd632&&x_pos<11'd648))
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd664+((11'd9-p4)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd648&&x_pos<11'd664)) 
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd680+((11'd9-p5)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd664&&x_pos<11'd680))
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd696+((11'd9-p6)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd680&&x_pos<11'd696))
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd712+((11'd9-p7)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd696&&x_pos<11'd712)) 
				rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else if((x_pos>=11'd600&&x_pos<11'd670)&&(y_pos>=11'd280&&y_pos<11'd296))//显示幅度值
		begin
			romaddr2<=y_pos-11'd280;
			if(((romdata2[11'd616+((11'd9-f1)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd600&&x_pos<11'd616)) 
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd632+((11'd9-f2)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd616&&x_pos<11'd632)) 
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd648+((11'd9-f3)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd632&&x_pos<11'd648))
				rgb<=9'b000_000_111;
			else if(((romdata2[11'd664+((11'd9-f4)<<11'd4)-x_pos])==1'b1)&&(x_pos>=11'd648&&x_pos<11'd664)) 
				rgb<=9'b000_000_111;
			else rgb<=9'b111_111_000;
		end
		else rgb<=9'b111_111_111;
	end
	else 
	begin
		rgb<=9'b0;
		wen<=1'b0;
		rd_addr<=hengyi;
	end
end
//********************幅度档位调制**********************************幅度档位调制**************************************
reg[1:0] fu;
reg[5:0] addr5;
reg[10:0]shu;
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n) 
	begin
		fu<=2'd0;
		shu<=11'd510;
	end
	else if (sw_an[0]) 
		fu<=fu+1'd1;
	else 
	begin
		case(fu)
		2'd0 : begin
				addr5<=6'd0;
				wave<=(ramdata>>2'd2);
				shu<=11'd384;
				end
		2'd1 : begin
				addr5<=6'd16;
				wave<=((ramdata*13)/12);
				shu<=11'd811;
				end
		2'd2 : begin
				addr5<=6'd32;
				wave<=(((ramdata<<1'd1)*13)/12);
				shu<=11'd1364;
				end
		2'd3 : begin
				addr5<=6'd48;
				wave<=(((ramdata<<3'd6)+(ramdata<<3'd5)+(ramdata<<2'd2)));
				shu<=11'd1216;
				end
		endcase
	end
end
//*****************波形上下移动************************************波形上下移动***********************************************
reg[10:0]shuyi_1,shuyi_2;//波形上下移动
/**************************************************************************
特别解释下为什么要使用两个“shuyi”：
因为verilog没有负值，如果使用一个，当它减到0时，那么它再减就会变成最大值。
如果使用两个控制的话，看下程序就好像凭空造出一个负值来!!!!
*********************************************************************************/				
reg clk_t;
reg[17:0] countt;
always @(posedge clk)
if((countt == 18'd199999))
begin
	clk_t <= ~clk_t;
	countt <= 0;
end	
else   
	countt <= countt + 1'b1;
	
always @ (posedge clk_t or negedge rst_n)
begin
	if(!rst_n)
	begin
		shuyi_1<=10'd0;
		shuyi_2<=10'd0;
	end
	else if(!sw[4])
	begin
		shuyi_1<=shuyi_1+1'b1;
	end
	else if(!sw[5])
	begin
		shuyi_2<=shuyi_2+1'b1;
	end
	else 
	begin
		shuyi_1 <= shuyi_1;
		shuyi_2 <= shuyi_2;
	end
end
//******************波形横移**********************************************波形横移*************************************************
always@(posedge clk_t or negedge rst_n)
begin
	if(!rst_n) hengyi<=10'd500;
	else if(!sw[2])
		hengyi<=hengyi+1'd1; 
	else if(!sw[3])
		hengyi<=hengyi-1'd1; 
end	
//*******************频率档位调制****************************************频率档位调制**********************************************************reg[5:0] addr6;
wire clk200M;
reg[1:0] pin;
reg[5:0] addr6;
reg clk_out;
reg[15:0] count,count_x;
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n) pin<=2'd0;
	else if (sw_an[1]) 
		pin<=pin+1'd1;
	else if (pin==2'd3) 
		pin<=2'd0;
	else 
	begin
		case(pin)
		2'd0 : begin
				addr6<=6'd0;
				count<=16'd4;//100ns/div/***/10MHz/div
				end
		2'd1 : begin
				addr6<=6'd16;
				count<=16'd32; //2us/div/***/0.5MHz/div
				end
		2'd2 : begin
				addr6<=6'd32;
				count<=16'd64;//20ms/div/***/50Hz/div
				end
		endcase
	end
end
pll  a2(
		.inclk0(clk),
		.c0(clk200M)
		);
always @(posedge clk200M)
if((count_x ==count))
begin
	clk_out <= ~clk_out;
	count_x <= 0;
end	
 else   
	count_x <= count_x + 1'b1;
	
assign clk_f = clk_out;
//****************************************FIFO读写控制*****************************88
reg state;		
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		state <= 1'b0;
		rden <= 1'b0;
		wren <= 1'b0;
	end
	else 
		case (state)
		1'b0:	if ( wrfull )
				begin
					state <= 1'b1;
				end
				else if(cfd)
				begin
					rden <= 1'b0;
					state <= 1'b0;
					wren <= 1'b1;
				end
		1'b1:	if (rdempty)
				begin
					state <= 1'b0;
				end
				else if(y_cnt==630) 
				begin
					rden <= 1'b1;
					state <= 1'b1;
					wren <= 1'b0;
				end
		endcase
end
	
//***************************************************
assign ramaddr=(!wen) ? rd_addr : wr_addr;//ram的地址控制

//*****************************ram/rom的例化*******************************************88
reg wen;
wire[9:0] dataout; 
wire[10:0] ramaddr;
wire[9:0] ramdata;
reg[5:0] romaddr1;
wire[319:0] romdata1;
reg[3:0] romaddr2;
wire[159:0] romdata2;
reg[4:0] romaddr3;
wire[159:0] romdata3;
reg[4:0] romaddr4;
wire[287:0] romdata4;
reg[5:0] romaddr5;
wire[119:0] romdata5;
reg[5:0] romaddr6;
wire[143:0] romdata6;
reg[3:0] romaddr7;
wire[63:0] romdata7;
reg	wren,rden;
wire clk,clk_f,rdempty,wrfull;
wire[9:0] fifo_out;
ram u0 (
		.address(ramaddr),
		.clock(clk),
		.data(fifo_out),
		.wren(wen),
		.q(ramdata)
		);
rom1 u1 (
		.address(romaddr1),
		.clock(clk),
		.q(romdata1)
		);
rom2 u2 (
		.address(romaddr2),
		.clock(clk),
		.q(romdata2)
		);
rom3 u3 (
		.address(romaddr3),
		.clock(clk),
		.q(romdata3)
		);	
rom4 u4 (
		.address(romaddr4),
		.clock(clk),
		.q(romdata4)
		);	
rom5 u5 (
		.address(romaddr5),
		.clock(clk),
		.q(romdata5)
		);	
rom6 u6 (
		.address(romaddr6),
		.clock(clk),
		.q(romdata6)
		);
rom7 u7 (
		.address(romaddr7),
		.clock(clk),
		.q(romdata7)
		);
fifo u8 (
		.aclr(!rst_n),
		.data (data_out),
		.rdclk (clk),
		.rdreq (rden),
		.wrclk (clk_f),
		.wrreq (wren),
		.q (fifo_out),
		.rdempty (rdempty),
		.wrfull (wrfull)
		);
endmodule 