library verilog;
use verilog.vl_types.all;
entity cepin is
    generic(
        F_1S            : integer := 199999999
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sig_in          : in     vl_logic;
        pinlv           : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of F_1S : constant is 1;
end cepin;
