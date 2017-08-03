library verilog;
use verilog.vl_types.all;
entity hmc830_vlg_sample_tst is
    port(
        LD_SDO          : in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end hmc830_vlg_sample_tst;
