//testbench for logic_analysis.prj
`timescale 1ns/1ns

module tb_logic_analysis;

//print_task.v里包含常用信息打印任务封装
print_task	print();

//sys_ctrl_task.v里包含系统时钟产生单元和系统复位任务
sys_ctrl_task	sys_ctrl(
						.clk(clk),
						.rst_n(rst_n)
					);

//input
wire clk;		//FPAG输入时钟信号25MHz
wire rst_n;		//系统复位信号
reg[3:0] signal;	//4路采样信号
reg trigger;		//1路触发信号，可配置为上升沿或者下降沿触发
reg tri_mode;		//触发信号模式选择，1--上升沿触发，0--下降沿触发
reg[2:0] sampling_mode;	//采样模式选择,mode=001--MODE1，mode=010--MODE2，mode=100--MODE3
reg sampling_clr_n;		//采样清除信号，用于清除当前采样数据，低有效

//output
wire hsync;	//行同步信号
wire vsync;	//场同步信号
wire vga_r;
wire vga_g;
wire vga_b;

//引出被测试工程的内部信号进行观察
/*wire clk_100m = uut.clk_100m;	//PLL输出100MHz
wire clk_25m = uut.clk_25m;		//PLL输出25MHz
wire[31:0] topic_data = uut.topic_data;		//标题ROM数据总线
wire[7:0] topic_addr = uut.topic_addr;		//标题ROM地址总线
wire[15:0] char_data = uut.char_data;		//char ROM数据总线
wire[8:0] char_addr = uut.char_addr;		//char ROM地址总线
*/

logic_analysis		uut(
					.clk(clk),
					.rst_n(rst_n),
					.signal(signal),
					.trigger(trigger),
					//.tri_mode(tri_mode),
					//.sampling_mode(sampling_mode),		
					.add_key(add_key),
					.dec_key(dec_key),
					.sampling_clr_n(sampling_clr_n),			
					.hsync(hsync),
					.vsync(vsync),
					.vga_r(vga_r),
					.vga_g(vga_g),
					.vga_b(vga_b)
				);
				
integer i;		
parameter	MODE1	= 3'b001,	//采样MODE1	
			MODE2	= 3'b010,	//采样MODE2
			MODE3	= 3'b100;	//采样MODE3
parameter	POS_TRI	= 1'b1,		//上升沿触发
			NEG_TRI = 1'b0;		//下降沿触发	
			
//触发测试任务	
task test_ing_task;
	input[2:0] test_tri_mode;	//采样模式输入
	input test_sap_mode;		//触发模式输入
	begin
		tri_mode = test_sap_mode;	
		sampling_mode = test_tri_mode;
		
		trigger = ~test_sap_mode;	//触发信号复位
		#10;		
		
		for(i=0;i<100;i=i+1) begin
				@(posedge clk);
				signal = {$random}>>28;	//随机发出待采样信号
			end
		
		trigger = test_sap_mode;	//触发信号触发
		#10;
		
		for(i=0;i<100;i=i+1) begin
				@(posedge clk);
				signal = {$random}>>28;	//随机发出待采样信号
			end		
		
		#1000;		//delay 1us	
	end
endtask		
		
//清除已触发显示任务
task wave_clr_task;
	begin
		sampling_clr_n = 1'b0;
		#200;
		sampling_clr_n = 1'b1;		
		#200;
	end
endtask


//仿真测试中
initial begin
	signal = 4'h0;	
	trigger = 1'b0;
	tri_mode = 3'bzzz;	
	sampling_mode = 1'bz;
	sampling_clr_n = 1'b1;

	sys_ctrl.sys_reset(200);	//有效复位200ns
	
	#3_000;	//delay 3us
	
		//分别测试不同的触发模式和不同的采样模式设计是否符合要求
	wave_clr_task;		//清除已触发显示		
	test_ing_task(MODE1,POS_TRI);	//模式1，上升沿触发测试
	
	wave_clr_task;		//清除已触发显示
	test_ing_task(MODE1,NEG_TRI);	//模式1，下降沿触发测试

	wave_clr_task;		//清除已触发显示
	test_ing_task(MODE2,POS_TRI);	//模式2，上升沿触发测试

	wave_clr_task;		//清除已触发显示	
	test_ing_task(MODE2,NEG_TRI);	//模式2，下降沿触发测试
	
	wave_clr_task;		//清除已触发显示
	test_ing_task(MODE3,POS_TRI);	//模式3，上升沿触发测试

	wave_clr_task;		//清除已触发显示		
	test_ing_task(MODE3,NEG_TRI);	//模式3，下降沿触发测试
	
	#1000;	
	$stop;	
end



endmodule

