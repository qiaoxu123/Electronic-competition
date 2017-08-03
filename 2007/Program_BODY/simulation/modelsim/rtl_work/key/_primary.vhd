library verilog;
use verilog.vl_types.all;
entity key is
    generic(
        CNT_50HZ_1      : integer := 500000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        button_chui     : in     vl_logic;
        button_v        : in     vl_logic;
        ad_data_dx_2    : in     vl_logic_vector(7 downto 0);
        ad_data_dx_100  : in     vl_logic_vector(7 downto 0);
        ad_data_sample_time: in     vl_logic_vector(7 downto 0);
        pinlv           : in     vl_logic_vector(31 downto 0);
        vga_data        : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CNT_50HZ_1 : constant is 1;
end key;
