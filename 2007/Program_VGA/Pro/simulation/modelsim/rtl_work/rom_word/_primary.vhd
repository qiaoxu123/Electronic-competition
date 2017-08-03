library verilog;
use verilog.vl_types.all;
entity rom_word is
    port(
        address         : in     vl_logic_vector(4 downto 0);
        clock           : in     vl_logic;
        q               : out    vl_logic_vector(31 downto 0)
    );
end rom_word;
