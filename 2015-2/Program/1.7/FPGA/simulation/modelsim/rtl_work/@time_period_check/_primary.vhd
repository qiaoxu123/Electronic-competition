library verilog;
use verilog.vl_types.all;
entity Time_period_check is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        One_Signal_in   : in     vl_logic;
        Two_Signal_in   : in     vl_logic;
        Time_interval   : out    vl_logic_vector(31 downto 0)
    );
end Time_period_check;
