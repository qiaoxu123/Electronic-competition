library verilog;
use verilog.vl_types.all;
entity dds is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        da_out_a        : out    vl_logic_vector(11 downto 0);
        da_out_b        : out    vl_logic_vector(11 downto 0);
        fword_a         : in     vl_logic_vector(31 downto 0);
        pword_a         : in     vl_logic_vector(11 downto 0)
    );
end dds;
