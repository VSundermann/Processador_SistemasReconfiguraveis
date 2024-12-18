LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY RAM IS
	PORT (
		abus_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		dbus_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		nrst: IN STD_LOGIC;
		clk_in: IN STD_LOGIC;
		wr_en: IN STD_LOGIC;
		rd_en: IN STD_LOGIC;
		
		dbus_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	
	);
END ENTITY;

ARCHITECTURE arch OF RAM IS
	SIGNAL mem0, mem1, mem2 : STD_LOGIC_VECTOR(79 DOWNTO 0);
	SIGNAL mem_com : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL aux: INTEGER RANGE 0 TO 511;
BEGIN
	
	aux <= TO_INTEGER(UNSIGNED(abus_in));
	
	--Processo para escrita em um registrador
	PROCESS(clk_in, wr_en, nrst, dbus_in, aux)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF wr_en = '1' THEN
				CASE aux IS
					WHEN 32 TO 111 | 240 TO 255 | 368 TO 383 | 496 TO 511 => 
						mem0(7 DOWNTO 0) <= dbus_in;
					WHEN 112 TO 127 => 
						mem_com(7 DOWNTO 0) <= dbus_in;
					WHEN 160 TO 239 => 
						mem1(7 DOWNTO 0) <= dbus_in;
					WHEN 288 TO 367 => 
						mem2(7 DOWNTO 0) <= dbus_in;
					WHEN OTHERS =>
				END CASE;
			END IF;
			
			IF nrst = '0' THEN
				mem0 <= (OTHERS => '0');
				mem1 <= (OTHERS => '0');
				mem2 <= (OTHERS => '0');
				mem_com <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	
	--Processo para leitura do conteudo de um registrador
	PROCESS(clk_in, aux, rd_en)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF rd_en = '1' THEN
				CASE aux IS
					WHEN 32 TO 111 | 240 TO 255 | 368 TO 383 | 496 TO 511 => 
						dbus_out <= mem0(7 DOWNTO 0);
					WHEN 112 TO 127 => 
						dbus_out <= mem_com(7 DOWNTO 0);
					WHEN 160 TO 239 => 
						dbus_out <= mem1(7 DOWNTO 0);
					WHEN 288 TO 367 => 
						dbus_out <= mem2(7 DOWNTO 0);
					WHEN OTHERS =>
						dbus_out <= "ZZZZZZZZ";
				END CASE;
			ELSE 
				dbus_out <= "ZZZZZZZZ";
			END IF;
		END IF;
	END PROCESS;
	
END arch;