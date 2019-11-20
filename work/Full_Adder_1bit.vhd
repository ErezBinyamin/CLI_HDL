----------------------------------------------------------------------------------
-- Company:  RIT
-- Engineer: Erez Binyamin
-- 
-- Create Date:    19:13:42 10/03/2017 
-- Design Name: 
-- Module Name:    Full_Adder_1bit_1bit - Behavioral 
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

entity Full_Adder_1bit is
     
     port
     (
          A     :   in   STD_LOGIC;
          B     :   in   STD_LOGIC;
          Cin   :   in   STD_LOGIC;
          Sum   :   out  STD_LOGIC;
          Cout  :   out  STD_LOGIC
     );
end Full_Adder_1bit;

architecture Behavioral of Full_Adder_1bit is

signal Two_ones   : STD_LOGIC;
signal Three_ones : STD_LOGIC;

begin

    Three_ones <=  A AND B AND Cin;
    Two_ones   <= ((A AND B) OR (A AND Cin) OR (B AND Cin)) AND (NOT Three_ones);

    Sum        <= (A OR B OR Cin) AND (NOT Two_ones);
    Cout       <=  Two_ones OR Three_ones;

end Behavioral;

