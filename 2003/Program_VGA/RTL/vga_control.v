/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				VGA控制部分
* 
* ==================================================================*/

module vga_control(
	
	input wire 				clk,	
	input	wire				rst_n,
	
	input wire [31:0]		born_pinlv,
	input wire [31:0]		born_phase,
	input wire [31:0]    pinlv,
	input wire [31:0]    phrase,
	input wire [9:0] 		hx,		//vga的行坐标和列坐标
	input wire [9:0] 		vy,
	output wire [23:0] 	RGB

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	parameter F1 = 104857;
	
	

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/**************************************** 背景显示 ************************************************/ 	
	//定义坐标轴显示的位置以及颜色
	wire vgalive;
	
	assign vgalive = (vy > 10'd64 && vy <= 10'd500) && (hx <= 10'd800 && hx > 10'd1);
	
	//显示虚线的坐标轴
	wire z1 = vgalive && (hx%7'd50 == 1'b0 || hx == 1'b1) && vy%2'd3 == 1'b0;
	wire z2 = vgalive && ((vy - 7'd64)%7'd50 == 1'b0) && hx%2'd3 == 1'b0;
	
	
	/**************************************** 显示地址 ************************************************/
	//“数字频率测量仪”显示地址
	wire tile_area1 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd176   &&  hx <= 10'd239);//数
	wire tile_area2 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd240   &&  hx <= 10'd303);//字
	wire tile_area3 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd304   &&  hx <= 10'd367);//相
	wire tile_area4 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd368   &&  hx <= 10'd431);//位
	wire tile_area5 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd432   &&  hx <= 10'd495);//测
	wire tile_area6 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd496   &&  hx <= 10'd559);//量
	wire tile_area7 = (vy >= 10'd10 && vy <= 10'd41) && (hx >= 10'd560   &&  hx <= 10'd623);//仪
	
	//“生成波形频率”显示地址
	wire born_signal_area1  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd50   &&  hx <= 10'd81 );
	wire born_signal_area2  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd82   &&  hx <= 10'd113);//冒号
	wire born_signal_area3  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd114  &&  hx <= 10'd145);//25 000 000
	wire born_signal_area4  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd146  &&  hx <= 10'd177);
	wire born_signal_area5  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd178  &&  hx <= 10'd209);
	wire born_signal_area6  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd210  &&  hx <= 10'd241);
	
	//“生成波形”频率显示地址
	wire f1_1_0  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd274  &&  hx <= 10'd289); // :
	wire f1_1_1  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd306  &&  hx <= 10'd321); // 
	wire f1_1_2  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd322  &&  hx <= 10'd337);//
	wire f1_1_3  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd338  &&  hx <= 10'd353);
	wire f1_1_4  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd354  &&  hx <= 10'd369);
	wire f1_1_5  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd370  &&  hx <= 10'd385);
	wire f1_1_6  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd386  &&  hx <= 10'd401);
	wire f1_1_7  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd402  &&  hx <= 10'd417);
	wire f1_1_8  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd418  &&  hx <= 10'd433);//
	wire f1_2_1  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd434  &&  hx <= 10'd449);//h
	wire f1_2_2  =  (vy >= 10'd150 && vy <= 10'd181) && (hx >= 10'd450  &&  hx <= 10'd465);//z
	
	//“生成波形相位差”显示地址
	wire born_phase_area1  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd50   &&  hx <= 10'd81 );
	wire born_phase_area2  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd82   &&  hx <= 10'd113);//25 000 000
	wire born_phase_area3  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd114  &&  hx <= 10'd145);
	wire born_phase_area4  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd146  &&  hx <= 10'd177);
	wire born_phase_area5  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd178  &&  hx <= 10'd209);
	wire born_phase_area6  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd210  &&  hx <= 10'd241);
	wire born_phase_area7  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd242  &&  hx <= 10'd273);


	
	//“生成波形相位差”数字显示地址
	wire p1_1_0  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd274  &&  hx <= 10'd305); // :
	wire p1_1_1  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd306  &&  hx <= 10'd321); // 
	wire p1_1_2  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd322  &&  hx <= 10'd337);//
	wire p1_1_3  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd338  &&  hx <= 10'd353);
	wire p1_1_4  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd354  &&  hx <= 10'd369);
	wire p1_1_5  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd370  &&  hx <= 10'd385);
	wire p1_1_6  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd386  &&  hx <= 10'd401);
	wire p1_1_7  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd402  &&  hx <= 10'd417);
	wire p1_1_8  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd418  &&  hx <= 10'd433);//
	wire p1_2_1  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd434  &&  hx <= 10'd449);//h
	wire p1_2_2  =  (vy >= 10'd200 && vy <= 10'd231) && (hx >= 10'd450  &&  hx <= 10'd465);//z
	
	
	//“频率”显示地址
	wire r_freq_area1  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd178  &&  hx <= 10'd209);//25 000 000
	wire r_freq_area2  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd210  &&  hx <= 10'd241);
	
	//“频率”数字显示地址
	wire f2_1_0  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd274  &&  hx <= 10'd305); // :
	wire f2_1_1  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd306  &&  hx <= 10'd321); // 
	wire f2_1_2  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd322  &&  hx <= 10'd337);//
	wire f2_1_3  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd338  &&  hx <= 10'd353);
	wire f2_1_4  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd354  &&  hx <= 10'd369);
	wire f2_1_5  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd370  &&  hx <= 10'd385);
	wire f2_1_6  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd386  &&  hx <= 10'd401);
	wire f2_1_7  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd402  &&  hx <= 10'd417);
	wire f2_1_8  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd418  &&  hx <= 10'd433);//
	wire f2_2_1  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd434  &&  hx <= 10'd449);//h
	wire f2_2_2  =  (vy >= 10'd250 && vy <= 10'd281) && (hx >= 10'd450  &&  hx <= 10'd465);//z
	
	//“相位差”显示地址
	wire r_phase_area1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd146  &&  hx <= 10'd177);//25 000 000
	wire r_phase_area2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd178  &&  hx <= 10'd209);
	wire r_phase_area3  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd210  &&  hx <= 10'd241);
	
	
	//“相位差”数字显示地址
	wire p2_1_0  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd274  &&  hx <= 10'd305); // :
	wire p2_1_1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd306  &&  hx <= 10'd321); // 
	wire p2_1_2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd322  &&  hx <= 10'd337);//
	wire p2_1_3  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd338  &&  hx <= 10'd353);
	wire p2_1_4  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd354  &&  hx <= 10'd369);
	wire p2_1_5  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd370  &&  hx <= 10'd385);
	wire p2_1_6  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd386  &&  hx <= 10'd401);
	wire p2_1_7  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd402  &&  hx <= 10'd417);
	wire p2_1_8  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd418  &&  hx <= 10'd433);//
	wire p2_2_1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd434  &&  hx <= 10'd449);//h
	wire p2_2_2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd450  &&  hx <= 10'd465);//z
	

	
	
	/**************************************** ROM访问地址 ************************************************/
	wire  [3:0] f1_1,f1_2,f1_3,f1_4,f1_5,f1_6,f1_7,f1_8;
	wire  [3:0] f2_1,f2_2,f2_3,f2_4,f2_5,f2_6,f2_7,f2_8;
	wire  [3:0] p1_1,p1_2,p1_3,p1_4,p1_5,p1_6,p1_7,p1_8;
	wire  [3:0] p2_1,p2_2,p2_3,p2_4,p2_5,p2_6,p2_7,p2_8;
	
	//生成的频率
	assign f1_1 = 1'b0;
	assign f1_2 = born_pinlv/1_000_000;
	assign f1_3 = born_pinlv/100_000%10;
	assign f1_4 = born_pinlv/10_000%10;
	assign f1_5 = born_pinlv/1000%10;
	assign f1_6 = born_pinlv/100%10;
	assign f1_7 = born_pinlv/10%10;
	assign f1_8 = born_pinlv%10;
	
	//生成的相位差
	assign p1_1 = 1'b0;
	assign p1_2 = born_phase/1_000_000;
	assign p1_3 = born_phase/100_000%10;
	assign p1_4 = born_phase/10_000%10;
	assign p1_5 = born_phase/1000%10;
	assign p1_6 = born_phase/100%10;
	assign p1_7 = born_phase/10%10;
	assign p1_8 = born_phase%10;
	
	//测量的频率
	assign f2_1 = 1'b0;
	assign f2_2 = pinlv/1_000_000;
	assign f2_3 = pinlv/100_000%10;
	assign f2_4 = pinlv/10_000%10;
	assign f2_5 = pinlv/1000%10;
	assign f2_6 = pinlv/100%10;
	assign f2_7 = pinlv/10%10;
	assign f2_8 = pinlv%10;
	
	
	//测量的相位差
	assign p2_1 = 1'b0;
	assign p2_2 = phrase/1_000_000;
	assign p2_3 = phrase/100_000%10;
	assign p2_4 = phrase/10_000%10;
	assign p2_5 = phrase/1000%10;
	assign p2_6 = phrase/100%10;
	assign p2_7 = phrase/10%10;
	assign p2_8 = phrase%10;
	
	reg [9:0] add;
	reg [9:0] add2;
	reg [9:0] add3;
	reg [9:0] add4;
	reg [9:0] add5;
	reg [9:0] add6;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			add <= 1'b0;
			add2 <= 1'b0;
			add3 <= 1'b0;
			add4 <= 1'b0;
			add5 <= 1'b0;
		end 
		//标题显示地址
		else if(tile_area1)
			add2 <= vy - 10'd10;
		else if(tile_area2)
			add2 <= vy - 10'd10 + 10'd32;
		else if(tile_area3)      
			add2 <= vy - 10'd10 + 10'd64;	
		else if(tile_area4)      
			add2 <= vy - 10'd10 + 10'd96;	
		else if(tile_area5)      
			add2 <= vy - 10'd10 + 10'd128;	
		else if(tile_area6)      
			add2 <= vy - 10'd10 + 10'd160;	
		else if(tile_area7)      
			add2 <= vy - 10'd10 + 10'd192;
			
		//“生成波形频率”显示地址   
		else if(born_signal_area1)
			add3 <= vy - 10'd150;            
		else if(born_signal_area2)
			add3 <= vy - 10'd150 + 10'd32;   
		else if(born_signal_area3)
			add3 <= vy - 10'd150 + 10'd64;	
		else if(born_signal_area4)
			add3 <= vy - 10'd150 + 10'd96;	
		else if(born_signal_area5)
			add3 <= vy - 10'd150 + 10'd128;	
		else if(born_signal_area6)
			add3 <= vy - 10'd150 + 10'd160;	
	
		//“生成波形频率”的数字位置
		else if(f1_1_0)
			add <= vy - 10'd150 + 10'd24; 
		else if(f1_1_1)
			add <= vy - 10'd150 + {f1_1,5'b0}; 
		else if(f1_1_2)                       
			add <= vy - 10'd150 + {f1_2,5'b0}; 
		else if(f1_1_3)                       
			add <= vy - 10'd150 + {f1_3,5'b0}; 
		else if(f1_1_4)                       
			add <= vy - 10'd150 + {f1_4,5'b0}; 
		else if(f1_1_5)                       
			add <= vy - 10'd150 + {f1_5,5'b0}; 
		else if(f1_1_6)                       
			add <= vy - 10'd150 + {f1_6,5'b0};
		else if(f1_1_7)
			add <= vy - 10'd150 + {f1_7,5'b0};
		else if(f1_1_8)
			add <= vy - 10'd150 + {f1_8,5'b0}; 
		else if(f1_2_1)
			add <= vy - 10'd88;
		else if(f1_2_2)
			add <= vy - 10'd56;
			
		//“生成波形相位差”显示
		else if(born_phase_area1)   
			add4 <= vy - 10'd200; 
		else if(born_phase_area2)
			add4 <= vy - 10'd200 + 10'd32; 
		else if(born_phase_area3)
			add4 <= vy - 10'd200 + 10'd64;
		else if(born_phase_area4)
			add4 <= vy - 10'd200 + 10'd96; 
		else if(born_phase_area5)
			add4 <= vy - 10'd200 + 10'd128; 
		else if(born_phase_area6)
			add4 <= vy - 10'd200 + 10'd160; 
		else if(born_phase_area7)
			add4 <= vy - 10'd200 + 10'd192;
		
		
		//“生成波形相位差”数字显示
		else if(p1_1_0)
			add <= vy - 10'd24; 
		else if(p1_1_1)
			add <= vy - 10'd200 + {p1_1,5'b0}; 
		else if(p1_1_2)                       
			add <= vy - 10'd200 + {p1_2,5'b0}; 
		else if(p1_1_3)                       
			add <= vy - 10'd200 + {p1_3,5'b0}; 
		else if(p1_1_4)                       
			add <= vy - 10'd200 + {p1_4,5'b0}; 
		else if(p1_1_5)                       
			add <= vy - 10'd200 + {p1_5,5'b0}; 
		else if(p1_1_6)                       
			add <= vy - 10'd200 + {p1_6,5'b0};
		else if(p1_1_7)
			add <= vy - 10'd200 + {p1_7,5'b0};
		else if(p1_1_8)
			add <= vy - 10'd200 + {p1_8,5'b0}; 
		else if(p1_2_1)
			add <= vy  - 10'd200- 10'd88;
		else if(p1_2_2)
			add <= vy - 10'd56;
		
		//“频率”显示
		else if(r_freq_area1)
			add5 <= vy - 10'd250; 
		else if(r_freq_area2)
			add5 <= vy - 10'd250 + 10'd32; 

		
		//“频率”数字显示
		else if(f2_1_0)
			add <= vy - 10'd24; 
		else if(f2_1_1)
			add <= vy - 10'd250 + {f2_1,5'b0}; 
		else if(f2_1_2)                       
			add <= vy - 10'd250 + {f2_2,5'b0}; 
		else if(f2_1_3)                       
			add <= vy - 10'd250 + {f2_3,5'b0}; 
		else if(f2_1_4)                       
			add <= vy - 10'd250 + {f2_4,5'b0}; 
		else if(f2_1_5)                       
			add <= vy - 10'd250 + {f2_5,5'b0}; 
		else if(f2_1_6)                       
			add <= vy - 10'd250 + {f2_6,5'b0};
		else if(f2_1_7)
			add <= vy - 10'd250 + {f2_7,5'b0};
		else if(f2_1_8)
			add <= vy - 10'd250 + {f2_8,5'b0}; 
		else if(f2_2_1)
			add <= vy - 10'd250 - 10'd88;
		else if(f2_2_2)
			add <= vy - 10'd250 - 10'd56;
		
		
		//“相位差”显示
		else if(r_phase_area1)
			add6 <= vy - 10'd300; 
		else if(r_phase_area2)
			add6 <= vy - 10'd300 + 10'd32; 
		else if(r_phase_area3)
			add6 <= vy - 10'd300 + 10'd64;

		
		//“相位差”数字显示
		else if(p2_1_0)
			add <= vy - 10'd24; 
		else if(p2_1_1)
			add <= vy - 10'd300 + {p2_1,5'b0}; 
		else if(p2_1_2)                       
			add <= vy - 10'd300 + {p2_2,5'b0}; 
		else if(p2_1_3)                       
			add <= vy - 10'd300 + {p2_3,5'b0}; 
		else if(p2_1_4)                       
			add <= vy - 10'd300 + {p2_4,5'b0}; 
		else if(p2_1_5)                       
			add <= vy - 10'd300 + {p2_5,5'b0}; 
		else if(p2_1_6)                       
			add <= vy - 10'd300 + {p2_6,5'b0};
		else if(p2_1_7)
			add <= vy - 10'd300 + {p2_7,5'b0};
		else if(p2_1_8)
			add <= vy - 10'd300 + {p2_8,5'b0}; 
		else if(p2_2_1)
			add <= vy - 10'd300 - 10'd88;
		else if(p2_2_2)
			add <= vy - 10'd300 - 10'd56;
		
	end
	
	
	
	
	/**************************************** ROM ************************************************/
	wire [15:0] q;
	wire [61:0] q2;
	wire [61:0] q3,q4,q5,q6;
	

	
	rom_title U5(				//大标题
		.address		(add2),
		.clock		(clk),
		.q				(q2)
	);
	
	rom_freq U6(		//“生成波形频率”
		.address		(add3),
		.clock		(clk),
		.q				(q3)
	);
	
	display_rom U7(			//生成波形频率的数字
		.address		(add),
		.clock		(clk),
		.q				(q)
	);
	
	
	rom_phase U10(		//“生成波形相位差”
		.address		(add4),
		.clock		(clk),
		.q				(q4)
	);
	
	phrase_rom U11(		//“相位差”
		.address		(add6),
		.clock		(clk),
		.q				(q5)
	);
	
	freq_rom U12(		//“频率”
		.address		(add5),
		.clock		(clk),
		.q				(q6)
	);
	
	
	
	
	/**************************************** 颜色分配 ************************************************/
	reg [7:0] r,g,b;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			r <= 8'h0;
			g <= 8'h0;
			b <= 8'h0;
		end 
		//标题分配
		else if(tile_area1 && q2[10'd239 - hx])       
			begin  g <= 8'hFF;	 b <= 8'hFF; end      
		else if(tile_area2 && q2[10'd303 - hx])       
			begin  g <= 8'hFF;	 b <= 8'hFF; end      
		else if(tile_area3 && q2[10'd367 - hx])       
			begin  g <= 8'hFF;	 b <= 8'hFF; end      
		else if(tile_area4 && q2[10'd431 - hx])       
			begin  g <= 8'hFF;	 b <= 8'hFF; end      
		else if(tile_area5 && q2[10'd495 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(tile_area6 && q2[10'd559 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end	
		else if(tile_area7 && q2[10'd623 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
 
		//“生成波形频率”分配
		else if(born_signal_area1 && q3[10'd81 - hx])     
			begin  g <= 8'hFF;	 b <= 8'hFF; end          
		else if(born_signal_area2 && q3[10'd113 - hx])    
			begin  g <= 8'hFF;	 b <= 8'hFF; end          
		else if(born_signal_area3 && q3[10'd145 - hx])    
			begin  g <= 8'hFF;	 b <= 8'hFF; end          
		else if(born_signal_area4 && q3[10'd177 - hx])    
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(born_signal_area5 && q3[10'd209 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(born_signal_area6 && q3[10'd241 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end	
		
		
		//“生成波形频率”数据分配
		else if(f1_1_0 && q[10'd3289 - hx])				//  ：
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(f1_1_1 && q[10'd321 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f1_1_2 && q[10'd337 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f1_1_3 && q[10'd353 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f1_1_4 && q[10'd369 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f1_1_5 && q[10'd385 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f1_1_6 && q[10'd401 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f1_1_7 && q[10'd417 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f1_1_8 && q[10'd433- hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f1_2_1 && q[10'd449 - hx])			//单位
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f1_2_2 && q[10'd465 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		
		//“生成波形相位差”分配
		else if(born_phase_area1 && q4[10'd81 - hx])     
			begin  g <= 8'hFF;	 b <= 8'hFF; end         
		else if(born_phase_area2 && q4[10'd113 - hx])    
			begin  g <= 8'hFF;	 b <= 8'hFF; end         
		else if(born_phase_area3 && q4[10'd145 - hx])   
			begin  g <= 8'hFF;	 b <= 8'hFF; end         
		else if(born_phase_area4 && q4[10'd177 - hx])    
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(born_phase_area5 && q4[10'd209 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(born_phase_area6 && q4[10'd241 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(born_phase_area7 && q4[10'd273 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 

		
		//“生成波形相位差”数据分配
		else if(p1_1_0 && q[10'd305 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end   
		else if(p1_1_1 && q[10'd321 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p1_1_2 && q[10'd337 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p1_1_3 && q[10'd353 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p1_1_4 && q[10'd369 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p1_1_5 && q[10'd385 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p1_1_6 && q[10'd401 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p1_1_7 && q[10'd417 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p1_1_8 && q[10'd433- hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p1_2_1 && q[10'd449 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p1_2_2 && q[10'd465 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		
		
		//“频率”分配
		else if(r_freq_area1 && q6[10'd209 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(r_freq_area2 && q6[10'd241 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
	
		
		//“频率”数据分配
		else if(f2_1_0 && q[10'd305 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(f2_1_1 && q[10'd321 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f2_1_2 && q[10'd337 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f2_1_3 && q[10'd353 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f2_1_4 && q[10'd369 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f2_1_5 && q[10'd385 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(f2_1_6 && q[10'd401 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f2_1_7 && q[10'd417 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f2_1_8 && q[10'd433- hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f2_2_1 && q[10'd449 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(f2_2_2 && q[10'd465 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		
		//“相位差”分配
		else if(r_phase_area1 && q5[10'd177 - hx]) 
			begin  g <= 8'hFF;	 b <= 8'hFF; end   
		else if(r_phase_area2 && q5[10'd209 - hx]) 
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(r_phase_area3 && q5[10'd241 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 

		
		//“相位差”数据分配
		else if(p2_1_0 && q[10'd305 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		else if(p2_1_1 && q[10'd321 - hx])				
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p2_1_2 && q[10'd337 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p2_1_3 && q[10'd353 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p2_1_4 && q[10'd369 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p2_1_5 && q[10'd385 - hx])           
			begin  g <= 8'hFF;	 b <= 8'hFF; end     
		else if(p2_1_6 && q[10'd401 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p2_1_7 && q[10'd417 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p2_1_8 && q[10'd433- hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p2_2_1 && q[10'd449 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end 
		else if(p2_2_2 && q[10'd465 - hx])
			begin  g <= 8'hFF;	 b <= 8'hFF; end
		
		
		else if(z1 || z2)
			begin r <= 8'h6F;  g <= 8'h1F;   b <= 8'h6F;   end 
		else 
			begin r <= 8'h0;  g <= 8'h0;   b <= 8'h0;   end 
		

	end 
	

	
	assign  RGB = {r,g,b};
	
	



endmodule

