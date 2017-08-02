library verilog;
use verilog.vl_types.all;
entity key_control is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        fword           : out    vl_logic_vector(31 downto 0);
        pword           : out    vl_logic_vector(11 downto 0);
        fout            : out    vl_logic_vector(15 downto 0);
        pout            : out    vl_logic_vector(15 downto 0)
    );
end key_control;
