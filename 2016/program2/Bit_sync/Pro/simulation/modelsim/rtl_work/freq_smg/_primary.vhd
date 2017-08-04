library verilog;
use verilog.vl_types.all;
entity freq_smg is
    generic(
        \_0\            : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        \_1\            : vl_logic_vector(0 to 6) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1);
        \_2\            : vl_logic_vector(0 to 6) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0);
        \_3\            : vl_logic_vector(0 to 6) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0);
        \_4\            : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1);
        \_5\            : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0);
        \_6\            : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        \_7\            : vl_logic_vector(0 to 6) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        \_8\            : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        \_9\            : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sync_period     : in     vl_logic_vector(19 downto 0);
        One_hundred_thousand_data: out    vl_logic_vector(6 downto 0);
        Ten_thousand_data: out    vl_logic_vector(6 downto 0);
        Thousand_data   : out    vl_logic_vector(6 downto 0);
        Hundred_data    : out    vl_logic_vector(6 downto 0);
        Ten_data        : out    vl_logic_vector(6 downto 0);
        One_data        : out    vl_logic_vector(6 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \_0\ : constant is 1;
    attribute mti_svvh_generic_type of \_1\ : constant is 1;
    attribute mti_svvh_generic_type of \_2\ : constant is 1;
    attribute mti_svvh_generic_type of \_3\ : constant is 1;
    attribute mti_svvh_generic_type of \_4\ : constant is 1;
    attribute mti_svvh_generic_type of \_5\ : constant is 1;
    attribute mti_svvh_generic_type of \_6\ : constant is 1;
    attribute mti_svvh_generic_type of \_7\ : constant is 1;
    attribute mti_svvh_generic_type of \_8\ : constant is 1;
    attribute mti_svvh_generic_type of \_9\ : constant is 1;
end freq_smg;
