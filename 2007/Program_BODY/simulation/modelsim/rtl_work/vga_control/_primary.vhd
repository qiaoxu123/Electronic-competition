library verilog;
use verilog.vl_types.all;
entity vga_control is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        value_x         : in     vl_logic_vector(10 downto 0);
        value_y         : in     vl_logic_vector(10 downto 0);
        rgb             : out    vl_logic_vector(23 downto 0);
        vga_data        : in     vl_logic_vector(7 downto 0)
    );
end vga_control;
