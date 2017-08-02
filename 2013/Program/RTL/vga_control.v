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
	
//	input wire [1:0]		key_state1,
//	input wire [1:0] 		key_state2,
//	input wire [7:0]		vga_data,
//	
//	input wire [9:0]		ad_level,	//触发电平
//	input wire [31:0]     freq,				//频率
//	input wire [9:0]		fuzhi,
	
	input wire [9:0] 		hx,		//vga的行坐标和列坐标
	input wire [9:0] 		vy,
	output wire [23:0] 	RGB

);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	
	

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/**************************************** 背景显示 ************************************************/ 	
	//定义坐标轴显示的位置以及颜色
	wire vgalive;
	
	assign vgalive = (vy >= 10'd200 && vy <= 10'd456)&& (hx <= 10'd300 && hx >= 10'd100);
	
	assign vgalive2 = (vy >= 10'd200 && vy <= 10'd456)&& (hx <= 10'd700 && hx >= 10'd500);
	
	
	//显示虚线的坐标轴
	wire z1 = vgalive && (hx%7'd20 == 1'b0 || hx == 1'b1) && vy%2'd3 == 1'b0;
	wire z2 = vgalive && ((vy - 7'd200)%7'd32 == 1'b0) && hx%2'd3 == 1'b0;
	
	//显示虚线的坐标轴2
	wire z3 = vgalive2 && (hx%7'd20 == 1'b0 || hx == 1'b1) && vy%2'd3 == 1'b0;
	wire z4 = vgalive2 && ((vy - 7'd200)%7'd32 == 1'b0) && hx%2'd3 == 1'b0;
	
	
	/**************************************** 显示地址 ************************************************/
	
	
//	//触发电平数据显示
//	wire f1_1_1  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd558  &&  hx <= 10'd574); // 
//	wire f1_1_2  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd574  &&  hx <= 10'd590);//
//	wire f1_1_3  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd590  &&  hx <= 10'd606);
//	wire f1_1_4  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd606  &&  hx <= 10'd622);
//	wire f1_1_5  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd622  &&  hx <= 10'd638);
//	wire f1_1_6  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd638  &&  hx <= 10'd654);
//	wire f1_1_7  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd654  &&  hx <= 10'd670);
//	wire f1_1_8  =  (vy >= 10'd300 && vy <= 10'd331) && (hx >= 10'd670  &&  hx <= 10'd686);//
	
	
	/**************************************** ROM访问地址 ************************************************/
//	wire  [3:0] f1_1,f1_2,f1_3,f1_4,f1_5,f1_6,f1_7,f1_8;
//	wire  [3:0] f2_1,f2_2,f2_3,f2_4,f2_5,f2_6,f2_7,f2_8;
//	wire  [3:0] p1_1,p1_2,p1_3,p1_4,p1_5,p1_6,p1_7,p1_8;
//	wire  [3:0] a2_1,a2_2,a2_3,a2_4,a2_5,a2_6,a2_7,a2_8;
//	
//	//触发电平的数据
//	assign f1_1 = 1'b0;
//	assign f1_2 = ad_level/1_000_000;
//	assign f1_3 = ad_level/100_000%10;
//	assign f1_4 = ad_level/10_000%10;
//	assign f1_5 = ad_level/1000%10;
//	assign f1_6 = ad_level/100%10;
//	assign f1_7 = ad_level/10%10;
//	assign f1_8 = ad_level%10;
//
//	
//	//测量的频率
//	assign f2_1 = 1'b0;
//	assign f2_2 = freq/1_000_000;
//	assign f2_3 = freq/100_000%10;
//	assign f2_4 = freq/10_000%10;
//	assign f2_5 = freq/1000%10;
//	assign f2_6 = freq/100%10;
//	assign f2_7 = freq/10%10;
//	assign f2_8 = freq%10;
//
//	//测量的幅值
//	assign a2_1 = 1'b0;
//	assign a2_2 = fuzhi/1_000_000;
//	assign a2_3 = fuzhi/100_000%10;
//	assign a2_4 = fuzhi/10_000%10;
//	assign a2_5 = fuzhi/1000%10;
//	assign a2_6 = fuzhi/100%10;
//	assign a2_7 = fuzhi/10%10;
//	assign a2_8 = fuzhi%10;
//
//	
//	always @(posedge clk or negedge rst_n)
//	begin 
//		if(!rst_n) begin 
//			add <= 1'b0;
//			add2 <= 1'b0;
//			add3 <= 1'b0;
//			add4 <= 1'b0;
//			add5 <= 1'b0;
//		end 
//
//			
//		//触发电平数据显示
//		
//		else if(f1_1_1)
//			add <= vy - 10'd300 + {f1_1,5'b0}; 
//		else if(f1_1_2)                       
//			add <= vy - 10'd300 + {f1_2,5'b0}; 
//		else if(f1_1_3)                       
//			add <= vy - 10'd300 + {f1_3,5'b0}; 
//		else if(f1_1_4)                       
//			add <= vy - 10'd300 + {f1_4,5'b0}; 
//		else if(f1_1_5)                       
//			add <= vy - 10'd300 + {f1_5,5'b0}; 
//		else if(f1_1_6)                       
//			add <= vy - 10'd300 + {f1_6,5'b0};
//		else if(f1_1_7)
//			add <= vy - 10'd300 + {f1_7,5'b0};
//		else if(f1_1_8)
//			add <= vy - 10'd300 + {f1_8,5'b0}; 	
//			
//		
//			
//	end 
	
	/**************************************** ROM ************************************************/
	
	wire [575:0] qt;
	wire [255:0] q2;
	
	reg [5:0] tadd;
	reg [9:0] add2;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n) begin 
			tadd <= 1'b0;
			add2 <= 1'b0;
		end 
		else if(vy >0 && vy <7'd64 && hx >=10'd112 && hx<=10'd688)
			tadd <= vy;
		else if(vy >=10'd500 && vy <10'd563 && hx >=10'd136 && hx<=10'd264)
			add2 <= vy; 
		else if(vy >=10'd500 && vy <10'd563 && hx >=10'd264 && hx<=10'd392)
			add2 <= vy; 
		else 
			tadd <= 1'b0;
	end
	
	
	
	rom U5(				//“简易频率特性测试仪”显示
		.address		(tadd),
		.clock		(clk),
		.q				(qt)
	);
	
	rom_title2 U6(				//“幅频特性”+ “相频特性”
		.address		(add2),
		.clock		(clk),
		.q				(q2)
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
		
//		//波形分配
//		else if( vgalive && vga_data == 10'd455 - vy)
//			begin r <= 8'hFF; g <= 8'hd7;    b <= 8'h00; end 
//			
//		//波形分配2
//		else if( vgalive && vga_data == 10'd455 - vy)
//			begin r <= 8'hFF; g <= 8'hd7;    b <= 8'h00; end 
		
		//大标题分配
		else if(vy <7'd64 && hx >=10'd112 && hx< 10'd688 && qt[10'd688 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
		
		//小标题分配
		else if(vy >=10'd500 && vy <10'd563 && hx >=10'd136 && hx< 10'd264 && q2[10'd264 - hx + 10'd128])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 	
			
		//小标题分配2
		else if(vy >=10'd500 && vy <10'd563 && hx >=10'd536 && hx< 10'd664 && q2[10'd664 - hx])
			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 	
		
	
//		//“触发电平”数据分配
//		else if(f1_1_1 && q[10'd574 - hx])				      
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
//		else if(f1_1_2 && q[10'd590 - hx])                 
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
//		else if(f1_1_3 && q[10'd606 - hx])                 
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
//		else if(f1_1_4 && q[10'd622 - hx])                 
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end   
//		else if(f1_1_5 && q[10'd638 - hx])            
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
//		else if(f1_1_6 && q[10'd654 - hx])                    
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
//		else if(f1_1_7 && q[10'd670 - hx])                    
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end     
//		else if(f1_1_8 && q[10'd686- hx])                     
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
//		
//		//“触发电平”单位分配
//		else if(symbol5 && q7[10'd718 - hx])
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end 
//		else if(symbol6 && q7[10'd734 - hx])
//			begin r <= 8'hdc; g <= 8'hdc;	 b <= 8'hdc; end
		
		
		
	                                                    
			
		else if(z1 || z2)
			begin r <= 8'hDE;  g <= 8'hDE;   b <= 8'hDE;   end 
		else if(z3 || z4)
			begin r <= 8'hDE;  g <= 8'hDE;   b <= 8'hDE;   end 
		else 
			begin r <= 8'h0;  g <= 8'h0;   b <= 8'h0;   end 
		

	end 
	
	assign  RGB = {r,g,b};
	
	



endmodule

