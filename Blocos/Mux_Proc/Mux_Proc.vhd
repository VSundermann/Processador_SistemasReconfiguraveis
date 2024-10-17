LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux_Proc IS
	PORT (
	
		rp_in: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		dir_addr_in: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		irp_in: IN STD_LOGIC;
		ind_addr_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		abus_out: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF Mux_Proc IS
BEGIN
	
	abus_out <= irp_in & ind_addr_in WHEN dir_addr_in = "0000000" ELSE rp_in & dir_addr_in;
 
END arch;