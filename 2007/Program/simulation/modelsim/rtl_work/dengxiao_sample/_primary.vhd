library verilog;
use verilog.vl_types.all;
entity dengxiao_sample is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sample_sig      : in     vl_logic;
        ad_data         : in     vl_logic_vector(7 downto 0);
        value_x         : in     vl_logic_vector(10 downto 0);
        value_y         : in     vl_logic_vector(10 downto 0);
        ad_data_dx_100  : out    vl_logic_vector(7 downto 0);
        ceshi           : out    vl_logic
    );
end dengxiao_sample;
