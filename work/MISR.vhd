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
            mult_r      : in std_logic_vector(31 downto 0);
    --OUTPUTS
            signature   : out std_logic_vector(31 downto 0)
    );
end MISR;

architecture Behavioral of MISR is
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
                        xnorn(0)  <= mult_r(0)  xnor xnorn(31) xnor xnorn(29) xnor xnorn(25) xnor xnorn(24); --TAPS
                        xnorn(1)  <= mult_r(1)  xnor xnorn(0);  --DFF
                        xnorn(2)  <= mult_r(2)  xnor xnorn(1);  --DFF
                        xnorn(3)  <= mult_r(3)  xnor xnorn(2);  --DFF
                        xnorn(4)  <= mult_r(4)  xnor xnorn(3);  --DFF
                        xnorn(5)  <= mult_r(5)  xnor xnorn(4);  --DFF
                        xnorn(6)  <= mult_r(6)  xnor xnorn(5);  --DFF
                        xnorn(7)  <= mult_r(7)  xnor xnorn(6);  --DFF
                        xnorn(8)  <= mult_r(8)  xnor xnorn(7);  --DFF
                        xnorn(9)  <= mult_r(9)  xnor xnorn(8);  --DFF
                        xnorn(10) <= mult_r(10) xnor xnorn(9);  --DFF
                        xnorn(11) <= mult_r(11) xnor xnorn(10); --DFF
                        xnorn(12) <= mult_r(12) xnor xnorn(11); --DFF
                        xnorn(13) <= mult_r(13) xnor xnorn(12); --DFF
                        xnorn(14) <= mult_r(14) xnor xnorn(13); --DFF
                        xnorn(15) <= mult_r(15) xnor xnorn(14); --DFF
                        xnorn(16) <= mult_r(16) xnor xnorn(15); --DFF
                        xnorn(17) <= mult_r(17) xnor xnorn(16); --DFF
                        xnorn(18) <= mult_r(18) xnor xnorn(17); --DFF
                        xnorn(19) <= mult_r(19) xnor xnorn(18); --DFF
                        xnorn(20) <= mult_r(20) xnor xnorn(19); --DFF
                        xnorn(21) <= mult_r(21) xnor xnorn(20); --DFF
                        xnorn(22) <= mult_r(22) xnor xnorn(21); --DFF
                        xnorn(23) <= mult_r(23) xnor xnorn(22); --DFF
                        xnorn(24) <= mult_r(24) xnor xnorn(23); --DFF
                        xnorn(25) <= mult_r(25) xnor xnorn(24); --DFF
                        xnorn(26) <= mult_r(26) xnor xnorn(25); --DFF
                        xnorn(27) <= mult_r(27) xnor xnorn(26); --DFF
                        xnorn(28) <= mult_r(28) xnor xnorn(27); --DFF
                        xnorn(29) <= mult_r(29) xnor xnorn(28); --DFF
                        xnorn(30) <= mult_r(30) xnor xnorn(29); --DFF
                        xnorn(31) <= mult_r(31) xnor xnorn(30); --DFF
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
signature <= xnorn; --OUTPUT assign
end Behavioral;

