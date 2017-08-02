--------------------------------------------------------------------------------
-- Company: 		海军航空工程学院
-- Engineer:	   吕兆康
--
-- Create Date:    22:01:52 05/05/09
-- Design Name:    
-- Module Name:    sincos - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sincos is
  Port (   clk : in std_logic;
           mst_rst : out std_logic;
           d : out std_logic_vector(7 downto 0);
           a : out std_logic_vector(5 downto 0);
           wrb : out std_logic;
           io_ud : out std_logic);
end sincos;

architecture Behavioral of sincos is
		    signal data_tmp :std_logic_vector(7 downto 0);		     --数据寄存器
			 signal address_tmp :std_logic_vector(5 downto 0);		  --地址寄存器
			 signal cl   :std_logic;						              --输出时钟
			 signal count:std_logic_vector(5 downto 0);		        --时钟计数器
			 signal dount:std_logic_vector(5 downto 0);		        --数据计数器

	 
begin
        cl<=clk;
		  wrb<=not cl;

		  process(clk)
		  begin
		  if(clk'event and clk='1')then
		  if(count=36)then
		  count<="000000";
		  else
		  count<=count+'1';
		  end if;
		  end if;
		  end process;

		  process(clk)
		  begin
		  if(clk'event and clk='1')then
		  if(dount<=2)then
		  mst_rst<='1';
		  dount<=dount+'1';
		  else
		  mst_rst<='0';
		  end if;
		  end if;
		  end process;

		  process(clk)
		  begin
		  if(clk'event and clk='1')then 
		 
        if      count=16  then   io_ud<='1';else io_ud<='0'; end if;
		  if      count=4   then   address_tmp<="000100";   data_tmp<="00000011";		--12.25MHZ此时的频点比较稳定，波形也还可以，选用这里的频率控制字可行
	     elsif   count=5   then   address_tmp<="000101";   data_tmp<="11011101";
		  elsif   count=6   then   address_tmp<="000110";   data_tmp<="11111101";
		  elsif   count=7   then   address_tmp<="000111";   data_tmp<="11010101";
		  elsif   count=8   then   address_tmp<="001000";   data_tmp<="01010101";
		  elsif   count=9   then   address_tmp<="001001";   data_tmp<="01010101";

		  elsif   count=10  then    address_tmp<="011101";   data_tmp<="00010100"; 	 	
		  elsif   count=11  then    address_tmp<="011110";   data_tmp<="01001010";  		 			
		  elsif   count=12  then    address_tmp<="011111";   data_tmp<="00000000";    	 	
		  elsif   count=13  then    address_tmp<="100000";   data_tmp<="01000000"; 
		  end if;		  
		  
		  d<=data_tmp;
		  a<=address_tmp;   
		  end if;
		  end process;										  
																
end Behavioral;
