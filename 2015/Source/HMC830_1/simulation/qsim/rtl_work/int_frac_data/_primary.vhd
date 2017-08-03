library verilog;
use verilog.vl_types.all;
entity int_frac_data is
    port(
        address         : in     vl_logic_vector(7 downto 0);
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(29 downto 0)
    );
end int_frac_data;
