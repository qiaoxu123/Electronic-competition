library verilog;
use verilog.vl_types.all;
entity Nios is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        sdram_addr      : out    vl_logic_vector(12 downto 0);
        sdram_ba        : out    vl_logic_vector(1 downto 0);
        sdram_cas_n     : out    vl_logic;
        sdram_cke       : out    vl_logic;
        sdram_cs_n      : out    vl_logic;
        sdram_dq        : inout  vl_logic_vector(15 downto 0);
        sdram_dqm       : out    vl_logic_vector(1 downto 0);
        sdram_ras_n     : out    vl_logic;
        sdram_we_n      : out    vl_logic;
        sdram_clk       : out    vl_logic;
        uart_rxd        : in     vl_logic;
        uart_txd        : out    vl_logic;
        freq_a_export   : in     vl_logic_vector(31 downto 0);
        freq_b_export   : in     vl_logic_vector(31 downto 0);
        freq_standard_export: in     vl_logic_vector(31 downto 0);
        time_interval_export: in     vl_logic_vector(31 downto 0);
        duty_cycle_a_export: in     vl_logic_vector(31 downto 0);
        duty_cycle_b_export: in     vl_logic_vector(31 downto 0);
        whole_time_a_export: in     vl_logic_vector(31 downto 0);
        whole_time_b_export: in     vl_logic_vector(31 downto 0)
    );
end Nios;
