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

-----------------------------------------------------------
-- *                      ADDER                        * -- 
-----------------------------------------------------------
-- *        [A]       [B]       [Cin]                  * --   
-- *         |         |          |                    * --                      
-- *        +---------------------+                    * --    
-- *         \        Adder      /                     * --  
-- *          +-----------------+                      * --    
-- *             |           |                         * --     
-- *           [Sum]       [Cout]                      * --   
-----------------------------------------------------------

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

begin

    Sum        <= A XOR B XOR Cin;
    Cout       <=  ((A AND B) OR (A AND Cin) OR (B AND Cin));

end Behavioral;

