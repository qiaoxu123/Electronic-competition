`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:45:36 04/01/2009
// Design Name:   cpu_cpld
// Module Name:   D:/verilog_prj/KS7_CPU_SIM/testbech_prj/cpu_cpld/print_task.v
// Project Name:  cpu_cpld
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpu_cpld
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sys_ctrl_task(
					clk,rst_n
					);

output reg clk;	//时钟信号
output reg rst_n;	//复位信号

parameter 	PERIOD 	= 40;		//时钟周期，单位ns 
parameter 	RST_ING = 1'b0;		//有效复位值，默认低电平复位 				

//----------------------------------------------------------------------//
//系统时钟信号产生
//----------------------------------------------------------------------//		
initial begin
	clk = 0;
	forever
		#(PERIOD/2) clk = ~clk;
end
 		
//----------------------------------------------------------------------//
//系统复位任务封装
//----------------------------------------------------------------------//		
task sys_reset;
	input[31:0] reset_time; //复位时间输入，单位ns
	begin
		rst_n = RST_ING;		//复位中
		#reset_time;			//复位时间
		rst_n = ~RST_ING;		//撤销复位
	end
endtask		
		
		
endmodule

