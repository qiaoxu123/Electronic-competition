library verilog;
use verilog.vl_types.all;
entity vga_top is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        VGA_CLK         : out    vl_logic;
        VGA_BLANK_N     : out    vl_logic;
        VGA_SYNC_N      : out    vl_logic;
        VGA_R           : out    vl_logic_vector(7 downto 0);
        VGA_B           : out    vl_logic_vector(7 downto 0);
        VGA_G           : out    vl_logic_vector(7 downto 0);
        VGA_HS          : out    vl_logic;
        VGA_VS          : out    vl_logic
    );
end vga_top;
