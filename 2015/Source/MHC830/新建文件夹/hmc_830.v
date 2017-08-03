module hmc_830(
			clk,rst,
			SDO,
			SCK,SDI,SEN,
			data_in
			);

input clk;		
input rst;	
input SDO;

output reg SCK,SDI,SEN;	

reg[19:0] cnt;
reg[3:0] sta_cmd;
reg spi_en;
reg[31:0] data_out;
always@(posedge clk or negedge rst)
begin                          
	if(!rst)
	begin
		sta_cmd<=4'd0;
		cnt<=20'd0;
		spi_en<=1'b0;
		data_out<=32'd0;
		wr<=1'b1;
	end
	else 
		case(sta_cmd)
			
			4'd0	:	begin
							if(cnt==20'hFFFFF)
							begin
								cnt<=20'd0;
								sta_cmd<=4'd1;
								spi_en<=1'b1;
							end
							else 
							begin
								cnt<=cnt+1'b1;
								spi_en<=1'b0;
							end
						end
			
			4'd1	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd14;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h02000001;//R
							end
						end
		
			4'd2	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd3;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h06200B4A;
							end
						end
			
			4'd3	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd4;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h070008CD;
							end
						end
						
			4'd4	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd5;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h08C1BEFF;
							end
						end
						
			4'd5	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd6;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h09403264;
							end
						end
						
			4'd6	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd7;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0A002046;
							end
						end
						
			4'd7	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd8;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0F0000A1;
							end
						end
						
			4'd8	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd9;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05000F88;
							end
						end
						
			4'd9	:	8'hbegin
							if(spi_rdy)
							begin
								sta_cmd<=4'd10;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<={8'h5,11'h3,6'h26/*K*/,7'h10}; 
							end
						end
						
			4'd10	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd11;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05002A98;
							end
						end
			
			4'd11	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd12;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05001628;
							end
						end
			
			4'd12	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd13;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h050060A0;
							end
						end
						
			4'd13	:	begin //配置***********************
							if(spi_rdy)
							begin
								sta_cmd<=4'd14;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05000000;
							end
						end
			
			4'd14	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd15;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h03000019;//int
							end
						end
						
			4'd15	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd15;
								wr<=1'b0;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b1;
								data_out<=32'h04000000;//frac 配置***********************
							end
						end

			default:	;
			
		endcase
	/*	
	else 
		case(sta_cmd)
			
			4'd0	:	begin
							if(cnt==20'hFFFFF)
							begin
								cnt<=20'd0;
								sta_cmd<=4'd1;
								spi_en<=1'b1;
							end
							else 
							begin
								cnt<=cnt+1'b1;
								spi_en<=1'b0;
							end
						end
			
			4'd1	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd2;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h02000001;//R
							end
						end
		
			4'd2	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd3;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h06203B4A;
							end
						end
			
			4'd3	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd4;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h070008CD;
							end
						end
						
			4'd4	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd5;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h08C1BEFF;
							end
						end
						
			4'd5	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd6;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h095AB264;
							end
						end
						
			4'd6	:	begin
							if(spi_rdy) 
							begin
								sta_cmd<=4'd7;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0A002046;
							end
						end
						
			4'd7	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd10;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0F000081;
							end
						end
						
			4'd10	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd11;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05001628;
							end
						end
			
			4'd11	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd12;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h050060A0;
							end
						end
			
			4'd12	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd13;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0500E090;
							end
						end
						
			4'd13	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd14;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h05000000;
							end
						end
			
			4'd14	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd15;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b0;
								data_out<=32'h0300001E;//int
							end
						end
						
			4'd15	:	begin
							if(spi_rdy)
							begin
								sta_cmd<=4'd15;
								wr<=1'b0;
								spi_en<=1'b1;
							end
							else
							begin
								spi_en<=1'b1;
								data_out<=32'h04000000;//frac
							end
						end

			default:	;
			
		endcase
		*/
end

reg wr;
reg[7:0] count;
reg spi_rdy;
output reg [23:0] data_in;
reg [6:0] sta_tim,sta_tim_r;
always @(posedge clk or negedge rst) 
begin
	if(!rst) 
	begin
		sta_tim<=7'd0;
		sta_tim_r<=7'd0;
		SCK<=1'b0;
		SDI<=1'b0;
		SEN<=1'b0;
		spi_rdy<=1'b0;
		count<=8'd0;
	end
	else if(wr==1'b1)
		case(sta_tim)
			
			7'd0	:	begin
							sta_tim<=7'd1;
							SCK<=1'b0;
							SDI<=1'b0;
							SEN<=1'b0;
						end
						
			7'd1	:	begin
							if(spi_en)
							begin
								sta_tim<=7'd2;
							end
							else
							begin
								sta_tim<=7'd1;
								spi_rdy<=1'b0;
							end
						end
						
			7'd2	:	begin
							sta_tim<=7'd3;
							SEN<=1'b1;
							SDI<=1'b0;
						end
			
			7'd3	:	begin
							sta_tim<=7'd4;
							SCK<=1'b1;
						end
			
			7'd4	:	begin
							sta_tim<=7'd5;
							SCK<=1'b0;
							SDI<=data_out[29];
						end
			
			7'd5	:	begin
							sta_tim<=7'd6;
							SCK<=1'b1;
						end
			
			7'd6	:	begin
							sta_tim<=7'd7;
							SCK<=1'b0;
							SDI<=data_out[28];
						end
						
			7'd7	:	begin
							sta_tim<=7'd8;
							SCK<=1'b1;
						end
			
			7'd8	:	begin
							sta_tim<=7'd9;
							SCK<=1'b0;
							SDI<=data_out[27];
						end
						
			7'd9	:	begin
							sta_tim<=7'd10;
							SCK<=1'b1;
						end
			
			7'd10	:	begin
							sta_tim<=7'd11;
							SCK<=1'b0;
							SDI<=data_out[26];
						end
						
			7'd11	:	begin
							sta_tim<=7'd12;
							SCK<=1'b1;
						end
			
			7'd12	:	begin
							sta_tim<=7'd13;
							SCK<=1'b0;
							SDI<=data_out[25];
						end
						
			7'd13	:	begin
							sta_tim<=7'd14;
							SCK<=1'b1;
						end
			
			7'd14	:	begin
							sta_tim<=7'd15;
							SCK<=1'b0;
							SDI<=data_out[24];
						end
						
			7'd15	:	begin
							sta_tim<=7'd16;
							SCK<=1'b1;
						end
			
			7'd16	:	begin
							sta_tim<=7'd17;
							SCK<=1'b0;
							SDI<=data_out[23];
						end
						
			7'd17	:	begin
							sta_tim<=7'd18;
							SCK<=1'b1;
						end
			
			7'd18	:	begin
							sta_tim<=7'd19;
							SCK<=1'b0;
							SDI<=data_out[22];
						end
						
			7'd19	:	begin
							sta_tim<=7'd20;
							SCK<=1'b1;
						end
			
			7'd20	:	begin
							sta_tim<=7'd21;
							SCK<=1'b0;
							SDI<=data_out[21];
						end
						
			7'd21	:	begin
							sta_tim<=7'd22;
							SCK<=1'b1;
						end
			
			7'd22	:	begin
							sta_tim<=7'd23;
							SCK<=1'b0;
							SDI<=data_out[20];
						end
						
			7'd23	:	begin
							sta_tim<=7'd24;
							SCK<=1'b1;
						end
			
			7'd24	:	begin
							sta_tim<=7'd25;
							SCK<=1'b0;
							SDI<=data_out[19];
						end
						
			7'd25	:	begin
							sta_tim<=7'd26;
							SCK<=1'b1;
						end
			
			7'd26	:	begin
							sta_tim<=7'd27;
							SCK<=1'b0;
							SDI<=data_out[18];
						end
						
			7'd27	:	begin
							sta_tim<=7'd28;
							SCK<=1'b1;
						end
			
			7'd28	:	begin
							sta_tim<=7'd29;
							SCK<=1'b0;
							SDI<=data_out[17];
						end
			
			7'd29	:	begin
							sta_tim<=7'd30;
							SCK<=1'b1;
						end
			
			7'd30	:	begin
							sta_tim<=7'd31;
							SCK<=1'b0;
							SDI<=data_out[16];
						end
						
			7'd31	:	begin
							sta_tim<=7'd32;
							SCK<=1'b1;
						end
			
			7'd32	:	begin
							sta_tim<=7'd33;
							SCK<=1'b0;
							SDI<=data_out[15];
						end
						
			7'd33	:	begin
							sta_tim<=7'd34;
							SCK<=1'b1;
						end
			
			7'd34	:	begin
							sta_tim<=7'd35;
							SCK<=1'b0;
							SDI<=data_out[14];
						end
						
			7'd35	:	begin
							sta_tim<=7'd36;
							SCK<=1'b1;
						end
			
			7'd36	:	begin
							sta_tim<=7'd37;
							SCK<=1'b0;
							SDI<=data_out[13];
						end
						
			7'd37	:	begin
							sta_tim<=7'd38;
							SCK<=1'b1;
						end
			
			7'd38	:	begin
							sta_tim<=7'd39;
							SCK<=1'b0;
							SDI<=data_out[12];
						end
			
			7'd39	:	begin
							sta_tim<=7'd40;
							SCK<=1'b1;
						end
			
			7'd40	:	begin
							sta_tim<=7'd41;
							SCK<=1'b0;
							SDI<=data_out[11];
						end
			
			7'd41	:	begin
							sta_tim<=7'd42;
							SCK<=1'b1;
						end
			
			7'd42	:	begin
							sta_tim<=7'd43;
							SCK<=1'b0;
							SDI<=data_out[10];
						end
						
			7'd43	:	begin
							sta_tim<=7'd44;
							SCK<=1'b1;
						end
			
			7'd44	:	begin
							sta_tim<=7'd45;
							SCK<=1'b0;
							SDI<=data_out[9];
						end
						
			7'd45	:	begin
							sta_tim<=7'd46;
							SCK<=1'b1;
						end
			
			7'd46	:	begin
							sta_tim<=7'd47;
							SCK<=1'b0;
							SDI<=data_out[8];
						end
						
			7'd47	:	begin
							sta_tim<=7'd48;
							SCK<=1'b1;
						end
			
			7'd48	:	begin
							sta_tim<=7'd49;
							SCK<=1'b0;
							SDI<=data_out[7];
						end
			
			7'd49	:	begin
							sta_tim<=7'd50;
							SCK<=1'b1;
						end
			
			7'd50	:	begin
							sta_tim<=7'd51;
							SCK<=1'b0;
							SDI<=data_out[6];
						end
			
			7'd51	:	begin
							sta_tim<=7'd52;
							SCK<=1'b1;
						end
			
			7'd52	:	begin
							sta_tim<=7'd53;
							SCK<=1'b0;
							SDI<=data_out[5];
						end
						
			7'd53	:	begin
							sta_tim<=7'd54;
							SCK<=1'b1;
						end
			
			7'd54	:	begin
							sta_tim<=7'd55;
							SCK<=1'b0;
							SDI<=data_out[4];
						end
						
			7'd55	:	begin
							sta_tim<=7'd56;
							SCK<=1'b1;
						end
			
			7'd56	:	begin
							sta_tim<=7'd57;
							SCK<=1'b0;
							SDI<=data_out[3];
						end
						
			7'd57	:	begin
							sta_tim<=7'd58;
							SCK<=1'b1;
						end
			
			7'd58	:	begin
							sta_tim<=7'd59;
							SCK<=1'b0;
							SDI<=data_out[2];
						end
			
			7'd59	:	begin
							sta_tim<=7'd60;
							SCK<=1'b1;
						end
			
			7'd60	:	begin
							sta_tim<=7'd61;
							SCK<=1'b0;
							SDI<=data_out[1];
						end
			
			7'd61	:	begin
							sta_tim<=7'd62;
							SCK<=1'b1;
						end
			
			7'd62	:	begin
							sta_tim<=7'd63;
							SCK<=1'b0;
							SDI<=data_out[0];
						end
			
			7'd63	:	begin
							sta_tim<=7'd64;
							SCK<=1'b1;
						end
						
			7'd64	:	begin
							sta_tim<=7'd65;
							SCK<=1'b0;
							SDI<=1'b0;
						end
						
			7'd65	:	begin
							sta_tim<=7'd66;
							SCK<=1'b1;
						end
						
			7'd66	:	begin
							sta_tim<=7'd67;
							SCK<=1'b0;
							SEN<=1'b0;
						end
			
			7'd67	:	begin
							sta_tim<=7'd1;
							spi_rdy<=1'b1;
						end
						
			default:	;
			
		endcase
		
	else 
		case(sta_tim_r)
			
			7'd0	:	begin
							count<=count+1'b1;
							if(count==8'd255)
							begin
								sta_tim_r<=7'd1;
							end
							else
							begin
								sta_tim_r<=7'd0;
								SCK<=1'b0;
								SDI<=1'b0;
								SEN<=1'b0;
							end
						end
						
			7'd1	:	begin
							if(spi_en)
							begin
								sta_tim_r<=7'd2;
							end
							else
							begin
								sta_tim_r<=7'd1;
								spi_rdy<=1'b0;
							end
						end
						
			7'd2	:	begin
							sta_tim_r<=7'd3;
							SEN<=1'b1;
							SDI<=1'b1;
						end
			
			7'd3	:	begin
							sta_tim_r<=7'd4;
							SCK<=1'b1;
						end
			
			7'd4	:	begin
							sta_tim_r<=7'd5;
							SCK<=1'b0;
							SDI<=1'b0;
						end
			
			7'd5	:	begin
							sta_tim_r<=7'd6;
							SCK<=1'b1;
						end
			
			7'd6	:	begin
							sta_tim_r<=7'd7;
							SCK<=1'b0;
							SDI<=1'b0;
						end
						
			7'd7	:	begin
							sta_tim_r<=7'd8;
							SCK<=1'b1;
						end
			
			7'd8	:	begin
							sta_tim_r<=7'd9;
							SCK<=1'b0;
							SDI<=1'b0;
						end
						
			7'd9	:	begin
							sta_tim_r<=7'd10;
							SCK<=1'b1;
						end
			
			7'd10	:	begin
							sta_tim_r<=7'd11;
							SCK<=1'b0;
							SDI<=1'b0;
						end
						
			7'd11	:	begin
							sta_tim_r<=7'd12;
							SCK<=1'b1;
						end
			
			7'd12	:	begin
							sta_tim_r<=7'd13;
							SCK<=1'b0;
							SDI<=1'b1;
						end
						
			7'd13	:	begin
							sta_tim_r<=7'd14;
							SCK<=1'b1;
						end
			
			7'd14	:	begin
							sta_tim_r<=7'd15;
							SCK<=1'b0;
							SDI<=1'b0;
						end
						
			7'd15	:	begin
							sta_tim_r<=7'd16;
							SCK<=1'b1;
						end
			
			7'd16	:	begin
							sta_tim_r<=7'd17;
							SCK<=1'b0;
						end
						
			7'd17	:	begin
							sta_tim_r<=7'd18;
							SCK<=1'b1;
						end
			
			7'd18	:	begin
							sta_tim_r<=7'd19;
							SCK<=1'b0;
							data_in[23]<=SDO;
						end
						
			7'd19	:	begin
							sta_tim_r<=7'd20;
							SCK<=1'b1;
						end
			
			7'd20	:	begin
							sta_tim_r<=7'd21;
							SCK<=1'b0;
							data_in[22]<=SDO;
						end
						
			7'd21	:	begin
							sta_tim_r<=7'd22;
							SCK<=1'b1;
						end
			
			7'd22	:	begin
							sta_tim_r<=7'd23;
							SCK<=1'b0;
							data_in[21]<=SDO;
						end
						
			7'd23	:	begin
							sta_tim_r<=7'd24;
							SCK<=1'b1;
						end
			
			7'd24	:	begin
							sta_tim_r<=7'd25;
							SCK<=1'b0;
							data_in[20]<=SDO;
						end
						
			7'd25	:	begin
							sta_tim_r<=7'd26;
							SCK<=1'b1;
						end
			
			7'd26	:	begin
							sta_tim_r<=7'd27;
							SCK<=1'b0;
							data_in[19]<=SDO;
						end
						
			7'd27	:	begin
							sta_tim_r<=7'd28;
							SCK<=1'b1;
						end
			
			7'd28	:	begin
							sta_tim_r<=7'd29;
							SCK<=1'b0;
							data_in[18]<=SDO;
						end
			
			7'd29	:	begin
							sta_tim_r<=7'd30;
							SCK<=1'b1;
						end
			
			7'd30	:	begin
							sta_tim_r<=7'd31;
							SCK<=1'b0;
							data_in[17]<=SDO;
						end
						
			7'd31	:	begin
							sta_tim_r<=7'd32;
							SCK<=1'b1;
						end
			
			7'd32	:	begin
							sta_tim_r<=7'd33;
							SCK<=1'b0;
							data_in[16]<=SDO;
						end
						
			7'd33	:	begin
							sta_tim_r<=7'd34;
							SCK<=1'b1;
						end
			
			7'd34	:	begin
							sta_tim_r<=7'd35;
							SCK<=1'b0;
							data_in[15]<=SDO;
						end
						
			7'd35	:	begin
							sta_tim_r<=7'd36;
							SCK<=1'b1;
						end
			
			7'd36	:	begin
							sta_tim_r<=7'd37;
							SCK<=1'b0;
							data_in[14]<=SDO;
						end
						
			7'd37	:	begin
							sta_tim_r<=7'd38;
							SCK<=1'b1;
						end
			
			7'd38	:	begin
							sta_tim_r<=7'd39;
							SCK<=1'b0;
							data_in[13]<=SDO;
						end
			
			7'd39	:	begin
							sta_tim_r<=7'd40;
							SCK<=1'b1;
						end
			
			7'd40	:	begin
							sta_tim_r<=7'd41;
							SCK<=1'b0;
							data_in[12]<=SDO;
						end
			
			7'd41	:	begin
							sta_tim_r<=7'd42;
							SCK<=1'b1;
						end
			
			7'd42	:	begin
							sta_tim_r<=7'd43;
							SCK<=1'b0;
							data_in[11]<=SDO;
						end
						
			7'd43	:	begin
							sta_tim_r<=7'd44;
							SCK<=1'b1;
						end
			
			7'd44	:	begin
							sta_tim_r<=7'd45;
							SCK<=1'b0;
							data_in[10]<=SDO;
						end
						
			7'd45	:	begin
							sta_tim_r<=7'd46;
							SCK<=1'b1;
						end
			
			7'd46	:	begin
							sta_tim_r<=7'd47;
							SCK<=1'b0;
							data_in[9]<=SDO;
						end
						
			7'd47	:	begin
							sta_tim_r<=7'd48;
							SCK<=1'b1;
						end
			
			7'd48	:	begin
							sta_tim_r<=7'd49;
							SCK<=1'b0;
							data_in[8]<=SDO;
						end
			
			7'd49	:	begin
							sta_tim_r<=7'd50;
							SCK<=1'b1;
						end
			
			7'd50	:	begin
							sta_tim_r<=7'd51;
							SCK<=1'b0;
							data_in[7]<=SDO;
						end
			
			7'd51	:	begin
							sta_tim_r<=7'd52;
							SCK<=1'b1;
						end
			
			7'd52	:	begin
							sta_tim_r<=7'd53;
							SCK<=1'b0;
							data_in[6]<=SDO;
						end
						
			7'd53	:	begin
							sta_tim_r<=7'd54;
							SCK<=1'b1;
						end
			
			7'd54	:	begin
							sta_tim_r<=7'd55;
							SCK<=1'b0;
							data_in[5]<=SDO;
						end
						
			7'd55	:	begin
							sta_tim_r<=7'd56;
							SCK<=1'b1;
						end
			
			7'd56	:	begin
							sta_tim_r<=7'd57;
							SCK<=1'b0;
							data_in[4]<=SDO;
						end
						
			7'd57	:	begin
							sta_tim_r<=7'd58;
							SCK<=1'b1;
						end
			
			7'd58	:	begin
							sta_tim_r<=7'd59;
							SCK<=1'b0;
							data_in[3]<=SDO;
						end
			
			7'd59	:	begin
							sta_tim_r<=7'd60;
							SCK<=1'b1;
						end
			
			7'd60	:	begin
							sta_tim_r<=7'd61;
							SCK<=1'b0;
							data_in[2]<=SDO;
						end
			
			7'd61	:	begin
							sta_tim_r<=7'd62;
							SCK<=1'b1;
						end
			
			7'd62	:	begin
							sta_tim_r<=7'd63;
							SCK<=1'b0;
							data_in[1]<=SDO;
						end
			
			7'd63	:	begin
							sta_tim_r<=7'd64;
							SCK<=1'b1;
						end
						
			7'd64	:	begin
							sta_tim_r<=7'd65;
							SCK<=1'b0;
							data_in[0]<=SDO;
						end
						
			7'd65	:	begin
							sta_tim_r<=7'd66;
							SCK<=1'b1;
						end
						
			7'd66	:	begin
							sta_tim_r<=7'd67;
							SCK<=1'b0;
							SDI<=1'b0;
							SEN<=1'b0;
						end
			
			7'd67	:	begin
							sta_tim_r<=7'd0;
							spi_rdy<=1'b1;
						end
						
			default:	;
			
		endcase
end
						
endmodule  