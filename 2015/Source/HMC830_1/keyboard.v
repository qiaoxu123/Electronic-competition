module keyboard

(

 clk,  //50MHZ

 rst_n,

 hang,   //检测行

 lie,   //列

 key_value,  //按键值
 
 hang_pose,//按键按下标志
 CNT,key_pluse,key_pluse1,
 flag1,flag,int_frac_data,
switch1 
);

input clk,rst_n; 
input switch1;
input [3:0] hang;
input flag1;
output flag;
output [31:0] int_frac_data;
output [3:0] key_value;
output  [3:0] lie;
output [3:0] hang_pose;
output [20:0] CNT;
output key_pluse;
output key_pluse1;

reg [3:0] lie;
reg [3:0] key_value;

reg [2:0] state;  //按键按下状态
reg key_flag;   //按键按下标志
reg clk_500khz;  //500KHZ时钟
reg [3:0] lie_reg;  //列数值寄存器
reg [3:0] hang_reg;  //行时钟寄存器



reg [5:0] count;//时钟分频计数字
/*****************时钟分频500Khz********************8*/
always @(posedge clk or negedge rst_n)

   if(!rst_n) 
    begin clk_500khz<=0; count<=0; end

   else

    begin

      if(count>=50) begin clk_500khz<=~clk_500khz;count<=0;end

      else count<=count+1'b1;

    end
/******************结束***************888*/////



/*******************************按键按下检**************************************/

reg [3:0] key_rst;

always @(posedge clk or negedge rst_n)

        if(!rst_n)
                key_rst=4'b1111;
        else
                key_rst=hang;
   
	
reg [3:0] key_rst_r;

always @(posedge clk or negedge rst_n)

        if(!rst_n)
                key_rst_r=4'b1111;
        else
                key_rst_r=key_rst;
                
//××按键按下Kye_an值一采集按键的下降沿

wire [3:0] key_an=key_rst_r & (~key_rst);



//CNT 延时计数子延时大约50ms
reg [19:0] CNT_r;

always@(posedge clk or negedge rst_n)

			if(!rst_n)
					CNT_r=20'd0;
			else if(key_an)//检测到下降沿CNT计数子至零
					CNT_r=20'd0;
			else    
					CNT_r=CNT_r+1;

					
//延时后把按键的状态附给low_sw
reg [3:0] low_sw;

always@(posedge clk or negedge rst_n)

			if(!rst_n)
					low_sw=4'b1111;
			else if(CNT_r==20'hfffff)
					low_sw=hang;
reg [3:0] low_sw_r;

always@(posedge clk or negedge rst_n)

			if(!rst_n)
					low_sw_r=4'b1111;
			else
					low_sw_r=low_sw;
					
					
//延时后检测到按键按下时hang_pose 拉高一个时钟周期
wire [3:0] hang_pose=low_sw_r & (~low_sw); 
			

/**************************按键数值检测**********************************/
 always @(posedge clk_500khz or negedge rst_n)

   if(!rst_n) 
   begin 
	   lie<=4'b0000;
	   state<=0;
   end

   else 

    begin 

     case (state)

      0: 

         begin

			 lie[3:0]<=4'b0000;

			 key_flag<=1'b0;

			 if(hang[3:0]!=4'b1111) //(hang[3:0]!=4'b1111)表示有按键按下扫描第一行
			 begin 
			 state<=1;
			 lie[3:0]<=4'b1110;
			 end 

			 else state<=0;

         end 

      1:  

         begin

          if(hang[3:0]!=4'b1111) begin state<=5;end   //判断是第一行,ֻ�����ж�Ӧ���ʱ�������Ժ���(hang[3:0]!=4'b1111)��������

          else  begin state<=2;lie[3:0]<=4'b1101;end  //扫描第二行

         end 

      2:

         begin    

         if(hang[3:0]!=4'b1111) begin state<=5;end    //判断扫描第二行,ֻ�����ж�Ӧ���ʱ�������Ժ���(hang[3:0]!=4'b1111)��������

         else  begin state<=3;lie[3:0]<=4'b1011;end  //扫描第三行

         end

      3:

         begin    

         if(hang[3:0]!=4'b1111) begin state<=5;end   //判断是否是第三行,ֻ�����ж�Ӧ���ʱ�������Ժ���(hang[3:0]!=4'b1111)��������

         else  begin state<=4;lie[3:0]<=4'b0111;end  //判断扫描第4行

         end

      4:
         begin    

         if(hang[3:0]!=4'b1111) begin state<=5;end  //判断是否是第4行,ֻ�����ж�Ӧ���ʱ�������Ժ���(hang[3:0]!=4'b1111)��������

         else  state<=0;

         end

      5:

         begin  

          if(hang[3:0]!=4'b1111) begin

									key_flag<=1'b1;  //按键按下标识之一

									lie_reg<=lie;  //列支给寄存器

									state<=5;

									hang_reg<=hang;  //行数值给寄存器


                                  end             

          else begin
                state<=0;
                key_flag<=1'b0; 
               end 
         end    

     endcase 

    end           

  /**********************************键盘处理部分**************************/
/*************************�������̵�����ת��Ϊ��ֵ***************************/
 always @(posedge clk_500khz  or negedge rst_n)
   if(!rst_n) 
   begin
		key_value <=0;
   end
   else
     begin

        if(key_flag == 1'b1) 

                begin

                     case ({hang_reg,lie_reg})

                      8'b1110_1110:begin key_value=7;end

                      8'b1110_1101:begin key_value=8;end

                      8'b1110_1011:begin key_value=9;end

                      8'b1110_0111:begin key_value=10;end//手动设置频率开启

                      

                      8'b1101_1110:begin key_value=4;end

                      8'b1101_1101:begin key_value=5;end

                      8'b1101_1011:begin key_value=6;end

                      8'b1101_0111:begin key_value=11;end//手动设置频率模式取消

 

                      8'b1011_1110:begin key_value=1;end

                      8'b1011_1101:begin key_value=2;end

                      8'b1011_1011:begin key_value=3;end

                      8'b1011_0111:begin key_value=12;end //重新输入另一个频率时，清除上一频率（addr_r）

 

                      8'b0111_1110:begin key_value=15;end//开启自动扫频
 
                      8'b0111_1101:begin key_value=0;end//关闭自动扫频模式

                      8'b0111_1011:begin key_value=14;end//自动扫频模式下扫频时间增加&&输入数据错误时清零重新输入

                      8'b0111_0111:begin key_value=13;end//自动扫频模式下扫频时间减少
     

                     endcase 
                     					
              end  
              

   end    
// 自动扫频模式******************************
	
//*********自动扫频使能控制*******
reg key_pluse; 
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		key_pluse <= 1'b0;
	else if(hang_pose!=4'b0000)
		if(key_value==15)
			key_pluse <= 1'b1;
	else if(hang_pose!=4'b0000)
		if(key_value==0)
			key_pluse <= 1'b0;
	else
		key_pluse <= key_pluse;
end 

//**********结束*****************

// **********扫频时间控制*********	
reg [20:0] CNT/*synthesis noprune*/;
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		CNT <= 18'd25_0000;
	else if(hang_pose!=4'b0000 && key_pluse)
		begin 
			if(key_value==14 && CNT < 21'd125_0000)
				CNT <= CNT + 18'd25_0000;
			else if(key_value==13 && CNT > 18'd25_0000)
				CNT <= CNT - 18'd25_0000;
		end 
end 
//**************结束************

//*******************结束********************************


//手动设置频率模式**************************
//*****设置使能按键**************
 reg key_pluse1;
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		key_pluse1 <= 1'b0;
	else if(hang_pose!=4'b0000 && key_value==10)
		key_pluse1 <= 1'b1;
	else if(hang_pose!=4'b0000 && key_value==11)
		key_pluse1 <= 1'b0;
	else 
		key_pluse1 <= key_pluse1;
end 
// *******结束*******************

//按键控制频率设置****************
//输入980等于98MHZ*******
reg [10:0] word_r;
always @ (posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		word_r <= 11'd0;
	else if(hang_pose!=4'b0000 && key_pluse1 )
		begin 
			if( key_value==14)
					word_r <= 11'd0;
			else if(key_value==13)
					word_r <= 11'd0;
			else if(key_value==12)
					word_r <= 11'd0;
			else
				word_r <= 10*word_r + key_value ;
		end 
end 	
//*******************结束**************************************		
		
//********************rom给数据控制addr********************
reg [7:0] addr_r;	
reg flag;
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		begin 
			flag <= 1'b0;
			addr_r <= 8'd0;
		end 
	else if(key_pluse && flag1)
		addr_r <= addr_r + 1'b1;
	else if(addr_r==201)
		addr_r <= 8'd0;
	else if((hang_pose!=4'b0000) && (key_value==12) && key_pluse1)
		addr_r <= 8'd0;
	else if((hang_pose!=4'b0000) && key_pluse1 && key_value==13 )
		begin 
			addr_r <=  word_r - 900;
			flag <= 1'b1;
		end 
	else 
		begin 
			addr_r <= addr_r;
			flag <= 1'b0;
		end 
end 

wire [7:0] addr;
assign addr = addr_r;
wire [31:0] int_frac_data1;
wire [31:0] int_frac_data2;
rom U1(
	.address(addr),
	.clock(clk),
	.q(int_frac_data1));
rom_r U2(
	.address(addr),
	.clock(clk),
	.q(int_frac_data2));
//模式90-110 与80-100之间转换******
assign int_frac_data=(switch1==1)? int_frac_data2:int_frac_data1;
	
endmodule
