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

module Nios(
	
	input  wire        clk,       //   clk.clk
	input  wire        rst_n, // reset.reset_n
	output wire [12:0] sdram_addr,    // sdram.addr
	output wire [1:0]  sdram_ba,      //      .ba
	output wire        sdram_cas_n,   //      .cas_n
	output wire        sdram_cke,     //      .cke
	output wire        sdram_cs_n,    //      .cs_n
	inout  wire [15:0] sdram_dq,      //      .dq
	output wire [1:0]  sdram_dqm,     //      .dqm
	output wire        sdram_ras_n,   //      .ras_n
	output wire        sdram_we_n,    //      .we_n
	output wire			 sdram_clk,
	input  wire        uart_rxd,      //  uart.rxd
	output wire        uart_txd,      //      .txd
	input  wire [9:0]  dds_data_in_export  // dds_data_in.export
			
);

//====================================================================
// ********** Define Parameter and Internal Signals *************
//====================================================================
	wire						cpu_clk;
	wire						cpu_reset_n;
	wire						pll_locked;
	assign					cpu_reset_n = pll_locked;


//====================================================================
// ************************* Main Code *************************
//====================================================================

	/************************* 例化Nios核 ****************************/
   
   cpu u0 (
       .clk_clk              (cpu_clk),              //           clk.clk
       .reset_reset_n        (cpu_reset_n),        //         reset.reset_n
       .sdram_addr           (sdram_addr),           //         sdram.addr
       .sdram_ba             (sdram_ba),             //              .ba
       .sdram_cas_n          (sdram_cas_n),          //              .cas_n
       .sdram_cke            (sdram_cke),            //              .cke
       .sdram_cs_n           (sdram_cs_n),           //              .cs_n
       .sdram_dq             (sdram_dq),             //              .dq
       .sdram_dqm            (sdram_dqm),            //              .dqm
       .sdram_ras_n          (sdram_ras_n),          //              .ras_n
       .sdram_we_n           (sdram_we_n),           //              .we_n
       .uart_rxd             (uart_rxd),             //          uart.rxd
       .uart_txd             (uart_txd),             //              .txd
		 .dds_data_in_export   (dds_data_in_export)  // dds_data_in.export
   );

	
	pll_100M U1(
		.refclk(clk),   //  refclk.clk
		.rst(~rst_n),      //   reset.reset
		.outclk_0(cpu_clk), // outclk0.clk
		.outclk_1(sdram_clk), // outclk1.clk
		.locked(pll_locked)    //  locked.export
	);

	
	



endmodule

