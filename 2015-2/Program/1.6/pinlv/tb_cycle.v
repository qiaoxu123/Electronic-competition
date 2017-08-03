`timescale 1ns/1ns
module	tb_cycle();


reg				clk;
reg				rst_n;
reg				sig_in;
reg				sig_in1;


pro_pinlv  tb_U1(

		//system	interface
			.clk(clk),
			.rst_n(rst_n),
		//sig		interface
			.sig_in(sig_in),
			.sig_in1(sig_in1)
);

initial begin
	clk = 0;
	sig_in  = 0;
	sig_in1 = 1;
	rst_n = 0;
	#100;
	rst_n = 1;
end

always  #10 clk = ~ clk;
//always  #100 sig_in =~ sig_in;
//always  #100 sig_in1 =~ sig_in1;
always begin
	#100;
	sig_in = 1;
	#50;
	sig_in = 0;
end



endmodule