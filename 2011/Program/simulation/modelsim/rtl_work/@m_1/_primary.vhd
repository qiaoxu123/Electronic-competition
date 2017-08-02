library verilog;
use verilog.vl_types.all;
entity M_1 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        button_data     : in     vl_logic_vector(3 downto 0);
        signal_v1       : out    vl_logic;
        signal_v1_clk   : out    vl_logic;
        signal_v1_man   : out    vl_logic
    );
end M_1;
