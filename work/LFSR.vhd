-- AUTHOR: Erez Binyamin
-- DESIGN NAME: LFSR.vhd
-- SHORT DESCRIPTION:
--      An 8-bit Linear feedback shift register
--      For generating a random number sequence
--      as an input to an 4-bit multiplier.
--      (Generating the A and B inputs)

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
            bit_p   : out std_logic_vector(7 downto 0)
    );
end LFSR;

architecture Behavioral of LFSR is
    signal xnorn : std_logic_vector(7 downto 0) := "00000001"; --DEFAULT TO 1 because 0 is a NO NO
begin

--SYNCHRONOUS shift register
--with a bit of LFSR pizaz (taps)
    process (clk) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "00000001"; --RESET
                else
                    if enable = '1' then
                        xnorn(0) <= xnorn(7) xnor xnorn(5) xnor xnorn(4) xnor xnorn(3); --TAPS
                        xnorn(1) <= xnorn(0); --DFF
                        xnorn(2) <= xnorn(1); --DFF
                        xnorn(3) <= xnorn(2); --DFF
                        xnorn(4) <= xnorn(3); --DFF
                        xnorn(5) <= xnorn(4); --DFF
                        xnorn(6) <= xnorn(5); --DFF
                        xnorn(7) <= xnorn(6); --DFF
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
bit_p <= xnorn; --OUTPUT assign
end Behavioral;

