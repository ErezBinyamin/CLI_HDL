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
            mac_out  :   out    STD_LOGIC_VECTOR((2*n) downto 0)
       );
  end component;

  signal A: STD_LOGIC_VECTOR(n-1 downto 0);
  signal B: STD_LOGIC_VECTOR(n-1 downto 0);
  signal mac_out: STD_LOGIC_VECTOR((2*n) downto 0) ;

begin

  -- Insert values for generic parameters !!
  uut: MAC
              port map ( A       => A,
                         B       => B,
                         mac_out => mac_out );

  stimulus: process
  begin
  
    -- Put initialisation code here
    A <= (others => '0');
    B <= (others => '0');

    -- Put test bench stimulus code here

    wait;
  end process;


end;
