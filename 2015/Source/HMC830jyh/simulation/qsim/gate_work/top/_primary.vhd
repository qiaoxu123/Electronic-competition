library verilog;
use verilog.vl_types.all;
entity top is
    port(
        altera_reserved_tms: in     vl_logic;
        altera_reserved_tck: in     vl_logic;
        altera_reserved_tdi: in     vl_logic;
        altera_reserved_tdo: out    vl_logic;
        SDI             : out    vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        LD_SDO          : in     vl_logic;
        hang_pose       : in     vl_logic_vector(3 downto 0);
        key_value       : in     vl_logic_vector(3 downto 0);
        SCK             : out    vl_logic;
        SEN             : out    vl_logic;
        data_in         : out    vl_logic_vector(23 downto 0)
    );
end top;
