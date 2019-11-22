----------------------------------------------------------------------------------
-- Company : RIT
-- Engineer: Erez Binyamin
--
-- Create Date:    20:20:52 10/03/2017
-- Design Name:
-- Module Name:    MAC - Structural
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies: Full_Adder_Nbit
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-----------------------------------------------------------
-- *                     MAC UNIT                      * -- 
-----------------------------------------------------------
-- *         A                   B            N-1      * --   
-- *         |                   |                     * --                      
-- *        +---------------------+                    * --    
-- *         \      Multiply     /                     * --  
-- *          +-----------------+                      * --    
-- *                   |                               * --     
-- *                 Product                (2*N)-1    * --   
-- *                   |_______                        * --          
-- *    ________               |                       * --         
-- *    |      |               |                       * --            
-- *    |   +---------------------+                    * --            
-- *    |    \       Add         /                     * --            
-- *    |     +-----------------+                      * --                  
-- *    |              |                               * --            
-- *    |             Sum                   2N-1      * --         
-- *    |              |                               * --                
-- *    |    +---------------------+                   * --               
-- *    +----|       RegMem        |           2N-1      * --              
-- *         +---------------------+                   * --            
-- *                   |                               * --             
-- *                 MacOut                    2N-1      * --               
-----------------------------------------------------------


entity MAC is
    generic (n : integer := 4);
    port
     (
          A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          mac_out  :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
     );
end MAC;

architecture Structural of MAC is
	signal Product : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal RegMem  : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Sum     : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Cout    : STD_LOGIC                            := '0';
begin
	--process(A, B, Product, RegMem, Sum, Cout)
	--begin

		Mult : entity work.Multiplier
		generic map (N => n)
		port map
		(
		    A       =>  A,
		    B       =>  B,
		    Product =>  Product
		);

		Add : entity work.Full_Adder_Nbit
		generic map (N => (2*N))
		port map
		(
		    A    =>    RegMem,
		    B    =>    Product,
		    Cin  =>    '0',
		    Sum  =>    Sum,
		    Cout =>    Cout
		);

		--RegMem  <= Sum;
		mac_out <= Sum;

	--end process;
end Structural;

