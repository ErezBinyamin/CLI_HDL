-- AUTHOR: Erez Binyamin
-- DESIGN NAME: LFSR.vhd
-- SHORT DESCRIPTION:
--      A 32-bit Linear feedback shift register
--      For generating a random number sequence
--      as an input to an 16-bit multiplier.
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
            bit_p   : out std_logic_vector(31 downto 0)
    );
end LFSR;

architecture Behavioral of LFSR is
    signal xnorn : std_logic_vector(31 downto 0) := "00000000000000000000000000000001"; --DEFAULT TO 1 because 0 is a NO NO
begin

--SYNCHRONOUS shift register
--with a bit of LFSR pizaz (taps)
    process (clk) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "00000000000000000000000000000001"; --RESET
                else
                    if enable = '1' then
                        xnorn(0) <= xnorn(31) xnor xnorn(29) xnor xnorn(25) xnor xnorn(24); --TAPS
                        xnorn(1) <= xnorn(0);   --DFF
                        xnorn(2) <= xnorn(1);   --DFF
                        xnorn(3) <= xnorn(2);   --DFF
                        xnorn(4) <= xnorn(3);   --DFF
                        xnorn(5) <= xnorn(4);   --DFF
                        xnorn(6) <= xnorn(5);   --DFF
                        xnorn(7) <= xnorn(6);   --DFF
                        xnorn(8) <= xnorn(7);   --DFF
                        xnorn(9) <= xnorn(8);   --DFF
                        xnorn(10) <= xnorn(9);  --DFF
                        xnorn(11) <= xnorn(10); --DFF
                        xnorn(12) <= xnorn(11); --DFF
                        xnorn(13) <= xnorn(12); --DFF
                        xnorn(14) <= xnorn(13); --DFF
                        xnorn(15) <= xnorn(14); --DFF
                        xnorn(16) <= xnorn(15); --DFF
                        xnorn(17) <= xnorn(16); --DFF
                        xnorn(18) <= xnorn(17); --DFF
                        xnorn(19) <= xnorn(18); --DFF
                        xnorn(20) <= xnorn(19); --DFF
                        xnorn(21) <= xnorn(20); --DFF
                        xnorn(22) <= xnorn(21); --DFF
                        xnorn(23) <= xnorn(22); --DFF
                        xnorn(24) <= xnorn(23); --DFF
                        xnorn(25) <= xnorn(24); --DFF
                        xnorn(26) <= xnorn(25); --DFF
                        xnorn(27) <= xnorn(26); --DFF
                        xnorn(28) <= xnorn(27); --DFF
                        xnorn(29) <= xnorn(28); --DFF
                        xnorn(30) <= xnorn(29); --DFF
                        xnorn(31) <= xnorn(30); --DFF
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
bit_p <= xnorn; --OUTPUT assign
end Behavioral;

