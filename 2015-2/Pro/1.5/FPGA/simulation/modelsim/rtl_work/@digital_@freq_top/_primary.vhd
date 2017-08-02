library verilog;
use verilog.vl_types.all;
entity Digital_Freq_top is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        One_Signal_in   : in     vl_logic;
        Two_Signal_in   : in     vl_logic;
        uart_rxd        : in     vl_logic;
        uart_txd        : out    vl_logic;
        sdram_addr      : out    vl_logic_vector(12 downto 0);
        sdram_ba        : out    vl_logic_vector(1 downto 0);
        sdram_cas_n     : out    vl_logic;
        sdram_cke       : out    vl_logic;
        sdram_cs_n      : out    vl_logic;
        sdram_dq        : inout  vl_logic_vector(15 downto 0);
        sdram_dqm       : out    vl_logic_vector(1 downto 0);
        sdram_ras_n     : out    vl_logic;
        sdram_we_n      : out    vl_logic;
        sdram_clk       : out    vl_logic
    );
end Digital_Freq_top;
