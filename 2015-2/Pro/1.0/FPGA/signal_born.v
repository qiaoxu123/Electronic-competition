/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				
* 
* ==================================================================*/

module Signal_born(
	
	input wire 			clk,	
	input	wire			rst_n,
	input wire [3:0] 	sw,
	
	output wire			One_Signal_in,
	output wire     	Two_Signal_in
);


//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	parameter F50hz = 32'd0_999;
	parameter F100hz = 32'd1_999;
	parameter F150hz = 32'd2_999; 
	parameter F200hz = 32'd3_999;

//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* Function ****************************/
 	reg [31:0] counter;
	reg 		  One_signal;
	reg        Two_signal;
	
	always @(posedge clk or negedge rst_n)
	if(!rst_n) begin 
		counter <= 32'd0;
		One_signal <= 1'b0;
		Two_signal <= 1'b0;
	end 
	else begin 
		case(sw)
			4'b0001:begin 
				if(counter == F50hz) begin 
					counter <= 32'd0;
					One_signal <= ~One_signal;
					Two_signal <= ~Two_signal;
				end 
				else 
					counter <= counter + 1'b1;
			end
			
			4'b0010:begin 
				if(counter == F100hz) begin 
					counter <= 32'd0;
					One_signal <= ~One_signal;
					Two_signal <= ~Two_signal;
				end 
				else 
					counter <= counter + 1'b1;
			end 
			
			4'b0100:begin 
				if(counter == F100hz) begin 
					counter <= 32'd0;
					One_signal <= ~One_signal;
					Two_signal <= ~Two_signal;
				end 
				else 
					counter <= counter + 1'b1;
			end
			
			4'b1000:begin 
				if(counter == F150hz) begin 
					counter <= 32'd0;
					One_signal <= ~One_signal;
					Two_signal <= ~Two_signal;
				end 
				else 
					counter <= counter + 1'b1;
			end
			default:begin 
				if(counter == F200hz) begin 
					counter <= 32'd0;
					One_signal <= ~One_signal;
					Two_signal <= ~Two_signal;
				end 
				else 
					counter <= counter + 1'b1;
			end 
		endcase
	
	end

	assign One_Signal_in = One_signal;
	assign Two_Signal_in = Two_signal;
	
	
	
	
	
	
	
	
	
	
	
	
	


endmodule

