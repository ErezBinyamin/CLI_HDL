-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MAC_tb is
end;

architecture bench of MAC_tb is

  constant N : INTEGER := 4;
  component MAC
      port
       (
            A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
            B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
            mac_out  :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
       );
  end component;

  signal A: STD_LOGIC_VECTOR(n-1 downto 0);
  signal B: STD_LOGIC_VECTOR(n-1 downto 0);
  signal mac_out: STD_LOGIC_VECTOR(((2*n)-1) downto 0) ;
  constant CLK_PERIOD : TIME := 10 ns;

begin

  -- Insert values for generic parameters !!
  uut: MAC
              port map ( A       => A,
                         B       => B,
                         mac_out => mac_out );

  stimulus: process
  begin

	-- Reset
	wait for CLK_PERIOD;
	A <= (others => '0');
	B <= (others => '0');
	wait for CLK_PERIOD;

	-- Put test bench stimulus code here
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

    wait;
  end process;


end;
