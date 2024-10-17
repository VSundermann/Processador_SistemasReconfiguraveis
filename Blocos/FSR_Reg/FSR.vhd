LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY FSR IS
	PORT (
		abus_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		dbus_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		clk_in: IN STD_LOGIC;
		nrst: IN STD_LOGIC;
		wr_en:IN STD_LOGIC;
		rd_en:IN STD_LOGIC;
		
		dbus_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		fsr_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF FSR IS
	SIGNAL ContReg: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	
	ContReg <= "00000000" WHEN nrst = '0' ELSE
			   dbus_in WHEN RISING_EDGE(clk_in) AND wr_en = '1' AND abus_in = "0000100";
	
	fsr_out <= ContReg;
	dbus_out <= ContReg WHEN rd_en = '1' AND abus_in = "0000100" ELSE "ZZZZZZZZ";
		
END arch;