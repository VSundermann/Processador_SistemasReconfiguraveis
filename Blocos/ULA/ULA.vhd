LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ULA IS
	PORT (
		a_in, b_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_in: IN STD_LOGIC;
		op_sel: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bit_sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		r_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_out: OUT STD_LOGIC;
		dc_out: OUT STD_LOGIC;
		z_out: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE arch OF ULA IS
	SIGNAL aux : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL vetorBCS : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN
	
	WITH bit_sel SELECT
		vetorBCS <= "11111110" WHEN "000",
					"11111101" WHEN "001",
					"11111011" WHEN "010",
					"11110111" WHEN "011",
					"11101111" WHEN "100",
					"11011111" WHEN "101",
					"10111111" WHEN "110",
					"01111111" WHEN "111";
		
	
	WITH op_sel SELECT
		aux <= '0' & (a_in OR b_in) WHEN "0000",
			   '0' & (a_in AND b_in) WHEN "0001",
			   ('0' & a_in) XOR ('0' & b_in) WHEN "0010",
			   '0' & NOT a_in WHEN "0011",
			   ('0' & a_in) + ('0' & b_in) WHEN "0100",
			   ('0' & a_in) - ('0' & b_in) WHEN "0101",
			   ('0' & a_in) + 1 WHEN "0110",
			   ('0' & a_in) - 1 WHEN "0111",
			   "000000000" WHEN "1000",
		       '0' & a_in(3 DOWNTO 0) & a_in(7 DOWNTO 4) WHEN "1001",
		       '0' & a_in(6 DOWNTO 0) & c_in WHEN "1010",
			   '0' & c_in & a_in(6 DOWNTO 0) WHEN "1011",
			   '0' & a_in AND vetorBCS WHEN "1100",
			   '0' & a_in OR NOT vetorBCS WHEN "1101",
			   '0' & a_in WHEN "1110",
			   '0' & b_in WHEN "1111";
			    
		r_out <= aux(7 DOWNTO 0);
		
		z_out <= '1' WHEN op_sel <= "1000" AND aux = "000000000" ELSE '0'; --Revisar
		
		WITH op_sel SELECT
		c_out <= aux(8) WHEN "0100",
			     aux(7) WHEN "0101",
			    a_in(7) WHEN "1010",
			    a_in(0) WHEN "1011",
			        '0' WHEN OTHERS;	 
		
		dc_out <= a_in(3) AND b_in(3) WHEN op_sel = "0100" ELSE
			  a_in(4) AND b_in(4) WHEN op_sel = "0101" ELSE
			  '0';
		
END arch;