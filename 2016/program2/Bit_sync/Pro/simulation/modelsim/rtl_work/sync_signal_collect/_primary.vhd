library verilog;
use verilog.vl_types.all;
entity sync_signal_collect is
    generic(
        T1s             : integer := 49999999
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sw              : in     vl_logic;
        M_period        : in     vl_logic_vector(31 downto 0);
        M_edge          : in     vl_logic;
        bit_sync        : out    vl_logic;
        sync_period     : out    vl_logic_vector(19 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of T1s : constant is 1;
end sync_signal_collect;
