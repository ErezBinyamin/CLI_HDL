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
    process (clk, rst, enable) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "00000000000000000000000000000001"; --RESET
                else
                    if enable = '1' then
			xnorn(30) <= xnorn(31);
			xnorn(29) <= xnorn(30);
			xnorn(28) <= xnorn(29);
			xnorn(27) <= xnorn(28);
			xnorn(26) <= xnorn(27);
			xnorn(25) <= xnorn(26);
			xnorn(24) <= xnorn(25);
			xnorn(23) <= xnorn(24);
			xnorn(22) <= xnorn(23);
			xnorn(21) <= xnorn(22);
			xnorn(20) <= xnorn(21);
			xnorn(19) <= xnorn(20);
			xnorn(18) <= xnorn(19);
			xnorn(17) <= xnorn(18);
			xnorn(16) <= xnorn(17);
			xnorn(15) <= xnorn(16);
			xnorn(14) <= xnorn(15);
			xnorn(13) <= xnorn(14);
			xnorn(12) <= xnorn(13);
			xnorn(11) <= xnorn(12);
			xnorn(10) <= xnorn(11);
			xnorn(9) <= xnorn(10);
			xnorn(8) <= xnorn(9);
			xnorn(7) <= xnorn(8);
			xnorn(6) <= xnorn(7);
			xnorn(5) <= xnorn(6);
			xnorn(4) <= xnorn(5);
			xnorn(3) <= xnorn(4);
			xnorn(2) <= xnorn(3);
			xnorn(1) <= xnorn(2);
			xnorn(0) <= xnorn(1);
                        xnorn(31) <= xnorn(31) xnor xnorn(28) xnor xnorn(24) xnor xnorn(23); --TAPS
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
bit_p <= xnorn; --OUTPUT assign
end Behavioral;

