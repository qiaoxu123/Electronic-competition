library verilog;
use verilog.vl_types.all;
entity vga_drive is
    generic(
        H_END           : vl_logic_vector(0 to 10) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        HA              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        HB              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        HC              : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        HD              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        V_END           : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1);
        VO              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        VP              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1);
        VQ              : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        VR              : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        bmp_one_a1      : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        bmp_one_a2      : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        bmp_one_b1      : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        bmp_one_b2      : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        RGB             : in     vl_logic_vector(23 downto 0);
        VGA_CLK         : out    vl_logic;
        VGA_BLANK_N     : out    vl_logic;
        VGA_SYNC_N      : out    vl_logic;
        VGA_R           : out    vl_logic_vector(7 downto 0);
        VGA_B           : out    vl_logic_vector(7 downto 0);
        VGA_G           : out    vl_logic_vector(7 downto 0);
        VGA_HS          : out    vl_logic;
        VGA_VS          : out    vl_logic;
        hx              : out    vl_logic_vector(9 downto 0);
        vy              : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of H_END : constant is 1;
    attribute mti_svvh_generic_type of HA : constant is 1;
    attribute mti_svvh_generic_type of HB : constant is 1;
    attribute mti_svvh_generic_type of HC : constant is 1;
    attribute mti_svvh_generic_type of HD : constant is 1;
    attribute mti_svvh_generic_type of V_END : constant is 1;
    attribute mti_svvh_generic_type of VO : constant is 1;
    attribute mti_svvh_generic_type of VP : constant is 1;
    attribute mti_svvh_generic_type of VQ : constant is 1;
    attribute mti_svvh_generic_type of VR : constant is 1;
    attribute mti_svvh_generic_type of bmp_one_a1 : constant is 1;
    attribute mti_svvh_generic_type of bmp_one_a2 : constant is 1;
    attribute mti_svvh_generic_type of bmp_one_b1 : constant is 1;
    attribute mti_svvh_generic_type of bmp_one_b2 : constant is 1;
end vga_drive;
