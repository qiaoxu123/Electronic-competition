module		pro_pinlv(

		//system	interface
		input					clk,
		input					rst_n,
		//sig		interface
		input					sig_in,
		input					sig_in1,
		//uart		interface
		output					uart_tx
);


wire	[31:0]		pinlv;
wire				clk_100;
wire				clk_500;
wire	[31:0]		cycle;
wire	[31:0]		duty_cycle;
wire	[31:0]		cnt_high;
wire	[31:0]		cnt_low;
cycle  U3(
		//system	interface
				.clk(clk_100),
				.rst_n(rst_n),
		//sig_in	interface
				.sig_in(sig_in),
				.sig_in1(sig_in1),
		//user		interface
				.cycle(cycle)
);
pll_500 U5(
		  .refclk(clk),   //  refclk.clk
		  .rst(!rst_n),      //   reset.reset
		  .outclk_0(clk_500), // outclk0.clk
		  .locked()    //  locked.export
	);
//200M
pll_100m U2(
		  .refclk(clk),   //  refclk.clk
		  .rst(!rst_n),      //   reset.reset
		  .outclk_0(clk_100), // outclk0.clk
		  .locked()    //  locked.export
	);
pinlv	U1(
		//system	interface
			.clk(clk_100),
			.rst_n(rst_n),
		//sig		interface
			.sig_in(sig_in),
		//user		interface
			.pinlv(pinlv)

);

duty   U4(
		//system	interface
		.clk(clk_100),
		.rst_n(rst_n),
		//sig		interface
		.sig_in(sig_in),
		//user		interface
		.pinlv(pinlv),
		.cnt_high(cnt_high),
		.cnt_low(cnt_low)
);

uart_tx	  U6(
		//global clock
			.clk(clk),
			.rst_n(rst_n),
		//uart	interface
			.uart_tx(uart_tx),
		//user	interface
			.pinlv(pinlv),
			.cycle(cycle),
			.duty_cycle(duty_cycle)
			//.cnt_high(cnt_high),
			//.cnt_low(cnt_low)
);

endmodule