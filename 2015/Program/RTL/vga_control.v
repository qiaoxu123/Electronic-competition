module vga_control(
		 //system signal
		 input      				clk		,//系统时钟
       input     			 		rst_n		,//复位
		 // other
       input  		[9:0]   	 	qram 		,//数据
		 input  		[1:0]    	sw			,//开关
		 //cepin signal
       input  		[11:0]    	A1			,//幅值1
       input  		[11:0]   	A2			,//幅值2
       input  		[19:0]    	F1			,//频率1
       input  		[19:0]    	F2			,//频率2
		 //vag signal
       input  		[9:0]   		hx			,//vga列地址
       input  		[9:0]    	vy			,//vga行地址
       output 		[23:0]    	rgb		,//vag色度值
       output     				vgalive	 //vga有效显示范围

 );

assign vgalive = ( vy >= 7'd64 && vy <= 10'd500) && (hx <= 10'd800 && hx >= 1'b1);

reg [7:0]g1;
reg [7:0]r1;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)begin 
		r1 <= 1'b0;
		g1 <= 1'b0; end 
	else if(singal && vgalive ) begin 
	   r1 <= 16'hffff;
		g1 <= 16'hffff; end
	else begin 
		g1 <= 1'b0;
		r1 <= 1'b0;
	end 
end 


wire singal = 10'd512  - vy < qram<<1'b1;
assign rgb = {r1,g1,8'h0} + {r,g,b};
//数字显示地址
wire j_1_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd270   &&  hx < 10'd286);
wire j_2_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd286   &&  hx < 10'd302);
wire j_3_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd302   &&  hx < 10'd318);
wire j_4_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd318   &&  hx < 10'd334);
wire j_5_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd334   &&  hx < 10'd350);
wire j_6_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd350   &&  hx < 10'd366);
wire j_7_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd366   &&  hx < 10'd382);
wire j_8_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd382   &&  hx < 10'd398);
wire j_9_area    =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd398   &&  hx < 10'd414);//H
wire j_10_area   =    (vy >= 10'd540 && vy <  10'd572) && (hx >= 10'd414   &&  hx < 10'd430);
//频率1显示地址
wire f1_2_1  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd50   &&  hx <= 10'd65);//f
wire f1_2_2  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd66   &&  hx <= 10'd81);//1
wire f1_1_0  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd82   &&  hx <= 10'd97);//冒号
wire f1_1_1  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd98   &&  hx <= 10'd113);//25 000 000
wire f1_1_2  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd114  &&  hx <= 10'd129);
wire f1_1_3  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd130  &&  hx <= 10'd145);
wire f1_1_4  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd146  &&  hx <= 10'd161);
wire f1_1_5  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd162  &&  hx <= 10'd177);
wire f1_1_6  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd178  &&  hx <= 10'd193);
wire f1_1_7  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd194  &&  hx <= 10'd209);
wire f1_1_8  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd210  &&  hx <= 10'd225);
wire f1_2_3  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd226  &&  hx <= 10'd241);//h
wire f1_2_4  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd242  &&  hx <= 10'd257);//z
//幅值1显示地址
wire a1_2_1  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd50   &&  hx <= 10'd65);//a
wire a1_2_2  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd66   &&  hx <= 10'd81);//1
wire a1_1_0  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd82   &&  hx <= 10'd97);// :
wire a1_1_1  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd98   &&  hx <= 10'd113);//120 000
wire a1_1_2  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd114  &&  hx <= 10'd129);
wire a1_1_3  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd130  &&  hx <= 10'd145);
wire a1_1_4  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd146  &&  hx <= 10'd161);
wire a1_1_5  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd162  &&  hx <= 10'd177);
wire a1_1_6  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd178  &&  hx <= 10'd193);
wire a1_2_3  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd194  &&  hx <= 10'd209);//m
wire a1_2_4  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd210  &&  hx <= 10'd225);//V
//频率2显示地址
wire f2_2_1  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd450  &&  hx < 10'd466);//F
wire f2_2_2  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd466  &&  hx < 10'd482);//2
wire f2_1_0  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd482  &&  hx < 10'd498);//:
wire f2_1_1  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd498  &&  hx < 10'd514);
wire f2_1_2  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd514  &&  hx < 10'd530);
wire f2_1_3  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd530  &&  hx < 10'd546);
wire f2_1_4  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd546  &&  hx < 10'd562);
wire f2_1_5  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd562  &&  hx < 10'd578);
wire f2_1_6  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd578  &&  hx < 10'd594);
wire f2_1_7  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd594  &&  hx < 10'd610);
wire f2_1_8  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd610  &&  hx < 10'd626);
wire f2_2_3  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd626  &&  hx < 10'd642);//h
wire f2_2_4  =  (vy >= 10'd536 && vy <= 10'd567) && (hx >= 10'd642  &&  hx < 10'd658);//08z
//幅值2显示地址
wire a2_2_1  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd450  &&  hx < 10'd466);//a
wire a2_2_2  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd466  &&  hx < 10'd482);//2
wire a2_1_0  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd482  &&  hx < 10'd498);//:
wire a2_1_1  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd498  &&  hx < 10'd514);
wire a2_1_2  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd514  &&  hx < 10'd530);
wire a2_1_3  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd530  &&  hx < 10'd546);
wire a2_1_4  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd546  &&  hx < 10'd562);
wire a2_1_5  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd562  &&  hx < 10'd578);
wire a2_1_6  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd578  &&  hx < 10'd594);
wire a2_2_3  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd594  &&  hx < 10'd610);
wire a2_2_4  =  (vy >= 10'd569 && vy <= 10'd600) && (hx >= 10'd610  &&  hx < 10'd626);


//+++++++++++++++++++++++++++++++++++坐标轴++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
wire x =  (vy == 10'd500) && hx>=10'd0 && hx < 10'd800;
wire y =  (hx%7'd100 == 1'b0) && vy <= 10'd500 && vy >= 10'd497; 
wire x1 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd92  && hx < 10'd108);
wire x2 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd192 && hx < 10'd208);
wire x3 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd292 && hx < 10'd308);
wire x4 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd392 && hx < 10'd408);
wire x5 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd492 && hx < 10'd508);
wire x6 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd592 && hx < 10'd608);
wire x7 = (vy >= 10'd501 && vy < 10'd533) &&(hx >= 10'd692 && hx < 10'd708);
/////坐标纸

wire z1 = vgalive && (hx%7'd50 == 1'b0 || hx == 1'b1) && vy%2'd3 == 1'b0;
wire z2 = vgalive && ((vy - 7'd64)%7'd50 == 1'b0) && hx%2'd3 == 1'b0;

wire  [3:0] f1_1,f1_2,f1_3,f1_4,f1_5,f1_6,f1_7,f1_8;
//f1
assign f1_1 = 1'b0;
assign f1_2 = F1/1_000_000;
assign f1_3 = F1/100_000%10;
assign f1_4 = F1/10_000%10;
assign f1_5 = F1/1000%10;
assign f1_6 = F1/100%10;
assign f1_7 = F1/10%10;
assign f1_8 = F1%10;
//f2
assign f2_1 = 1'b0;		
assign f2_2 = F2/1_000_000;
assign f2_3 = F2/100_000%10;
assign f2_4 = F2/10_000%10;
assign f2_5 = F2/1000%10;
assign f2_6 = F2/100%10;
assign f2_7 = F2/10%10;
assign f2_8 = F2%10;
		
wire [3:0] f2_1,f2_2,f2_3,f2_4,f2_5,f2_6,f2_7,f2_8;    



wire [3:0] a1_1,a1_2,a1_3,a1_4,a1_5,a1_6;


bin_to_bcd_1 U9 (
						.clk_100M(clk),
						.shu(A1),
						.ge(a1_6),
						.shi(a1_5),
						.bai(a1_4),
						.qian(a1_3)
					);
					
					
bin_to_bcd_1 U10 (
						.clk_100M(clk),
						.shu(A2),
						.ge(a2_6),
						.shi(a2_5),
						.bai(a2_4),
						.qian(a2_3)
					);
assign {a1_1,a1_2} = 2'b0;

assign {a2_1,a2_2} = 2'b0;

wire  [3:0] a2_1,a2_2,a2_3,a2_4,a2_5,a2_6;
reg  [9:0] fp;
wire [3:0] j_1, j_2, j_3, j_4,j_5,j_6,j_7,j_8;
assign {j_1, j_2, j_3,j_8} = 4'b0;

bin_to_bcd_1 U11 (
						.clk_100M(clk),
						.shu(fp),
						.ge(j_7),
						.shi(j_6),
						.bai(j_5),
						.qian(j_4)
					);

always @(posedge clk or negedge rst_n)
begin 
	case(sw)
		2'b00: fp <= 1'b1;
		2'b01: fp <= 4'd10;
		2'b10: fp <= 7'd100;
		2'b11: fp <= 10'd1000;
	endcase
end 
reg  [9:0] add;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		add <= 1'b0;
	else if(j_1_area )
		add <= vy - 10'd540 + {j_1,5'b0};
	else if(j_2_area )
		add <= vy - 10'd540 + {j_2,5'b0};
	else if(j_3_area )
		add <= vy - 10'd540 + {j_3,5'b0};
	else if(j_4_area )
		add <= vy - 10'd540 + {j_4,5'b0};
	else if(j_5_area )
		add <= vy - 10'd540 + {j_5,5'b0};
	else if(j_6_area )
		add <= vy - 10'd540 + {j_6,5'b0};
	else if(j_7_area )
		add <= vy - 10'd540 + {j_7,5'b0};
	else if(j_8_area )
		add <= vy - 10'd540 + {j_8,5'b0};
	else if(j_9_area )
		add <= vy - 7'd92;
	else if(j_10_area )
		add <= vy - 6'd60;
	else if(f1_2_1)
		add <= vy - 10'd216; 
	else if(f1_2_2)
		add <= vy - 10'd504;
	else if(f1_1_0)
		add <= vy - 10'd24; 
	else if(f1_1_1)
		add <= vy - 10'd536 + {f1_1,5'b0};
	else if(f1_1_2)
		add <= vy - 10'd536 + {f1_2,5'b0};
	else if(f1_1_3)
		add <= vy - 10'd536 + {f1_3,5'b0};
	else if(f1_1_4)
		add <= vy - 10'd536 + {f1_4,5'b0};
	else if(f1_1_5)
		add <= vy - 10'd536 + {f1_5,5'b0};
	else if(f1_1_6)
		add <= vy - 10'd536 + {f1_6,5'b0};
	else if(f1_1_7)
		add <= vy - 10'd536 + {f1_7,5'b0};
	else if(f1_1_8)
		add <= vy - 10'd536 + {f1_8,5'b0};
	else if(f1_2_3)
		add <= vy - 10'd88;
	else if(f1_2_4)
		add <= vy - 10'd56;
	else if(a1_2_1)
		add <= vy - 10'd217 ;
	else if(a1_2_2)
		add <= vy - 10'd537 ;
	else if(a1_1_0)
		add <= vy - 10'd57 ;
	else if(a1_1_1)
		add <= vy - 10'd569 + {a1_1,5'b0};
	else if(a1_1_2)
		add <= vy - 10'd569 + {a1_2,5'b0};
	else if(a1_1_3)
		add <= vy - 10'd569 + {a1_3,5'b0};
	else if(a1_1_4)
		add <= vy - 10'd569 + {a1_4,5'b0};
	else if(a1_1_5)
		add <= vy - 10'd569 + {a1_5,5'b0};
	else if(a1_1_6)
		add <= vy - 10'd569 + {a1_6,5'b0};
	else if(a1_2_3)
		add <= vy - 10'd185 ;
	else if(a1_2_4)
		add <= vy - 10'd153 ;
	else if(f2_2_1)
		add <= vy - 10'd216; 
	else if(f2_2_2)
		add <= vy - 10'd472;
	else if(f2_1_0)
		add <= vy - 10'd24; 
	else if(f2_1_1)
		add <= vy - 10'd536 + {f2_1,5'd0};
	else if(f2_1_2)
		add <= vy - 10'd536 + {f2_2,5'd0};
	else if(f2_1_3)
		add <= vy - 10'd536 + {f2_3,5'd0};
	else if(f2_1_4)
		add <= vy - 10'd536 + {f2_4,5'd0};
	else if(f2_1_5)
		add <= vy - 10'd536 + {f2_5,5'd0};
	else if(f2_1_6)
		add <= vy - 10'd536 + {f2_6,5'd0};
	else if(f2_1_7)
		add <= vy - 10'd536 + {f2_7,5'd0};
	else if(f2_1_8)
		add <= vy - 10'd536 + {f2_8,5'd0};
	else if(f2_2_3)
		add <= vy - 10'd88;
	else if(f2_2_4)
		add <= vy - 10'd56;
	else if(a2_2_1)
		add <= vy - 10'd217;
	else if(a2_2_2)
		add <= vy - 10'd505;
	else if(a2_1_0)
		add <= vy - 10'd57;
	else if(a2_1_1)
		add <= vy - 10'd569 + {a2_1,5'b0};
	else if(a2_1_2)
		add <= vy - 10'd569 + {a2_2,5'b0};
	else if(a2_1_3)
		add <= vy - 10'd569 + {a2_3,5'b0};
	else if(a2_1_4)
		add <= vy - 10'd569 + {a2_4,5'b0};
	else if(a2_1_5)
		add <= vy - 10'd569 + {a2_5,5'b0};
	else if(a2_1_6)
		add <= vy - 10'd569 + {a2_6,5'b0};
	else if(a2_2_3)
		add <= vy - 10'd185 ;
	else if(a2_2_4)
		add <= vy - 10'd153 ;
	else if(x1)
		add <= vy - 10'd469;
	else if(x2)
		add <= vy - 10'd437;
	else if(x3)
		add <= vy - 10'd405;
	else if(x4)
		add <= vy - 10'd373;
	else if(x5)
		add <= vy - 10'd341;
	else if(x6)
		add <= vy - 10'd309;
	else if(x7)
		add <= vy - 10'd277;
	else 
		add <= 1'b0;				
end 
wire [15:0] q;

display_rom U5(
	.address(add),
	.clock(clk),
	.q(q)
	);
	

rom_title U6 (
	.address(tadd),
	.clock(clk),
	.q(qt));

wire [511:0]qt;
reg [5:0] tadd;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		tadd <= 1'b0;
	else if(vy <7'd64 && hx >=10'd143 && hx< 10'd656)
		tadd <= vy;
	else 
		tadd <= 1'b0;
end 
reg [7:0] r,g,b;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n) 
		begin r <= 8'h0;  g <= 8'h0;   b <= 8'h0;   end 
	else if(j_1_area  && q[10'd286 - hx])
		r <= 8'hFF;
	else if(j_2_area  && q[10'd302 - hx])
		r <= 8'hFF;
	else if(j_3_area  && q[10'd318 - hx])
		r <= 8'hFF;
	else if(j_4_area  && q[10'd334 - hx])
		r <= 8'hFF;		
	else if(j_5_area  && q[10'd350 - hx])
		r <= 8'hFF;		
	else if(j_6_area  && q[10'd366 - hx])
		r <= 8'hFF;	
	else if(j_7_area  && q[10'd382 - hx])
		r <= 8'hFF;	
	else if(j_8_area  && q[10'd399 - hx])
		r <= 8'hFF;
	else if(j_9_area  && q[10'd415 - hx])
		r <= 8'hFF;	
	else if(j_10_area  && q[10'd430 - hx])
		r <= 8'hFF;			
	else if(f1_2_1 && q[10'd67 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_2_2 && q[10'd83 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_0 && q[10'd98 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_1 && q[10'd114 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_2 && q[10'd130 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_3 && q[10'd147 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_4 && q[10'd162 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_5 && q[10'd178 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_6 && q[10'd194 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_7 && q[10'd210- hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_1_8 && q[10'd226 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end
	else if(f1_2_3 && q[10'd242 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f1_2_4 && q[10'd258 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_2_1 && q[10'd67 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_2_2 && q[10'd83 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_0 && q[10'd98 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_1 && q[10'd114 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_2 && q[10'd130 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_3 && q[10'd146 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_4 && q[10'd162 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_5 && q[10'd178 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_1_6 && q[10'd194 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_2_3 && q[10'd210- hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a1_2_4 && q[10'd227 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
   else if(f2_2_1 && q[10'd467 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_2_2 && q[10'd483 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_0 && q[10'd498 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_1 && q[10'd514 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_2 && q[10'd530 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_3 && q[10'd546 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_4 && q[10'd562 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_5 && q[10'd578 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_6 && q[10'd594 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_7 && q[10'd610- hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_1_8 && q[10'd626 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end
	else if(f2_2_3 && q[10'd642 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(f2_2_4 && q[10'd658 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
   else if(a2_2_1 && q[10'd467 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_2_2 && q[10'd482 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_0 && q[10'd498 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_1 && q[10'd514 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_2 && q[10'd530  - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_3 && q[10'd546 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_4 && q[10'd562 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_5 && q[10'd578 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_1_6 && q[10'd594 - hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_2_3 && q[10'd610- hx])
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(a2_2_4 && q[10'd627 - hx])	
		begin  g <= 8'hFF;	 b <= 8'hFF; end 
	else if(x)
		b <= 8'hFF;
	else if(y)
	   r <= 8'hFF;
	else if(x1 && q[10'd108 - hx])
		r <= 8'hFF;
	else if(x2 && q[10'd208 - hx])
		r <= 8'hFF;
	else if(x3 && q[10'd308 - hx])
		r <= 8'hFF;
	else if(x4 && q[10'd408 - hx])
		r <= 8'hFF;
	else if(x5 && q[10'd508 - hx])
		r <= 8'hFF;
	else if(x6 && q[10'd608 - hx])
		r <= 8'hFF;
	else if(x7 && q[10'd708 - hx])
		r <= 8'hFF;	
	else if(vy <7'd64 && hx >=10'd143 && hx< 10'd656 && qt[10'd656 - hx])
		r <= 8'hFF;	
	else if(z1 || z2)
		begin r <= 8'h6F;  g <= 8'h1F;   b <= 8'h6F;   end 
	else 
		begin r <= 8'h0;  g <= 8'h0;   b <= 8'h0;   end 
end
endmodule 