library verilog;
use verilog.vl_types.all;
entity Bit_sync is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        M_in            : in     vl_logic;
        sw              : in     vl_logic;
        One_hundred_thousand_data: out    vl_logic_vector(6 downto 0);
        Ten_thousand_data: out    vl_logic_vector(6 downto 0);
        Thousand_data   : out    vl_logic_vector(6 downto 0);
        Hundred_data    : out    vl_logic_vector(6 downto 0);
        Ten_data        : out    vl_logic_vector(6 downto 0);
        One_data        : out    vl_logic_vector(6 downto 0);
        bit_sync        : out    vl_logic
    );
end Bit_sync;
