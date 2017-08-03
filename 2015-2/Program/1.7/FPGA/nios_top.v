/* ==================================================================
* Family:				Cyclone V
* Device:				5CSEMA5F31C6
* Stage:				   DE1-SOC			
* Version:				Quartus II 64-Bit Version & 13.1.0 Build 162 10/23/2013 SJ Full Version
* Author: 				Qiaoxu
* Address:				Lab
* Data:					2017/
* Function:				实现labview接收频率检测信号，在上位机输出频率，占空比，时间间隔等信息
* 
* ==================================================================*/

module nios_top(
	
	//共用引脚部分
	input wire 			 clk,	
	input	wire			 rst_n,
	input wire 	[3:0]  key,
	
	//串口接收部分
	input  wire        uart_rxd,      //  uart.rxd
	output wire        uart_txd,       //      .txd
	
	//Nios模块引脚
	output wire [12:0] sdram_addr,    // sdram.addr
	output wire [1:0]  sdram_ba,      //      .ba
	output wire        sdram_cas_n,   //      .cas_n
	output wire        sdram_cke,     //      .cke
	output wire        sdram_cs_n,    //      .cs_n
	inout  wire [15:0] sdram_dq,      //      .dq
	output wire [1:0]  sdram_dqm,     //      .dqm
	output wire        sdram_ras_n,   //      .ras_n
	output wire        sdram_we_n,     //      .we_n
	output wire 		 sdram_clk
	
);
//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire [9:0] data_out;
	wire [9:0] r_data_out;
	
//====================================================================
// ************************* Main Code *************************
//====================================================================

	/*************************   Nios模块 ****************************/
	
	Nios Nios_module (
       .clk                  (clk),              //           clk.clk
       .rst_n        		  (rst_n),        //         reset.reset_n
       .sdram_addr           (sdram_addr),           //         sdram.addr
       .sdram_ba             (sdram_ba),             //              .ba
       .sdram_cas_n          (sdram_cas_n),          //              .cas_n
       .sdram_cke            (sdram_cke),            //              .cke
       .sdram_cs_n           (sdram_cs_n),           //              .cs_n
       .sdram_dq             (sdram_dq),             //              .dq
       .sdram_dqm            (sdram_dqm),            //              .dqm
       .sdram_ras_n          (sdram_ras_n),          //              .ras_n
       .sdram_we_n           (sdram_we_n),           //              .we_n
		 .sdram_clk				  (sdram_clk),
       .uart_rxd             (uart_rxd),             //          uart.rxd
       .uart_txd             (uart_txd),             //              .txd
		 .dds_data_in_export   (data_out)  // dds_data_in.export
   );	
	
	/*************************  DDS模块 ****************************/
	
	DDS_top dds_top_module(
		.clk					(clk),	
		.rst_n				(rst_n),
		.key					(key),
		.data_out			(r_data_out)
	);
	
	/*************************  FIFO模块 ****************************/
	//将DDS数据寄存起来，同步串口的传输速率
	
	fifo fifo_module(
		.clock				(clk),
		.data					(r_data_out),
		.rdreq				(~empty), 
		.wrreq				(~full),
		.empty				(empty),
		.full					(full),
		.q						(data_out)
	);

endmodule
