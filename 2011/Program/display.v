/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for 数码管 Display.

-----------------------------------------------------------------------*/

module display
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//smg interface
	input			[3:0]	button_data,   	//
	output	reg		[6:0]	smg1
	
); 


//--------------------------------
//Funtion :               
parameter _0=8'hc0,_1=8'hf9,_2=8'ha4,_3=8'hb0,_4=8'h99,
			 _5=8'h92,_6=8'h82,_7=8'hf8,_8=8'h80,_9=8'h90;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		smg1 <= 0;
	else 
	case(button_data)
		4'd0:smg1<=_0;
		4'd1:smg1<=_1;
		4'd2:smg1<=_2;
		4'd3:smg1<=_3;
		4'd4:smg1<=_4;
		4'd5:smg1<=_5;	
		4'd6:smg1<=_6;
		4'd7:smg1<=_7;	
		4'd8:smg1<=_8;
		4'd9:smg1<=_9;
		default:smg1<=_0;	
	endcase
end

endmodule
	
