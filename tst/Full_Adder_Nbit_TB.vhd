-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Full_Adder_Nbit_tb is
end;

architecture bench of Full_Adder_Nbit_tb is

    constant N : INTEGER := 32;

    signal A   : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal B   : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
    signal Cin : STD_LOGIC := '0';
    signal Cout: STD_LOGIC := '0';
    signal Sum : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');

  constant CLK_PERIOD : TIME := 10 ns;
begin
    uut: entity work.Full_Adder_Nbit 
        generic map( N => N )
	    port map ( A    => A,
                   B    => B,
                   Cin  => Cin,
                   Sum  => Sum,
                   Cout => Cout );

    stimulus: process
    begin
        -- Basic Test Cases
	    wait for CLK_PERIOD;
        -- 0 + 0 = 0
	    A <= (others => '0');
	    B <= (others => '0');
        wait for CLK_PERIOD;
        assert unsigned(Sum) = 0 report integer'image(to_integer(unsigned(A))) & " + " &
                                        integer'image(to_integer(unsigned(B))) & " = " &
                                        integer'image(to_integer(unsigned(Sum)))
                                        severity error;
        -- 1 + 2 = 3
	    A <= (0 => '1', others => '0');
	    B <= (1 => '1', others => '0');
        wait for CLK_PERIOD;
        assert unsigned(Sum) = 3 report integer'image(to_integer(unsigned(A))) & " + " &
                                        integer'image(to_integer(unsigned(B))) & " = " &
                                        integer'image(to_integer(unsigned(Sum)))
                                        severity error;
        -- Add everything
	    Cin <= '0';
	    for i in 0 to 15 loop
	        for j in 0 to 15 loop
                wait for CLK_PERIOD;
                A <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, A'length));
                wait for CLK_PERIOD;
                end loop;
            B <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, B'length));
	    end loop;

	    -- Reset
	    wait for CLK_PERIOD;
	    A <= (others => '0');
	    B <= (others => '0');
	    wait for CLK_PERIOD;

	    -- Subtract everything
	    Cin <= '1';
	    for i in 0 to 15 loop
	    	for j in 0 to 15 loop
	        	wait for CLK_PERIOD;
	      	A <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, A'length));
	        	wait for CLK_PERIOD;
	    	end loop;
	      B <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, B'length));
	    end loop;

  	    wait;
end process;


end;
