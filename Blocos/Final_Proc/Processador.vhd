LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Processador_Fim IS
	PORT (
	clk, nrst, alu_z : IN STD_LOGIC;
	opcode : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
	
	op_sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	bit_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	wr_z_en : OUT STD_LOGIC;
	wr_c_en : OUT STD_LOGIC;
	wr_dc_en : OUT STD_LOGIC;
	wr_w_reg_en: OUT STD_LOGIC;
	wr_en : OUT STD_LOGIC;
	rd_en : OUT STD_LOGIC;
	load_pc : OUT STD_LOGIC;
	inc_pc : OUT STD_LOGIC;
	stack_push : OUT STD_LOGIC;
	stack_pop : OUT STD_LOGIC;
	lit_sel : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE arch1 OF Processador_Fim IS
	TYPE stateType IS (rst, fetch_only, fetch_dec_ex);
	SIGNAL presState, nextState : stateType;
	SIGNAL OPtype : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL whichOP : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	
	PROCESS(clk, nrst)
	BEGIN
		IF(nrst = '0') THEN
			presState <= rst;
		ELSIF RISING_EDGE(clk) THEN
			presState <= nextState;
		END IF;
	END PROCESS;
		
	PROCESS(all)
	BEGIN
	
	CASE presState IS
		WHEN rst =>
			nextState <= fetch_only;
			
		WHEN fetch_only =>
			nextState <= fetch_dec_ex;
		
		WHEN fetch_dec_ex =>
			nextState <= fetch_dec_ex;
			
			OPtype <= opcode (13 DOWNTO 12);
			
			CASE OPtype IS
			
				--Opera��es a byte
				WHEN "00" =>
					whichOP <= opcode(11 DOWNTO 8);
					
					CASE whichOP IS
					
						WHEN "0000" => --NoOp // Return // Move W to F
							op_sel <= "1111";
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN --No OP
								nextState <= fetch_only;
								
								IF(opcode(3) = '0')THEN --Checa se � return
									stack_pop <= '1';
								END IF;
							ELSE -- Move W to F
								wr_en <= '1';
							END IF;
							
						WHEN "0001" => --Clear F/W
							op_sel <= "1000";
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0010" => --Subtract W from F
							op_sel <= "0101";
							rd_en <= '1';
							inc_pc <= '1';
							wr_c_en <= '1';
							wr_dc_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0011" => --Decrement F
							op_sel <= "0111";
							inc_pc <= '1';
							rd_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0100" => --OR W with F
							op_sel <= "0000";
							inc_pc <= '1';
							rd_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0101" => -- AND W with F
							op_sel <= "0001";
							inc_pc <= '1';
							rd_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0110" => -- XOR W with F
							op_sel <= "0010";
							inc_pc <= '1';
							rd_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "0111" => -- ADD W with F
							op_sel <= "0100";
							inc_pc <= '1';
							rd_en <= '1';
							wr_c_en <= '1';
							wr_dc_en <= '1';
							wr_z_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1000" => --Move F
							op_sel <= "1110";
							wr_z_en <= '1';
							rd_en <= '1';
							wr_en <= '1';
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1001" => -- Complement F
							op_sel <= "0011";
							wr_z_en <= '1';
							rd_en <= '1';
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1010" => --Increment F
							op_sel <= "0110";
							wr_z_en <= '1';
							rd_en <= '1';
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1011" => --Decrement F, skip if 0
							op_sel <= "0111";
							inc_pc <= '1';
							rd_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
							IF(alu_z = '1')THEN
								--Mudar estado para fetch only
								nextState <= fetch_only;
							END IF;
							
						WHEN "1100" => --Rotate Right
							op_sel <= "1011";
							wr_c_en <= '1';
							rd_en <= '1';
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1101" => --Rotate Left
							op_sel <= "1010";
							wr_c_en <= '1';
							rd_en <= '1';
							inc_pc <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1110" => --Swap Nibles
							op_sel <= "1001";
							inc_pc <= '1';
							rd_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
						WHEN "1111" => -- Increment F, skip if 0
							op_sel <= "0110";
							inc_pc <= '1';
							rd_en <= '1';
							
							IF(opcode(7) = '0')THEN
								--Escreve em W
								wr_w_reg_en <= '1';
							ELSE
								--Escreve em F
								wr_en <= '1';
							END IF;
							
							IF(alu_z = '1')THEN
								--Mudar estado para fetch only
								nextState <= fetch_only;
							END IF;
							
					END CASE;
					
				--Opera��es a bit
				WHEN "01" =>
					whichOP <= "00" & opcode(11 DOWNTO 10);
					
					CASE whichOP IS
						WHEN "00" => --Bit Clear F
							op_sel <= "1100";
							bit_sel <= opcode(9 DOWNTO 7);
							inc_pc <= '1';
							wr_en <= '1';
							rd_en <= '1';
						
						WHEN "01" => --Bit Set F
							op_sel <= "1101";
							bit_sel <= opcode(9 DOWNTO 7);
							inc_pc <= '1';
							wr_en <= '1';
							rd_en <= '1';
							
						WHEN "10" => -- Bit Test F, skip if clear(0)
							op_sel <= "1100";
							bit_sel <= opcode(9 DOWNTO 7);
							inc_pc <= '1';
							rd_en <= '1';
							
							IF(alu_z = '0') THEN
								--Mudar estado para fetch only
								nextState <= fetch_only;
							END IF;
							
						WHEN "11" => -- Bit Test F, skip if set(1)
							op_sel <= "1101";
							bit_sel <= opcode(9 DOWNTO 7);
							inc_pc <= '1';
							rd_en <= '1';
							
							IF(alu_z = '1') THEN
							--Mudar estado para fetch only
							nextState <= fetch_only;
							END IF;
							
						END CASE;
						
				--Opera��es de desvio
				WHEN "10" =>
					IF(opcode(11) = '0')THEN -- Call subroutine
						nextState <= fetch_only;
						load_pc <= '1';
						stack_push <= '1';
					ELSE -- Go To 
						nextState <= fetch_only;
						load_pc <= '1';
					END IF;
					
				--Opera��es literais
				WHEN "11" =>
					whichOP <= opcode(11 DOWNTO 8);
					
					CASE whichOP IS
						WHEN "0000" | "0001" | "0010" | "0011" => --Move Literal To W
							lit_sel <= '1';
							inc_pc <= '1';
							wr_w_reg_en <= '1';
						
						WHEN "0100" | "0101" | "0110" | "0111" => --Rteurn with Literal in W
							nextState <= fetch_only;
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
							stack_pop <= '1';
							
						WHEN "1000" => -- OR Literal with W
							op_sel <= "0000";
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
							
						WHEN "1001" => -- AND Literal with W
							op_sel <= "0001";
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
							
						WHEN "1010" => -- XOR Literal with W
							op_sel <= "0010";
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
						
						WHEN "1100" | "1101" => -- Sub W from Literal
							op_sel <= "0101";
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
						
						WHEN "1110" | "1111" => -- ADD W and Literal
							op_sel <= "0100";
							inc_pc <= '1';
							lit_sel <= '1';
							wr_w_reg_en <= '1';
						
					END CASE;
						
			END CASE;
			
		END CASE;
			
	END PROCESS;
	
END arch1;

-- MUDAR OS ENDERE�OS DAS PORTS, pagina 18 da documenta��o

-- N�o fazer essas instru��es 
-- Return from interrupt / Clear watchdog timer / Go into standby mode