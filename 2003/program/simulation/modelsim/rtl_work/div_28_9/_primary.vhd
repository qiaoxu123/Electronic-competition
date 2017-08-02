library verilog;
use verilog.vl_types.all;
entity div_28_9 is
    port(
        denom           : in     vl_logic_vector(8 downto 0);
        numer           : in     vl_logic_vector(27 downto 0);
        quotient        : out    vl_logic_vector(27 downto 0);
        remain          : out    vl_logic_vector(8 downto 0)
    );
end div_28_9;
