library verilog;
use verilog.vl_types.all;
entity single_chufa is
    generic(
        NUM_100HZ       : integer := 49
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        key_sigle       : in     vl_logic;
        q               : in     vl_logic_vector(7 downto 0);
        q_set           : in     vl_logic_vector(7 downto 0);
        q_sig           : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_100HZ : constant is 1;
end single_chufa;
