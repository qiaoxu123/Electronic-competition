library verilog;
use verilog.vl_types.all;
entity keyboard is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        hang            : in     vl_logic_vector(3 downto 0);
        lie             : out    vl_logic_vector(3 downto 0);
        key_value       : out    vl_logic_vector(3 downto 0);
        hang_pose       : out    vl_logic_vector(3 downto 0);
        int_frac_data   : out    vl_logic_vector(29 downto 0)
    );
end keyboard;
