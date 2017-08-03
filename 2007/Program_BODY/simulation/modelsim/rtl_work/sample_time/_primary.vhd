library verilog;
use verilog.vl_types.all;
entity sample_time is
    generic(
        NUM_1m          : integer := 49;
        NUM_1K          : integer := 49999
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        ad_data         : in     vl_logic_vector(7 downto 0);
        sample_sig      : in     vl_logic;
        value_x         : in     vl_logic_vector(10 downto 0);
        value_y         : in     vl_logic_vector(10 downto 0);
        ad_data_value   : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_1m : constant is 1;
    attribute mti_svvh_generic_type of NUM_1K : constant is 1;
end sample_time;
