LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Stack_Reg IS
	PORT (
		stack_in: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		clk_in: IN STD_LOGIC;
		nrst: IN STD_LOGIC;
		stack_push:IN STD_LOGIC;
		stack_pop:IN STD_LOGIC;
		
		stack_out: OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF Stack_Reg IS
	SIGNAL PilhaPos1, PilhaPos2, PilhaPos3, PilhaPos4, PilhaPos5, PilhaPos6, PilhaPos7, PilhaPos8 : STD_LOGIC_VECTOR(12 DOWNTO 0);  
BEGIN
	
	PROCESS(clk_in, stack_push, stack_pop, nrst)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF stack_pop = '1' THEN
				PilhaPos1 <= PilhaPos2;
				PilhaPos2 <= PilhaPos3;
				PilhaPos3 <= PilhaPos4;
				PilhaPos4 <= PilhaPos5;
				PilhaPos5 <= PilhaPos6;
				PilhaPos6 <= PilhaPos7;
				PilhaPos7 <= PilhaPos8;
				PilhaPos8 <= "0000000000000";
			ELSIF stack_push = '1' THEN
				PilhaPos8 <= PilhaPos7;
				PilhaPos7 <= PilhaPos6;
				PilhaPos6 <= PilhaPos5;
				PilhaPos5 <= PilhaPos4;
				PilhaPos4 <= PilhaPos3;
				PilhaPos3 <= PilhaPos2;
				PilhaPos2 <= PilhaPos1;
				PilhaPos1 <= Stack_in; 
			END IF;
		END IF;
		
		IF nrst = '0' THEN
			PilhaPos1 <= "0000000000000";
			PilhaPos2 <= "0000000000000";
			PilhaPos3 <= "0000000000000";
			PilhaPos4 <= "0000000000000";
			PilhaPos5 <= "0000000000000";
			PilhaPos6 <= "0000000000000";
			PilhaPos7 <= "0000000000000";
			PilhaPos8 <= "0000000000000";
		END IF;
	END PROCESS;
	
	stack_out <= PilhaPos1;

END arch;