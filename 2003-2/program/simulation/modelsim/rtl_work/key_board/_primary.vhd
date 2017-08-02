library verilog;
use verilog.vl_types.all;
entity key_board is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        row             : in     vl_logic_vector(3 downto 0);
        col             : out    vl_logic_vector(3 downto 0);
        key_value       : out    vl_logic;
        row_col         : out    vl_logic_vector(7 downto 0)
    );
end key_board;
