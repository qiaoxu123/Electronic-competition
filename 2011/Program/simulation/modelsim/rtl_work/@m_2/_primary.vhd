library verilog;
use verilog.vl_types.all;
entity M_2 is
    generic(
        CNT_SIGNAL_V3_NUM: integer := 20
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        signal_v3       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CNT_SIGNAL_V3_NUM : constant is 1;
end M_2;
