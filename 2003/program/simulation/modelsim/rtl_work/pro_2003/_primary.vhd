library verilog;
use verilog.vl_types.all;
entity pro_2003 is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        uart_rx         : in     vl_logic;
        uart_tx         : out    vl_logic
    );
end pro_2003;
