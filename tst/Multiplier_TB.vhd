-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Multiplier_tb is
end;

architecture bench of Multiplier_tb is

  constant N : INTEGER := 4;
  component Multiplier
       port
       (
            A       :   in   STD_LOGIC_VECTOR(N-1 downto 0);
            B       :   in   STD_LOGIC_VECTOR(N-1 downto 0);
            Product :   out  STD_LOGIC_VECTOR(((2*N)-1) downto 0)
       );
  end component;

  signal A       : STD_LOGIC_VECTOR(N-1 downto 0);
  signal B       : STD_LOGIC_VECTOR(N-1 downto 0);
  signal Product : STD_LOGIC_VECTOR(((2*N)-1) downto 0);

  constant CLK_PERIOD : TIME := 10 ns;
begin

  uut: Multiplier
 	  --generic map( N => N );
	  port map ( A    => A,
                     B    => B,
                   Product  => Product);

  stimulus: process
  begin

	  -- Reset
	  A <= (others => '0');
	  B <= (others => '0');
	  wait for 2*CLK_PERIOD;

	  -- Multiply everything
	  for i in 0 to 15 loop
	  	for j in 0 to 15 loop
		  	wait for CLK_PERIOD;
			A <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, A'length));
		  	wait for CLK_PERIOD;
		--	assert (to_integer(unsigned(Product)) = i*j) report integer'image(i) & " x " & integer'image(j) & " = " & integer'image(i*j);
		end loop;
		B <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, B'length));
	  end loop;

	  -- Reset
	  wait for CLK_PERIOD;
	  A <= (others => '0');
	  B <= (others => '0');
	  wait for 2*CLK_PERIOD;
  	  wait;
end process;


end;
