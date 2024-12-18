LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY W_reg8 IS
    PORT (
        nclr, clk, e : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
ARCHITECTURE arch1 OF W_reg8 IS
BEGIN
    PROCESS (nclr, clk, e)
    BEGIN
        IF nclr = '0' THEN
            q <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk) AND e = '1' THEN
            q <= d;
        END IF;
    END PROCESS;
END arch1;