--------------------------------------------------------------------------------
-- Company: 		YTHH
-- Engineer:		Lv Zhaokang
--
-- Create Date:    23:24:31 05/20/09
-- Design Name:    DDS---AD9854
-- Module Name:    graduation - Behavioral
-- Project Name:   Graduation
-- Target Device:  xc95144xl-5tq144
-- Tool versions:  Xilinx 7.1i
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

entity graduation is

   Port (  clk : in std_logic;
           mst_rst : out std_logic;
           d : out std_logic_vector(7 downto 0);
           a : out std_logic_vector(5 downto 0);
           wrb : out std_logic;
           io_ud : out std_logic;
			  fsk:out std_logic;
			  dial:in std_logic_vector(2 downto 0)
	     );
end graduation;

architecture Behavioral of graduation is



          signal data_tmp :std_logic_vector(7 downto 0);		     --数据寄存器
			 signal address_tmp :std_logic_vector(5 downto 0);		  --地址寄存器
			 signal cl   :std_logic;						              --输出时钟
			 signal count:std_logic_vector(5 downto 0);		        --时钟计数器
			 signal dount:std_logic_vector(5 downto 0);		        --数据计数器
			 signal output1:std_logic_vector(7 downto 0);
			 signal output2:std_logic_vector(7 downto 0);	 
			 signal state:std_logic_vector(19 downto 0);
   		 signal fskhold:std_logic;
--	 		 signal div:std_logic_vector(8 downto 0);
--			 signal phase1:std_logic_vector(13 downto 0);
--			 signal phase2:std_logic_vector(13 downto 0);
	 		 signal div:std_logic_vector(11 downto 0);


begin

		  cl<=clk;
		  wrb<=not cl;

		  fsk<=fskhold;
		  

		  process(clk)
		  begin
		  if(clk'event and clk='1')then
		  state<=state+'1';
		  if(state(19)='1')then
		  output1<="00000111"; 
		  output2<="11111011"; 
		  else
		  output1<="00000000";
		  output2<="00000000";
		  end if;
		  end if;
		  end process;

		  process(clk)
		  begin
		  if(clk'event and clk='1')then
		  div<=div+'1';
		  if(div(11)='1')then
		  fskhold<='1';
		  else
		  fskhold<='0';
		  end if;
		  end if;
		  end process;

		  process(clk)
		  begin
		  if(clk'event and clk='1')then 
		  if(dount<=4)then
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
		  if(count=40)then	count<="000000";	else	 count<=count+'1'; end if;
        if      count=23  then   io_ud<='1';else io_ud<='0';end if;		  
		  case dial is
		          
					  when "100" =>	 -----------fsk

					 
					  if      count=6   then   address_tmp<="000100";   data_tmp<="00000000";		
				     elsif   count=7   then   address_tmp<="000101";   data_tmp<="10010101";				
					  elsif   count=8   then   address_tmp<="000110";   data_tmp<="00011000";		 		
					  elsif   count=9   then   address_tmp<="000111";   data_tmp<="00001001";		  
					  elsif   count=10  then   address_tmp<="001000";   data_tmp<="00001011";					 
					  elsif   count=11  then   address_tmp<="001001";   data_tmp<="01000001";

        

					  elsif   count=12   then   address_tmp<="001010";   data_tmp<="00000010";		
				     elsif   count=13   then   address_tmp<="001011";   data_tmp<="01011101";			
					  elsif   count=14   then   address_tmp<="001100";   data_tmp<="11111111";			
					  elsif   count=15   then   address_tmp<="001101";   data_tmp<="11110111";		  
					  elsif   count=16   then   address_tmp<="001110";   data_tmp<="11111111";
					  elsif   count=17   then   address_tmp<="001111";   data_tmp<="11011101";

 

					  elsif   count=18  then    address_tmp<="011101";   data_tmp<="00000000"; 	 	
					  elsif   count=19  then    address_tmp<="011110";   data_tmp<="00000101";  		 	
					  elsif   count=20  then    address_tmp<="011111";   data_tmp<="00000010";    	 				
					  elsif   count=21  then    address_tmp<="100000";   data_tmp<="01000000"; 						  
					     
					  end if;


                 when "010"  =>		 ---------psk
					
					  if      count=6   then   address_tmp<="000100";   data_tmp<="00000000";		
				     elsif   count=7   then   address_tmp<="000101";   data_tmp<="00011001";				
					  elsif   count=8   then   address_tmp<="000110";   data_tmp<="11011000";		 		 
					  elsif   count=9   then   address_tmp<="000111";   data_tmp<="00001001";		  
					  elsif   count=10  then   address_tmp<="001000";   data_tmp<="10001011";				
					  elsif   count=11  then   address_tmp<="001001";   data_tmp<="01000001";

        

					  elsif   count=12   then   address_tmp<="000000";   data_tmp<="00001111";		
				     elsif   count=13   then   address_tmp<="000001";   data_tmp<="11111001";			
					  elsif   count=14   then   address_tmp<="000010";   data_tmp<="00011111";			
					  elsif   count=15   then   address_tmp<="000011";   data_tmp<="11100111";		  

																																		
					  elsif   count=18  then    address_tmp<="011101";   data_tmp<="00000000"; 	 				
					  elsif   count=19  then    address_tmp<="011110";   data_tmp<="00000101";  		 		
					  elsif   count=20  then    address_tmp<="011111";   data_tmp<="00001000";    	 				
					  elsif   count=21  then    address_tmp<="100000";   data_tmp<="01000000"; 						  
					    
					  end if;

					  when "001" =>		  ----ask
				
					  if      count=6   then   address_tmp<="000100";   data_tmp<="00000000";		
				     elsif   count=7   then   address_tmp<="000101";   data_tmp<="01011001";			
					  elsif   count=8   then   address_tmp<="000110";   data_tmp<="11011000";		 		 
					  elsif   count=9   then   address_tmp<="000111";   data_tmp<="00001001";		  
					  elsif   count=10  then   address_tmp<="001000";   data_tmp<="10001011";					 
					  elsif   count=11  then   address_tmp<="001001";   data_tmp<="01000001";

     

					  elsif   count=12   then   address_tmp<="100001";   data_tmp<=output1;		
				     elsif   count=13   then   address_tmp<="100010";   data_tmp<=output2;			
			--		  elsif   count=14   then   address_tmp<="100011";   data_tmp<=output1;	            
			--		  elsif   count=15   then   address_tmp<="100100";   data_tmp<=output2;	  	 
			--																															 
																															
																																		
					  elsif   count=16  then    address_tmp<="011101";   data_tmp<="00010000"; 	 			
					  elsif   count=17  then    address_tmp<="011110";   data_tmp<="00000101";  		 		
					  elsif   count=18  then    address_tmp<="011111";   data_tmp<="00000000";    	 				
					  elsif   count=19  then    address_tmp<="100000";   data_tmp<="01100000"; 						  
					    
					  end if;

					  when others =>


					  end case;
		  		  
		  		 d<=data_tmp;															
		       a<=address_tmp;  

		  end if;																
        																		
		  end process;
----------------------------------------------------------------------------------------------------------------------

end Behavioral;

