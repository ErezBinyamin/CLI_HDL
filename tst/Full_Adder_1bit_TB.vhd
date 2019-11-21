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

  signal A: STD_LOGIC;
  signal B: STD_LOGIC;
  signal Cin: STD_LOGIC;
  signal Sum: STD_LOGIC;
  signal Cout: STD_LOGIC ;

begin

  uut: Full_Adder_1bit port map ( A    => A,
                                  B    => B,
                                  Cin  => Cin,
                                  Sum  => Sum,
                                  Cout => Cout );

  stimulus: process
  begin
  
    -- Put initialisation code here
    A <= '0';
    B <= '0';
    Cin <= '0';
    wait for 10 ns;

    A <= '1';
    B <= '0';
    Cin <= '0';
    wait for 10 ns;

    A <= '0';
    B <= '1';
    Cin <= '0';
    wait for 10 ns;

    A <= '1';
    B <= '1';
    Cin <= '0';
    wait for 10 ns;

    A <= '0';
    B <= '0';
    Cin <= '1';
    wait for 10 ns;

    A <= '1';
    B <= '0';
    Cin <= '1';
    wait for 10 ns;

    A <= '0';
    B <= '1';
    Cin <= '1';
    wait for 10 ns;

    A <= '1';
    B <= '1';
    Cin <= '1';
    wait for 10 ns;

    A <= '0';
    B <= '0';
    Cin <= '0';
    wait for 10 ns;

    wait;
  end process;


end;
