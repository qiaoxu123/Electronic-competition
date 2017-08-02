library verilog;
use verilog.vl_types.all;
entity pro_2017 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        button_add      : in     vl_logic;
        button_sub      : in     vl_logic;
        signal_v1       : out    vl_logic;
        signal_v1_clk   : out    vl_logic;
        signal_v3       : out    vl_logic;
        signal_v1_man   : out    vl_logic;
        sync_clk        : out    vl_logic;
        smg1            : out    vl_logic_vector(6 downto 0)
    );
end pro_2017;
