library verilog;
use verilog.vl_types.all;
entity pr_2007 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        ad_data_in      : in     vl_logic_vector(9 downto 0);
        ad_clk          : out    vl_logic;
        sample_sig      : in     vl_logic;
        button_chui     : in     vl_logic;
        button_v        : in     vl_logic;
        vga_clk         : out    vl_logic;
        vga_b           : out    vl_logic_vector(7 downto 0);
        vga_g           : out    vl_logic_vector(7 downto 0);
        vga_r           : out    vl_logic_vector(7 downto 0);
        vga_blank       : out    vl_logic;
        vga_sync        : out    vl_logic;
        vga_hs          : out    vl_logic;
        vga_vs          : out    vl_logic
    );
end pr_2007;
