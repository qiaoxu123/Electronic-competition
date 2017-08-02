library verilog;
use verilog.vl_types.all;
entity clk_sam is
    port(
        locked          : out    vl_logic;
        outclk_0        : out    vl_logic;
        refclk          : in     vl_logic;
        rst             : in     vl_logic
    );
end clk_sam;
