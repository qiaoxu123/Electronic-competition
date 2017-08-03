library verilog;
use verilog.vl_types.all;
entity hmc830_vlg_check_tst is
    port(
        SCK             : in     vl_logic;
        SDI             : in     vl_logic;
        SEN             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end hmc830_vlg_check_tst;
