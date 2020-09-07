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

 	  A   <= '0';
	  B   <= '0';
	  Cin <= '0';
	  wait for CLK_PERIOD;

      for i in std_logic range '0' to '1' loop
          for j in std_logic range '0' to '1' loop
              for k in std_logic range '0' to '1' loop
                  A   <= i; 
                  B   <= j;
                  Cin <= k;
		          wait for CLK_PERIOD;
                  assert to_integer(unsigned'('0' & A)) + to_integer(unsigned'('0' & B)) + to_integer(unsigned'('0' & Cin)) = to_integer(unsigned'('0' & Cout & Sum))
                         report "FAIL: " & 
                         integer'image(to_integer(unsigned'('0' & A))) & " + " &
                         integer'image(to_integer(unsigned'('0' & B))) & " + " &
                         integer'image(to_integer(unsigned'('0' & Cin))) & " = " &
                         integer'image(to_integer(unsigned'('0' & Cout & Sum)))
                         severity error;
              end loop;
          end loop;
      end loop;

 	  A   <= '0';
	  B   <= '0';
	  Cin <= '0';
	  wait for CLK_PERIOD;
      wait;
end process;


end;
