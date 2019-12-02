-- AUTHOR: Erez Binyamin
-- DESIGN NAME: MISR.vhd
-- SHORT DESCRIPTION:
--     Takes an 8-bit output from a circuit
--     and generates a unique signature
--     for that output.
-- For more taps visit
--			http://courses.cse.tamu.edu/walker/csce680/lfsr_table.pdf

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-----------------------------------------------------------
----------     Linear Feedback Shift Register    ----------
-- *                                                      *
-- *                                                      *
-- *        __  _______________________________________   *
-- *     _ (  //                                      |   *
-- *    |  (__\\___________________________           |   *
-- *    |   ___         ___         ___    |    ___   |   *
-- *    |--|D Q|--- ---|D Q|-------|D Q|---o---|D Q|--o   *
-- *       |   |       |   |       |   |       |   |      *
-- *       |>  |       |>  |       |>  |       |>  |      *
-- *        ---         ---         ---         ---       *
-----------------------------------------------------------
entity MISR is
    port (
    --INPUTS
            clk         : in std_logic;
            rst         : in std_logic;
            enable      : in std_logic;
            mult_r      : in std_logic_vector(7 downto 0);
    --OUTPUTS
            signature   : out std_logic_vector(7 downto 0)
    );
end MISR;

architecture Behavioral of MISR is
	signal xnorn : std_logic_vector(7 downto 0) := "00000001";  --DEFAULT TO 1 because 0 is a NO NO
	begin
		process (clk) is
		begin
			if (rising_edge(clk)) then
				if rst = '0' then
					xnorn <= "00000001"; --DEFAULT TO 1 because 0 is a NO NO
				else
				if enable = '1' then
					xnorn(0) <=    mult_r(0) xnor xnorn(3) xnor xnorn(4) xnor xnorn(5) xnor xnorn(7); --TAPS
					xnorn(1) <=    mult_r(1) xnor xnorn(0); --DFF with xnor 
					xnorn(2) <=    mult_r(2) xnor xnorn(1); --DFF with xnor 
					xnorn(3) <=    mult_r(3) xnor xnorn(2); --DFF with xnor 
					xnorn(4) <=    mult_r(4) xnor xnorn(3); --DFF with xnor
					xnorn(5) <=    mult_r(5) xnor xnorn(4); --DFF with xnor 
					xnorn(6) <=    mult_r(6) xnor xnorn(5); --DFF with xnor 
					xnorn(7) <=    mult_r(7) xnor xnorn(6); --DFF with xnor 
				else
					xnorn <= xnorn; --HOLD
				end if;
			end if;
		end if;
	end process;
	signature <= xnorn;
end Behavioral;

