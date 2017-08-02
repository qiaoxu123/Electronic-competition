library verilog;
use verilog.vl_types.all;
entity sync is
    generic(
        CNT_100MS_NUM   : integer := 200000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        clk_phase90     : in     vl_logic;
        signal_v1_man   : in     vl_logic;
        sync_clk        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CNT_100MS_NUM : constant is 1;
end sync;
