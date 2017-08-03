module rom_control(
		//system signal
		input 					clk			, // 系统时钟
		input 					rst_n			, // 复位
		//fft	signal 
		input 					source_sop	, // fft开始输出标志 
		input 					source_valid, // fft输出数据有效位
		input 	[5:0]			source_exp	, // fft缩放系数
		input 	[11:0]		source_real	, // fft输出数据实部
		input 	[11:0]		source_imag	, // fft输出数据虚部 
		//vga signal 
		input 					vga			, // vga显示的范围信号
		input 	[9:0]			hx				, // vga列显示地址信号
		//ram signal 
		output	[9:0] 		data			, // 数据输出	
		output 	[10:0]		wadd			, // ram写地址
		output 					wren			, // ram写使能
		output 	[10:0]		radd			  // ram读使能
);

//数据处理
reg  [24:0] d ;
reg  [11:0] datar, datai;
always @(posedge clk )
begin 
	datar <= source_real;
	datai <= source_imag;
	d     <= d_rr + d_ii;
end 

wire [23:0] d_rr, d_ii; 
mult	U1 (
	.dataa ( datar),
	.result ( d_rr)
	);
mult	U2 (
	.dataa ( datai),
	.result ( d_ii)
	);

	


wire [5:0] pexp = source_exp[5] == 1'b0 ? source_exp : (6'b0 -  source_exp);//第6位为符号位，0表示+，1表示-;若为- 应转换为+
wire [12:0] d2   = (pexp > 4'd11) ? q <<(pexp - 4'd11) : q>>(4'd11 - pexp);
wire [12:0] q;



qurt	U3  (
	.radical (d),
	.q (q)//此时q为开根号后的d
	);
	
	

	
	
//  ram 写
assign wren = source_valid;


reg [11:0] ramwadd;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		ramwadd <= 1'b0;
	else if(wren)
		ramwadd <= ramwadd + 1'b1;
	else 
		ramwadd <= 1'b0;
end 

//ram 读
reg [11:0] ramradd;
always @(posedge clk or negedge rst_n)
begin 
	if(!rst_n)
		ramradd <= 1'b0;
	else if(vga)
		ramradd <= hx + 1'b1;
	else 
	   ramradd <= 1'b0;
end 


assign radd = ramradd[10:0];
assign wadd = (ramwadd >= 2'd3) ? ramwadd - 2'd3 : 1'b0;//WHY 3?
assign data = d2[9:0];
endmodule 