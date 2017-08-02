
-- VHDL Instantiation Created from source file sincos.vhd -- 10:48:45 05/06/2009
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT sincos
	PORT(
		clk : IN std_logic;          
		mst_rst : OUT std_logic;
		d : OUT std_logic_vector(7 downto 0);
		a : OUT std_logic_vector(5 downto 0);
		wrb : OUT std_logic;
		io_ud : OUT std_logic
		);
	END COMPONENT;

	Inst_sincos: sincos PORT MAP(
		clk => ,
		mst_rst => ,
		d => ,
		a => ,
		wrb => ,
		io_ud => 
	);


