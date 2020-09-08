-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

-- Generate Random numbers
use ieee.math_real.uniform;
use ieee.math_real.floor;

entity Multiplier_tb is
end;

architecture bench of Multiplier_tb is
    constant N : INTEGER := 16;
    signal A       : STD_LOGIC_VECTOR(N-1 downto 0);
    signal B       : STD_LOGIC_VECTOR(N-1 downto 0);
    signal Product : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
    
    constant CLK_PERIOD : TIME := 10 ns;
begin
    uut: entity work.Multiplier
    generic map( N => N )
    port map (
        A        => A,
        B        => B,
        Product  => Product
    );

    stimulus: process is
        variable seed1 : positive;
        variable seed2 : positive;
        variable x : real;
        variable bb : integer;
        variable aa : integer;
    begin
        -- Reset
	A <= (others => '0');
	B <= (others => '0');
	wait for 2*CLK_PERIOD;

	-- Generate random numbers loop
	for i in 0 to 15 loop
            uniform(seed1, seed2, x);
	    bb := integer(floor(x * 1024.0));
	    B <= std_logic_vector(to_unsigned(bb, B'length));
	    for j in 0 to 15 loop
	        uniform(seed1, seed2, x);
	        aa := integer(floor(x * 1024.0));
	        A <= std_logic_vector(to_unsigned(aa, A'length));
	        wait for CLK_PERIOD;
                assert unsigned(Product) = aa * bb
                    report "FAIL: " &
                    integer'image(aa) & " * " &
                    integer'image(bb) & " = " &
                    integer'image(to_integer(unsigned(Product)));
            end loop;
        end loop;

	-- Reset
	wait for CLK_PERIOD;
	A <= (others => '0');
	B <= (others => '0');
	wait for 2*CLK_PERIOD;
  	wait;
    end process;
end;
