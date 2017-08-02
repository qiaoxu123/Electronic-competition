library verilog;
use verilog.vl_types.all;
entity pro_2003 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        row             : in     vl_logic_vector(3 downto 0);
        col             : out    vl_logic_vector(3 downto 0);
        key_add         : in     vl_logic;
        key_sub         : in     vl_logic;
        key_sigle       : in     vl_logic
    );
end pro_2003;
