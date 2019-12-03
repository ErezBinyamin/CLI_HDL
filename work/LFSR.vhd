-- AUTHOR: Erez Binyamin
-- DESIGN NAME: LFSR.vhd
-- SHORT DESCRIPTION:
--      An 8-bit Linear feedback shift register
--      For generating a random number sequence
--      as an input to an 4-bit multiplier.
--      (Generating the A and B inputs)
-- For More Taps visit:
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
entity LFSR is
    port (
    --INPUTS
            clk     : in std_logic;
            rst     : in std_logic;
            enable  : in std_logic;
    --OUTPUTS
            bit_p   : out std_logic_vector(15 downto 0)
    );
end LFSR;

architecture Behavioral of LFSR is
    signal xnorn : std_logic_vector(15 downto 0) := "0000000000000001"; --DEFAULT TO 1 because 0 is a NO NO
begin

--SYNCHRONOUS shift register
--with a bit of LFSR pizaz (taps)
    process (clk) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "0000000000000001"; --RESET
                else
                    if enable = '1' then
                        xnorn(0) <= xnorn(15) xnor xnorn(13) xnor xnorn(12) xnor xnorn(10); --TAPS
                        xnorn(1) <= xnorn(0); --DFF
                        xnorn(2) <= xnorn(1); --DFF
                        xnorn(3) <= xnorn(2); --DFF
                        xnorn(4) <= xnorn(3); --DFF
                        xnorn(5) <= xnorn(4); --DFF
                        xnorn(6) <= xnorn(5); --DFF
                        xnorn(7) <= xnorn(6); --DFF
                        xnorn(8) <= xnorn(7); --DFF
                        xnorn(9) <= xnorn(8); --DFF
                        xnorn(10) <= xnorn(9); --DFF
                        xnorn(11) <= xnorn(10); --DFF
                        xnorn(12) <= xnorn(11); --DFF
                        xnorn(13) <= xnorn(12); --DFF
                        xnorn(14) <= xnorn(13); --DFF
                        xnorn(15) <= xnorn(14); --DFF
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
bit_p <= xnorn; --OUTPUT assign
end Behavioral;

