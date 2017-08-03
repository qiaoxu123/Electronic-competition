library verilog;
use verilog.vl_types.all;
entity vga_control is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        hx              : in     vl_logic_vector(9 downto 0);
        vy              : in     vl_logic_vector(9 downto 0);
        RGB             : out    vl_logic_vector(23 downto 0)
    );
end vga_control;
