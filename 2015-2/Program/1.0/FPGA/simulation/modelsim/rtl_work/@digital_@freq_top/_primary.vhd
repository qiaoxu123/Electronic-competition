library verilog;
use verilog.vl_types.all;
entity Digital_Freq_top is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        One_Signal_in   : in     vl_logic;
        Two_Signal_in   : in     vl_logic;
        One_TestSignal_num: out    vl_logic;
        Two_TestSignal_num: out    vl_logic;
        StandSignal_num : out    vl_logic;
        Time_interval   : out    vl_logic;
        Single_Time_interval_a: out    vl_logic;
        Single_Time_interval_b: out    vl_logic;
        Whole_Time_interval_a: out    vl_logic;
        Whole_Time_interval_b: out    vl_logic
    );
end Digital_Freq_top;
