library verilog;
use verilog.vl_types.all;
entity Freq_check is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        One_Signal_in   : in     vl_logic_vector(31 downto 0);
        Two_Signal_in   : in     vl_logic_vector(31 downto 0);
        One_TestSignal_num: out    vl_logic_vector(31 downto 0);
        Two_TestSignal_num: out    vl_logic_vector(31 downto 0);
        StandSignal_num : out    vl_logic_vector(31 downto 0)
    );
end Freq_check;
