library verilog;
use verilog.vl_types.all;
entity shift_sig is
    generic(
        NUM_100HZ       : integer := 49
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        shift_sig       : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_100HZ : constant is 1;
end shift_sig;
