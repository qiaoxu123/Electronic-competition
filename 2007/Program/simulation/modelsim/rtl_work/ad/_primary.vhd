library verilog;
use verilog.vl_types.all;
entity ad is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        ad_data_in      : in     vl_logic_vector(9 downto 0);
        ad_clk          : out    vl_logic;
        ad_data         : out    vl_logic_vector(7 downto 0)
    );
end ad;
