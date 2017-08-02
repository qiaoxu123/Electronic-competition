library verilog;
use verilog.vl_types.all;
entity iss_1 is
    port(
        probe           : in     vl_logic;
        source          : out    vl_logic_vector(15 downto 0)
    );
end iss_1;
