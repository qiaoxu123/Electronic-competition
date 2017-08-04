library verilog;
use verilog.vl_types.all;
entity M_Receive is
    generic(
        T200ms          : integer := 4999999
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        M_in            : in     vl_logic;
        M_edge          : out    vl_logic;
        M_period        : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of T200ms : constant is 1;
end M_Receive;
