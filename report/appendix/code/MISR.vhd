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
    signal zero_bit : std_logic := '0';
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
			    zero_bit  <= xnorn(0); -- Save Zero bit for TAPS
			    xnorn(0)  <= mult_r(0) xor xnorn(1);               -- DFF 
			    xnorn(1)  <= mult_r(1) xor xnorn(2);               -- DFF 
			    xnorn(2)  <= mult_r(2) xor xnorn(3);               -- DFF 
			    xnorn(3)  <= mult_r(3) xor xnorn(4);               -- DFF 
			    xnorn(4)  <= mult_r(4) xor xnorn(5);               -- DFF 
			    xnorn(5)  <= mult_r(5) xor xnorn(6);               -- DFF 
			    xnorn(6)  <= mult_r(6) xor xnorn(7);               -- DFF 
			    xnorn(7)  <= mult_r(7) xor xnorn(8);               -- DFF 
			    xnorn(8)  <= mult_r(8) xor xnorn(9);               -- DFF 
			    xnorn(9)  <= mult_r(9) xor xnorn(10);              -- DFF
			    xnorn(10) <= mult_r(10) xor xnorn(11);              -- DFF
			    xnorn(11) <= mult_r(11) xor xnorn(12);              -- DFF
			    xnorn(12) <= mult_r(12) xor xnorn(13);              -- DFF
			    xnorn(13) <= mult_r(13) xor xnorn(14);              -- DFF
			    xnorn(14) <= mult_r(14) xor xnorn(15);              -- DFF
			    xnorn(15) <= mult_r(15) xor xnorn(16);              -- DFF
			    xnorn(16) <= mult_r(16) xor xnorn(17);              -- DFF
			    xnorn(17) <= mult_r(17) xor xnorn(18);              -- DFF
			    xnorn(18) <= mult_r(18) xor xnorn(19);              -- DFF
			    xnorn(19) <= mult_r(19) xor xnorn(20);              -- DFF
			    xnorn(20) <= mult_r(20) xor xnorn(21);              -- DFF
			    xnorn(21) <= mult_r(21) xor xnorn(22);              -- DFF
			    xnorn(22) <= mult_r(22) xor xnorn(23);              -- DFF
			    xnorn(23) <= mult_r(23) xor xnorn(24);              -- DFF
			    xnorn(24) <= mult_r(24) xor xnorn(25);              -- DFF
			    xnorn(25) <= mult_r(25) xor xnorn(26);              -- DFF
			    xnorn(26) <= mult_r(26) xor xnorn(27) xor zero_bit; -- TAP 27
			    xnorn(27) <= mult_r(27) xor xnorn(28);              -- DFF
			    xnorn(28) <= mult_r(28) xor xnorn(29) xor zero_bit; -- TAP 29
			    xnorn(29) <= mult_r(29) xor xnorn(30) xor zero_bit; -- TAP 30
			    xnorn(30) <= mult_r(30) xor xnorn(31);              -- DFF
			    xnorn(31) <= mult_r(31) xor zero_bit;               -- TAP 32
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
signature <= xnorn; --OUTPUT assign
end Behavioral;

