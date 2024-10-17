LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ProgramCounter IS
	PORT (
		addr_in: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		abus_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		dbus_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		nrst: IN STD_LOGIC;
		clk_in: IN STD_LOGIC;
		inc_pc: IN STD_LOGIC;
		load_pc: IN STD_LOGIC;
		wr_en: IN STD_LOGIC;
		rd_en: IN STD_LOGIC;
		stack_push: IN STD_LOGIC;
		stack_pop: IN STD_LOGIC;
		
		nextpc_out: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		dbus_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)	
	);
END ENTITY;

ARCHITECTURE arch OF ProgramCounter IS
	SIGNAL PilhaPos1, PilhaPos2, PilhaPos3, PilhaPos4, PilhaPos5, PilhaPos6, PilhaPos7, PilhaPos8 : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL PilhaPoped : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL RegPC : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL LathPC : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	
	--Pilha
	PROCESS(clk_in, stack_push, nrst)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			
			IF stack_pop = '1' THEN
				PilhaPoped <= PilhaPos1;
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
				PilhaPos1 <= RegPC; 
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
	
	--Next
	PROCESS(stack_pop, inc_pc, load_pc, wr_en, abus_in, RegPC, addr_in, LathPC, PilhaPoped, dbus_in)
	BEGIN
		IF stack_pop = '1' THEN
			nextpc_out <= PilhaPoped;
		ELSIF inc_pc = '1' THEN
			nextpc_out <= RegPC + 1;
		ELSIF load_pc = '1' THEN
			nextpc_out(10 DOWNTO 0) <= addr_in(10 DOWNTO 0);
			nextpc_out(12 DOWNTO 11) <= LathPC(4 DOWNTO 3);
		ELSIF wr_en = '1' AND abus_in = "0000010" THEN
			nextpc_out <= LathPC(4 DOWNTO 0) & dbus_in;
		ELSE
			nextpc_out <= RegPC;
		END IF;
	END PROCESS;
	
	--Reg
	PROCESS(clk_in, stack_pop, inc_pc, load_pc, wr_en, abus_in, nrst)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF stack_pop = '1' THEN
				RegPC <= PilhaPoped;
			ELSIF inc_pc = '1' THEN
				RegPC <= RegPC + 1;
			ELSIF load_pc = '1' THEN
				RegPC(10 DOWNTO 0) <= addr_in(10 DOWNTO 0);
				RegPC(12 DOWNTO 11) <= LathPC(4 DOWNTO 3);
			ELSIF wr_en = '1' AND abus_in = "0000010" THEN
				RegPC <= LathPC(4 DOWNTO 0) & dbus_in;
			END IF;
		END IF;
	
		IF nrst = '0' THEN
			RegPC <= "0000000000000";
		END IF;
	END PROCESS;
	
	--Lath
	PROCESS(clk_in, wr_en, abus_in, nrst)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF wr_en = '1' AND abus_in = "0001010" THEN
				LathPC <= dbus_in;
			END IF;
		END IF;
		
		IF nrst = '0' THEN
			LathPC <= "00000000";
		END IF;
	END PROCESS;
	
	--Dbus
	PROCESS(clk_in, rd_en, abus_in, LathPC, RegPC)
	BEGIN
		IF abus_in = "0000101" AND rd_en = '1' THEN
			dbus_out <= LathPC(7 DOWNTO 0);
		ELSIF abus_in = "0000010" AND rd_en = '1' THEN
			dbus_out <= RegPC(7 DOWNTO 0);
		ELSE
			dbus_out <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
	
END arch;