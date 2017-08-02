library verilog;
use verilog.vl_types.all;
entity three_chufa is
    generic(
        NUM_100HZ       : integer := 49
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        key_sigle       : in     vl_logic;
        q               : in     vl_logic_vector(7 downto 0);
        q_set_three     : in     vl_logic_vector(5 downto 0);
        q_two           : in     vl_logic_vector(1 downto 0);
        q_sig_three     : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_100HZ : constant is 1;
end three_chufa;
