module HMC830(clk,rst_n,LD_SDO,
SDI,SCK,SEN,data_in,hang_pose,
key_value,key_pluse,key_pluse1,
CNT,flag,flag1,int_frac_data
);
input clk ,rst_n;
input LD_SDO;

input[3:0] key_value;
input [3:0] hang_pose;
input [20:0] CNT;
input key_pluse;
input key_pluse1;
input [31:0] int_frac_data;
input flag;
output flag1;
//input [6:0] addr;
output [23:0] data_in;
output SDI,SCK,SEN;
reg SDI,SEN;

reg flag1;
always@(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		flag1 <= 1'b0;
	else if(cnt==CNT)
		flag1 <= 1'b1;
	else 
		flag1 <= 1'b0;
end 

	


// ***************状态机写寄存器********************		 
parameter a0=0,a1=1,a2=2,a3=3,a4=4,a5=5,a6=6,a7=7,a8=8,a9=9,	
			  a10=10,a11=11,a12=12,a13=13,a14=14,a15=15,a16=16,
			  a17=17,a18=18,a19=19,a20=20,a21=21,a22=22,a23=23;
reg [4:0] nstate/*synthesis noprune*/;

reg wr;//读写是能
reg write_ok;
reg [7:0] cnt_r;

reg [20:0] cnt;
reg [31:0] reg_data;
reg SEN_R;
always@(posedge clk or negedge rst_n)
if(!rst_n)
	begin 
		wr <= 1'b1; 
		nstate <= a21;
		cnt_r <= 1'b0;
		cnt <= 21'd0;
		//SEN_R <= 1'b1;
	end 
else 
	begin 	
			case(nstate)	
				a21:
					if(cnt_r==8'hFF)
						begin 
							cnt_r <= 1'b0;
							nstate <= a0;
							SEN_R <= 1'b1;
						end 	
					else 
						begin 
							cnt_r <= cnt_r + 1'b1;
							SEN_R <= 1'b0;
							nstate <= a21;
						end 

				a0:
					begin 
						if(write_ok)
							begin 
							SEN_R <= 1'b0;
							reg_data <= 32'h02000001;//Reg 02h R=1;
							nstate <= a1;
							end 
						else 
							begin 
								SEN_R <= 1'b1;
								nstate <= a0;
							end 
					end 
				a1:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h06200B4A;//默认值初始化数值
								nstate <= a2;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a1;
							end 
					end 
				a2:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h070008CD;
								nstate <= a3;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a2;
							end 
					end 
				a3:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h08C1BEFF;// 写入初始化数值
								nstate <= a4;
							end 
						else
							begin
								SEN_R	<= 1'b1;
								nstate <= a3;
							end 
					end 
				a4:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h09403264;//初始化数值
								nstate <= a5;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a4;
							end 
					end 
				a5:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h0A002046;
								nstate <= a6;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a5;
							end 
					end 

				a6:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h0F0000C1;//reg_data <= 32'h0F0000A1;
								nstate <= a7;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a6;
							end 
					end 
				a7:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h05000F88;//vco_reg01
								nstate <= a8;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a7;
							end 
					end 
				a8:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= {8'h05,9'h0,2'h3,6'h1C/*K=40*/,7'h10}; //vco_reg02  reg_data <= {8'h5,11'h3,6'h1/*K*/,7'h10};
								nstate <= a9;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a8;
							end 
					end 
				a9:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h05002A18;//vco_reg03 reg_data <= 32'h05002A98;
								nstate <= a10;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a9;
							end 
					end 
				a10:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h05001628;//vco_reg05
								nstate <= a11;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a10;
							end 
					end 
				a11:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h050060A0;//vco_reg04
								nstate <= a12;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a11;
							end 
					end 
				a12:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h05000000;//开启自动校正功能，更改频率只需改变reg03 ，REG04；
								nstate <= a13;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a12;
							end 
					end 
				a13:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= {8'h03,16'h0,int_frac_data[31:24]};//int 整数部分int=25
								nstate <= a14;
							end 
								else
									begin
										SEN_R <= 1'b1; 
										nstate <= a13;
									end 
					end 
				a14:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= {8'h04,int_frac_data[23:0]};//小数部分
								nstate <= a15;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a14;
							end 
					end 
				a15:
					begin 
						if(write_ok)
							begin 
								SEN_R <= 1'b0;
								reg_data <= 32'h05000000;
								//wr <= 1'b0;//读使能
								nstate <= a16;
							end 
						else
							begin
								SEN_R <= 1'b1;
								nstate <= a15;
							end 
					end 
				a16:
					begin 
						if(key_pluse)
							begin 
								if(cnt==CNT)
									begin 
										cnt <= 1'b0;
										nstate <= a13;
									end 
								else 
									cnt <= cnt + 1'b1;
							end 
						else if(key_pluse1 && flag)
							nstate <= a13;
							
					end 
					
			
//				a17:
//					begin 
//						if(write_ok)
//							begin 
//								SEN_R <= 1'b0;
//								reg_data <= {8'h03,18'h0,int_frac_data[29:24]};//int 整数部分int=25
//								nstate <= a18;
//							end 
//						else
//							begin
//								SEN_R <= 1'b1; 
//								nstate <= a17;
//							end 
//					end 
//				a18:
//					begin 
//						if(write_ok)
//							begin 
//								SEN_R <= 1'b0;
//								reg_data <= {8'h04,int_frac_data[23:0]};//小数部分
//								nstate <= a19;
//							end 
//						else
//							begin
//								SEN_R <= 1'b1;
//								nstate <= a18;
//							end 
//					end 
//				a19:
//					begin 
//						if(write_ok)
//							begin 
//								SEN_R <= 1'b0;
//								reg_data <= 32'h05000000;
//								//wr <= 1'b0;//读使能
//								nstate <= a16;
//							end 
//						else
//							begin
//								SEN_R <= 1'b1;
//								nstate <= a19;
//							end 
//					
//					end 
				default:;
			endcase
	end 
//******************结束******************	


// *********写数据的状态机**************
reg [6:0] next_state;
parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,
			 s7=7,s8=8,s9=9,s10=10,s11=11,s12=12,s13=13,
			 s14=14,s15=15,s16=16,s17=17,s18=18,s19=19,s20=20,
			 s21=21,s22=22,s23=23,s24=24,s25=25,s26=26,
			 s27=27,s28=28,s29=29,s30=30,s31=31,s32=32,s33=33,
			 s34=34,s35=35,s36=36,s37=37,s38=38,s39=39,s40=40,
			 s41=41,s42=42,s43=43,s44=44,s45=45,s46=46,s47=47,s48=48,s49=49,s50=50,
			 s51=51,s52=52,s53=53,s54=54,s55=55,s56=56,s57=57,s58=58,s59=59,s60=60,
			 s61=61,s62=62,s63=63,s64=64,s65=65,s66=66,s67=67,s68=68,s69=69,s70=70;

			 
//***********读数据状态机***********
reg [6:0] next_st;
parameter r0=0,r1=1,r2=2,r3=3,r4=4,r5=5,r6=6,r7=7,r8=8,r9=9,
			 r10=10,r11=11,r12=12,r13=13,r14=14,r15=15,
			 r16=16,r17=17,r18=18,r19=19,r20=20,r21=21,r22=22,
			 r23=23,r24=24,r25=25,r26=26,r27=27,r28=28,r29=29,
			 r30=30,r31=31,r32=32,r33=33,r34=34,r35=35,r36=36,r37=37,r38=38,r39=39,
			 r40=40,r41=41,r42=42,r43=43,r44=44,r45=45,r46=46,r47=47,r48=48,r49=49,
			 r50=50,r51=51,r52=52,r53=53,r54=54,r55=55,r56=56,r57=57,r58=58,r59=59,
			 r60=60,r61=61,r62=62,r63=63,r64=64,r65=65,r66=66,r67=67,r68=68,r69=69;
//*******************************************

reg [23:0] data_in_r; 
reg SCK;
always@(posedge clk or negedge rst_n)
if(!rst_n)
	begin 
		next_state <= s0;
		next_st <= r0;
		write_ok <= 1'b0;
		SEN <= 1'b0;
	end 
			
else if(wr==1'b1)//写寄存器
	begin 
		 case(next_state)
				s0:  
						begin
							//SCK <= 1'b0;
							write_ok <= 1'b0;
							next_state <= s1;
							SDI <= 1'b0;
						end
				s1: 
					if(SEN_R)
						begin
						 SCK <= 1'b0;
						 next_state <= s2;
						 SDI <= 1'b0;
						 SEN <= 1'b1;
						end
					else 
						next_state <= s1;
				
				s2:
					begin 
						SCK <= 1'b1;
						next_state <= s3;
					end 
				s3: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s4;
						 SDI <= reg_data[29];
						end
				s4:
					begin 
						SCK <= 1'b1;
						next_state <= s5;
					end
				s5: 
						begin
						 SCK <= 1'b0;
						 next_state <= s6;
						 SDI <= reg_data[28];
						end
				
				s6:
					begin 
						SCK <= 1'b1;
						next_state <= s7;
					end 
				s7: 
						begin
						 SCK <= 1'b0;
						 next_state <= s8;
						 SDI <= reg_data[27];
						end
				s8:
					begin 
						SCK <= 1'b1;
						next_state <= s9;
					end 
				s9: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s10;
						 SDI <= reg_data[26];
						end
					
				s10:
					begin 
						SCK <= 1'b1;
						next_state <= s11;
					end
				s11: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s12;
						 SDI <= reg_data[25];
						end
					
				
				s12:
					begin 
						SCK <= 1'b1;
						next_state <= s13;
					end 
				s13: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s14;
						 SDI <= reg_data[24];
						end
					
				s14:
					begin 
						SCK <= 1'b1;
						next_state <= s15;
					end 
				
				s15: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s16;
						 SDI <= reg_data[23];
						end
					
				
				s16:
					begin 
						SCK <= 1'b1;
						next_state <= s17;
					end 
				s17: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s18;
						 SDI <= reg_data[22];
						end
				
				s18:
					begin 
						SCK <= 1'b1;
						next_state <= s19;
					end 
				s19: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s20;
						 SDI <= reg_data[21];
						end
					
				s20:
					begin 
						SCK <= 1'b1;
						next_state <= s21;
					end	
				s21: 
					
						begin
						 SCK <= 1'b0;
						 next_state <=s22;
						 SDI <= reg_data[20];
						end
					
				
				s22:
					begin 
						SCK <= 1'b1;
						next_state <= s23;
					end 
				s23: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s24;
						 SDI <= reg_data[19];
						end
					
				s24:
					begin 
						SCK <= 1'b1;
						next_state <= s25;
					end
				s25: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s26;
						 SDI <= reg_data[18];
						end
					
				
				s26:
					begin 
						SCK <= 1'b1;
						next_state <= s27;
					end 
				s27: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s28;
						 SDI <= reg_data[17];
						end
					
				s28:
					begin 
						SCK <= 1'b1;
						next_state <= s29;
					end 
				s29: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s30;
						 SDI <= reg_data[16];
						end
					
				s30:
					begin 
						SCK <= 1'b1;
						next_state <= s31;
					end
				s31: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s32;
						 SDI <= reg_data[15];
						end
					
				
				s32:
					begin 
						SCK <= 1'b1;
						next_state <= s33;
					end 
				s33: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s34;
						 SDI <= reg_data[14];
						end
					
				s34:
					begin 
						SCK <= 1'b1;
						next_state <= s35;
					end 
				
				s35: 
				
						begin
						 SCK <= 1'b0;
						 next_state <= s36;
						 SDI <= reg_data[13];
						end
					
				
				s36:
					begin 
						SCK <= 1'b1;
						next_state <= s37;
					end 
				s37: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s38;
						 SDI <= reg_data[12];
						end
					
				s38:
					begin 
						SCK <= 1'b1;
						next_state <= s39;
					end 
				s39: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s40;
						 SDI <= reg_data[11];
						end
				s40:
					begin 
						SCK <= 1'b1;
						next_state <= s41;
					end	
				s41: 
					
						begin
						 SCK <= 1'b0;
						 next_state <=s42;
						 SDI <= reg_data[10];
						end
					
				s42:
					begin 
						SCK <= 1'b1;
						next_state <= s43;
					end 
				s43: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s44;
						 SDI <= reg_data[9];
						end
				
				s44:
					begin 
						SCK <= 1'b1;
						next_state <= s45;
					end
				s45: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s46;
						 SDI <= reg_data[8];
						end
			
				
				s46:
					begin 
						SCK <= 1'b1;
						next_state <= s47;
					end 
				s47: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s48;
						 SDI <= reg_data[7];
						end
		
				s48:
					begin 
						SCK <= 1'b1;
						next_state <= s49;
					end 
				s49: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s50;
						 SDI <= reg_data[6];
						end
				
				s50:
					begin 
						SCK <= 1'b1;
						next_state <= s51;
					end
				s51: 
				
						begin
						 SCK <= 1'b0;
						 next_state <= s52;
						 SDI <= reg_data[5];
						end
				
				s52:
					begin 
						SCK <= 1'b1;
						next_state <= s53;
					end 
				s53: 
						begin
						 SCK <= 1'b0;
						 next_state <= s54;
						 SDI <= reg_data[4];
						end
				s54:
					begin 
						SCK <= 1'b1;
						next_state <= s55;
					end 
				
				s55: 
						begin
						 SCK <= 1'b0;
						 next_state <= s56;
						 SDI <= reg_data[3];
						end
				
				s56:
					begin 
						SCK <= 1'b1;
						next_state <= s57;
					end 
				s57: 
						begin
						 SCK <= 1'b0;
						 next_state <= s58;
						 SDI <= reg_data[2];
						end
				s58:
					begin 
						SCK <= 1'b1;
						next_state <= s59;
					end 
				s59: 
				
						begin
						 SCK <= 1'b0;
						 next_state <= s60;
						 SDI <= reg_data[1];
						end
					
				s60:
					begin 
						SCK <= 1'b1;
						next_state <= s61;
					end
				s61: 
					
						begin
						 SCK <= 1'b0;
						 next_state <= s62;
						 SDI <= reg_data[0];
						end
					
				s62:
					begin 
						SCK <= 1'b1;
						next_state <= s63;
					end 
				s63:
					begin 
						SCK <= 1'b0;
						next_state <= s64;
						SDI <= 1'b0;
						//SEN <= 1'b0;
					end 
				s64:
					begin
						SCK <= 1'b1;
						next_state <= s65;
						
						//SEN <= 1'b0;
					end 
				s65:
					begin 
						SCK <= 1'b0;
						next_state <= s66;
						SEN <= 1'b0;
					end 
				s66:
					begin 
						SCK <= 1'b0;
						next_state <= s67;
						SEN <= 1'b0;
					end 
				s67:
					begin 
						SCK <= 1'b0;
						next_state <= s0;
						write_ok <= 1'b1;
						SEN <= 1'b0;
					end 
					
				
						
				
				default:;
			endcase
	end 
else //读出寄存器
	begin
		case(next_st)
			r0:
				begin 
					write_ok <= 1'b0;
					next_st <= r1;
				end 
			r1:
				if(SEN_R)
					begin 
						SCK <= 1'b0;
						SEN <= 1'b1;
						SDI <= 1'b1;
						next_st <= r2;
					end 
				else 
					next_st <= r1;
			r2:
				begin 
					SCK <= 1'b1;
					next_st <= r3;
				end 
			r3:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r4;
				end 
			r4:
				begin 
					SCK <= 1'b1;
					next_st <= r5;
				end 
			r5:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r6;
				end 
			r6:
				begin 
					SCK <= 1'b1;
					next_st <= r7;
				end 
			r7:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r8;
				end 
			r8:
				begin 
					SCK <= 1'b1;
					next_st <= r9;
				end 
			r9:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r10;
				end 
			r10:
				begin 
					SCK <= 1'b1;
					next_st <= r11;
				end 
			r11:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b1;
					next_st <= r12;
				end 
			r12:
				begin 
					SCK <= 1'b1;
					next_st <= r13;
				end 
			r13:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r14;
				end 
			r14:
				begin 
					SCK <= 1'b1;
					next_st <= r15;
				end 
			r15:
				begin 
					SCK <= 1'b0;
					next_st <= r16;
				end 
			r16:
				begin 
					SCK <= 1'b1;
					next_st <= r17;
				end 
			r17:
				begin 
					SCK <= 1'b0;
					data_in_r[23] <= LD_SDO;
					next_st <= r18;
				end 
			r18:
				begin
					SCK <= 1'b1;
					next_st <= r19;
				end 
			r19:
				begin 
					SCK <= 1'b0;
					data_in_r[22] <= LD_SDO;
					next_st <= r20;
				end 
			r20:
				begin
					SCK <= 1'b1;
					next_st <= r21;
				end 
			r21:
				begin 
					SCK <= 1'b0;
					data_in_r[21] <= LD_SDO;
					next_st <= r22;
				end 
			r22:
				begin
					SCK <= 1'b1;
					next_st <= r23;
				end 
			r23:
				begin 
					SCK <= 1'b0;
					data_in_r[20] <= LD_SDO;
					next_st <= r24;
				end 
			r24:
				begin
					SCK <= 1'b1;
					next_st <= r25;
				end 
			r25:
				begin 
					SCK <= 1'b0;
					data_in_r[19] <= LD_SDO;
					next_st <= r26;
				end 
			r26:
				begin
					SCK <= 1'b1;
					next_st <= r27;
				end 
			r27:
				begin 
					SCK <= 1'b0;
					data_in_r[18] <= LD_SDO;
					next_st <= r28;
				end 
			r28:
				begin
					SCK <= 1'b1;
					next_st <= r29;
				end 
			r29:
				begin 
					SCK <= 1'b0;
					data_in_r[17] <= LD_SDO;
					next_st <= r30;
				end 
			r30:
				begin
					SCK <= 1'b1;
					next_st <= r31;
				end 
			r31:
				begin 
					SCK <= 1'b0;
					data_in_r[16] <= LD_SDO;
					next_st <= r32;
				end 
			r32:
				begin
					SCK <= 1'b1;
					next_st <= r33;
				end 
			r33:
				begin 
					SCK <= 1'b0;
					data_in_r[15] <= LD_SDO;
					next_st <= r34;
				end 
			r34:
				begin
					SCK <= 1'b1;
					next_st <= r35;
				end 
			r35:
				begin 
					SCK <= 1'b0;
					data_in_r[14] <= LD_SDO;
					next_st <= r36;
				end 
			r36:
				begin
					SCK <= 1'b1;
					next_st <= r37;
				end 
			r37:
				begin 
					SCK <= 1'b0;
					data_in_r[13] <= LD_SDO;
					next_st <= r38;
				end 
			r38:
				begin
					SCK <= 1'b1;
					next_st <= r39;
				end 
			r39:
				begin 
					SCK <= 1'b0;
					data_in_r[12] <= LD_SDO;
					next_st <= r40;
				end 
			r40:
				begin
					SCK <= 1'b1;
					next_st <= r41;
				end 
			r41:
				begin 
					SCK <= 1'b0;
					data_in_r[11] <= LD_SDO;
					next_st <= r42;
				end 
			r42:
				begin
					SCK <= 1'b1;
					next_st <= r43;
				end 
			r43:
				begin 
					SCK <= 1'b0;
					data_in_r[10] <= LD_SDO;
					next_st <= r44;
				end 
			r44:
				begin
					SCK <= 1'b1;
					next_st <= r45;
				end 
			r45:
				begin 
					SCK <= 1'b0;
					data_in_r[9] <= LD_SDO;
					next_st <= r46;
				end 
			r46:
				begin
					SCK <= 1'b1;
					next_st <= r47;
				end 
			r47:
				begin 
					SCK <= 1'b0;
					data_in_r[8] <= LD_SDO;
					next_st <= r48;
				end 
			r48:
				begin
					SCK <= 1'b1;
					next_st <= r49;
				end 
			r49:
				begin 
					SCK <= 1'b0;
					data_in_r[7] <= LD_SDO;
					next_st <= r50;
				end 
			r50:
				begin
					SCK <= 1'b1;
					next_st <= r51;
				end 
			r51:
				begin 
					SCK <= 1'b0;
					data_in_r[6] <= LD_SDO;
					next_st <= r52;
				end 
			r52:
				begin
					SCK <= 1'b1;
					next_st <= r53;
				end 
			r53:
				begin 
					SCK <= 1'b0;
					data_in_r[5] <= LD_SDO;
					next_st <= r54;
				end 
			r54:
				begin
					SCK <= 1'b1;
					next_st <= r55;
				end 
			r55:
				begin 
					SCK <= 1'b0;
					data_in_r[4] <= LD_SDO;
					next_st <= r56;
				end 
			r56:
				begin
					SCK <= 1'b1;
					next_st <= r57;
				end 
			r57:
				begin 
					SCK <= 1'b0;
					data_in_r[3] <= LD_SDO;
					next_st <= r58;
				end 
			r58:
				begin
					SCK <= 1'b1;
					next_st <= r59;
				end 
			r59:
				begin 
					SCK <= 1'b0;
					data_in_r[2] <= LD_SDO;
					next_st <= r60;
				end 
			r60:
				begin
					SCK <= 1'b1;
					next_st <= r61;
				end 
			r61:
				begin 
					SCK <= 1'b0;
					data_in_r[1] <= LD_SDO;
					next_st <= r62;
				end 
			r62:
				begin
					SCK <= 1'b1;
					next_st <= r63;
				end 
			r63:
				begin 
					SCK <= 1'b0;
					data_in_r[0] <= LD_SDO;
					next_st <= r64;
				end 
			r64:
				begin
					SCK <= 1'b1;
					next_st <= r65;
				end
			r65:
				begin 
					SCK <= 1'b0;
					SDI <= 1'b0;
					next_st <= r66;
				end 
			r66:
				begin 
					next_st <= 67;
					SCK <= 1'b1;
				end 
			r67:
				begin
					next_st <= r0;
					write_ok <= 1'b1;
				end 
			default:;
		   endcase 
   	end 
		
assign data_in=data_in_r;	
//*****************************************										
endmodule						
						
				
					
						
						
						
			
				
			


		

