library verilog;
use verilog.vl_types.all;
entity bin_2_bcd is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in         : in     vl_logic_vector(29 downto 0);
        data_1          : out    vl_logic_vector(3 downto 0);
        data_2          : out    vl_logic_vector(3 downto 0);
        data_3          : out    vl_logic_vector(3 downto 0);
        data_4          : out    vl_logic_vector(3 downto 0);
        data_5          : out    vl_logic_vector(3 downto 0);
        data_6          : out    vl_logic_vector(3 downto 0);
        data_7          : out    vl_logic_vector(3 downto 0);
        data_8          : out    vl_logic_vector(3 downto 0);
        data_9          : out    vl_logic_vector(3 downto 0);
        data_10         : out    vl_logic_vector(3 downto 0)
    );
end bin_2_bcd;
