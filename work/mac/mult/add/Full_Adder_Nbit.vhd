----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:20:52 10/03/2017
-- Design Name:
-- Module Name:    Full_Adder_Nbit - Structural
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Cin determines operation of Adder/Subtractor
entity Full_Adder_Nbit is
    generic (N : integer := 32);
    port
     (
        A     :   in     STD_LOGIC_VECTOR(n-1 downto 0);
        B     :   in     STD_LOGIC_VECTOR(n-1 downto 0);
        Cin   :   in     STD_LOGIC;
        Sum   :   out    STD_LOGIC_VECTOR(n-1 downto 0);
        Cout  :   out    STD_LOGIC
     );
end Full_Adder_Nbit;

architecture Structural of Full_Adder_Nbit is

--Will always be one 'extra' carry bit
    signal Carry_array : STD_LOGIC_VECTOR(n downto 0);
--B input is inverted if subtracting
    signal New_B       : STD_LOGIC_VECTOR(n-1 downto 0);

begin
    --Set First Carry
    Carry_array(0) <= Cin;

    --Generate all Adders
    Adders : for i in 0 to n-1 generate

        --Invert B input if subtracting
        New_B(i) <= (B(i) XOR Cin);

         --Create 1-bit Adder
        Full_Adder_i : entity work.Full_Adder_1bit
         port map
         (
              A    =>    A(i),
              B    =>    New_B(i),
              Cin  =>    Carry_array(i),
              Sum  =>    Sum(i),
              Cout =>    Carry_array(i+1)
         );
    end generate;

    -- Set Top level Cout
    -- Trash last bit if subtracting
    -----------------------------------
    -- * Cin  | Last Carry |  Cout  *
    -- *  0   |     0      |   0    *
    -- *  0   |     1      |   1    *
    -- *  1   |     0      |   0    *
    -- *  1   |     1      |   0    *
    -----------------------------------
    Cout <= Carry_array(n) AND (NOT Cin);

end Structural;
