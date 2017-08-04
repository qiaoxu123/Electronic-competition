library verilog;
use verilog.vl_types.all;
entity M_sequence is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        bit_sync_clk    : in     vl_logic;
        M_out           : out    vl_logic
    );
end M_sequence;
