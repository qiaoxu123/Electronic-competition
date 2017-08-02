library verilog;
use verilog.vl_types.all;
entity anjian is
    generic(
        CNT_50HZ_1      : integer := 500000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        button_add      : in     vl_logic;
        button_sub      : in     vl_logic;
        button_data     : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CNT_50HZ_1 : constant is 1;
end anjian;
