library verilog;
use verilog.vl_types.all;
entity div_32_32 is
    port(
        denom           : in     vl_logic_vector(31 downto 0);
        numer           : in     vl_logic_vector(31 downto 0);
        quotient        : out    vl_logic_vector(31 downto 0);
        remain          : out    vl_logic_vector(31 downto 0)
    );
end div_32_32;
