/*-----------------------------------------------------------------------

Date				:		2017-XX-XX
Description			:		Design for LCD1602 Display.

-----------------------------------------------------------------------*/

module vga
(
	//global clock
	input					clk,			//system clock
	input					rst_n,     		//sync reset
	
	//XXX interface
	output					vga_write_rom_value,   	//
	output	reg		[9:0]	vga_add		//

	
); 


//--------------------------------
//Funtion :               

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		vga_add <= 0;
	else
		vga_add <= vga_add + 1;
end

assign	vga_write_rom_value = (vga_add > 700 && vga_add < 1024) ? 1 : 0;
endmodule
	
