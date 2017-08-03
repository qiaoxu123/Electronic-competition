library verilog;
use verilog.vl_types.all;
entity vga_qudong is
    generic(
        X_ALL           : vl_logic_vector(0 to 10) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        XA              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        XB              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        XC              : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        XD              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        Y_ALL           : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1);
        YO              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        YP              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1);
        YQ              : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        YR              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        vga_clk         : out    vl_logic;
        vga_b           : out    vl_logic_vector(7 downto 0);
        vga_g           : out    vl_logic_vector(7 downto 0);
        vga_r           : out    vl_logic_vector(7 downto 0);
        vga_blank       : out    vl_logic;
        vga_sync        : out    vl_logic;
        vga_hs          : out    vl_logic;
        vga_vs          : out    vl_logic;
        value_x         : out    vl_logic_vector(10 downto 0);
        value_y         : out    vl_logic_vector(10 downto 0);
        rgb             : in     vl_logic_vector(23 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of X_ALL : constant is 1;
    attribute mti_svvh_generic_type of XA : constant is 1;
    attribute mti_svvh_generic_type of XB : constant is 1;
    attribute mti_svvh_generic_type of XC : constant is 1;
    attribute mti_svvh_generic_type of XD : constant is 1;
    attribute mti_svvh_generic_type of Y_ALL : constant is 1;
    attribute mti_svvh_generic_type of YO : constant is 1;
    attribute mti_svvh_generic_type of YP : constant is 1;
    attribute mti_svvh_generic_type of YQ : constant is 1;
    attribute mti_svvh_generic_type of YR : constant is 1;
end vga_qudong;
