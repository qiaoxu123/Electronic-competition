library verilog;
use verilog.vl_types.all;
entity pro_uart is
    generic(
        F_1S            : integer := 49999999
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sig_in          : in     vl_logic;
        sig_in1         : in     vl_logic;
        phase           : out    vl_logic_vector(31 downto 0);
        pinlv           : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of F_1S : constant is 1;
end pro_uart;
