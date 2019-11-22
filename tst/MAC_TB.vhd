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

  constant N : INTEGER := 4;
  component Full_Adder_Nbit
       port
       (
            A     :   in   STD_LOGIC_VECTOR(N-1 downto 0);
            B     :   in   STD_LOGIC_VECTOR(N-1 downto 0);
            Cin   :   in   STD_LOGIC;
            Sum   :   out  STD_LOGIC_VECTOR(N-1 downto 0);
            Cout  :   out  STD_LOGIC
       );
  end component;

  signal A   : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
  signal B   : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
  signal Cin : STD_LOGIC                      := '0';
  signal Cout: STD_LOGIC                      := '0';
  signal Sum : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');

  constant CLK_PERIOD : TIME := 10 ns;
begin

  uut: Full_Adder_Nbit
 	  --generic map( N => N );
	  port map ( A    => A,
                   B    => B,
                   Cin  => Cin,
                   Sum  => Sum,
                   Cout => Cout );

  stimulus: process
  begin

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
