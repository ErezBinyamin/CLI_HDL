-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Full_Adder_1bit_tb is
end;

architecture bench of Full_Adder_1bit_tb is

  component Full_Adder_1bit
       port
       (
            A     :   in   STD_LOGIC;
            B     :   in   STD_LOGIC;
            Cin   :   in   STD_LOGIC;
            Sum   :   out  STD_LOGIC;
            Cout  :   out  STD_LOGIC
       );
  end component;

  signal A   : STD_LOGIC := '0';
  signal B   : STD_LOGIC := '0';
  signal Cin : STD_LOGIC := '0';
  signal Cout: STD_LOGIC := '0';
  signal Sum : STD_LOGIC := '0';

  signal test_vector  : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
  constant CLK_PERIOD : TIME := 10 ns;
begin

  uut: Full_Adder_1bit port map ( A    => A,
                                  B    => B,
                                  Cin  => Cin,
                                  Sum  => Sum,
                                  Cout => Cout );

  stimulus: process
  begin

	  for i in 0 to 8 loop
		  wait for CLK_PERIOD;
		  test_vector <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, test_vector'length));
		  A   <= test_vector(0);
		  B   <= test_vector(1);
		  Cin <= test_vector(2);
		  wait for CLK_PERIOD;
	  end loop;

 	A   <= '0';
	B   <= '0';
	Cin <= '0';
	wait for CLK_PERIOD;
	wait;
end process;


end;
