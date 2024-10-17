LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Status IS
	PORT (
		abus_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		dbus_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		z_in: IN STD_LOGIC;
		dc_in: IN STD_LOGIC;
		c_in: IN STD_LOGIC;
		z_wr_en: IN STD_LOGIC;
		dc_wr_en: IN STD_LOGIC;
		c_wr_en: IN STD_LOGIC;
		clk_in: IN STD_LOGIC;
		nrst: IN STD_LOGIC;
		wr_en:IN STD_LOGIC;
		rd_en:IN STD_LOGIC;
		
		dbus_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		rp_out: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		irp_out: OUT STD_LOGIC;
		z_out: OUT STD_LOGIC;
		dc_out: OUT STD_LOGIC;
		c_out: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE arch OF Status IS
	SIGNAL ContReg: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	
	PROCESS(clk_in, wr_en, z_in, dc_in, c_in, nrst)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF wr_en = '1' AND abus_in = "0000011" THEN
				ContReg <= dbus_in;
			END IF;
			
			IF z_wr_en = '1' THEN
				ContReg(2) <= z_in;
			END IF;
			
			IF dc_wr_en = '1' THEN
				ContReg(1) <= dc_in;
			END IF;
			
			IF c_wr_en = '1' THEN
				ContReg(0) <= c_in;
			END IF;
		END IF;
		
		IF nrst = '0' THEN 
			ContReg <= "00000000";
		END IF;
	END PROCESS;
	
	dbus_out <= ContReg WHEN rd_en = '1' AND abus_in = "0000011" ELSE "ZZZZZZZZ";
	irp_out <= ContReg(7);
	rp_out <= ContReg(6 DOWNTO 5);
	z_out <= ContReg(2);
	dc_out <= ContReg(1);
	c_out <= ContReg(0);

END arch;