library verilog;
use verilog.vl_types.all;
entity Duty_Cycle is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        One_Signal_in   : in     vl_logic;
        Two_Signal_in   : in     vl_logic;
        Single_Time_interval_a: out    vl_logic_vector(31 downto 0);
        Whole_Time_interval_a: out    vl_logic_vector(31 downto 0);
        Single_Time_interval_b: out    vl_logic_vector(31 downto 0);
        Whole_Time_interval_b: out    vl_logic_vector(31 downto 0)
    );
end Duty_Cycle;
