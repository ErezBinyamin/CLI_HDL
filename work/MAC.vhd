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
-- *    |             Sum                      2N      * --         
-- *    |              |                               * --                
-- *    |    +---------------------+                   * --               
-- *    +----|       RegMem        |           2N      * --              
-- *         +---------------------+                   * --            
-- *                   |                               * --             
-- *                 MacOut                    2N      * --               
-----------------------------------------------------------


entity MAC is
    generic (n : integer := 4);
    port
     (
          A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          mac_out  :   out    STD_LOGIC_VECTOR((2*n) downto 0)
     );
end MAC;

architecture Behave of MAC is
	signal Product : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Sum     : STD_LOGIC_VECTOR((2*n) downto 0)     := (others => '0');
	signal Cout    : STD_LOGIC                            := '0';
	signal RegMem  : STD_LOGIC_VECTOR((2*n) downto 0)     := (others => '0');
begin
	Product <= (SIGNED(A) * SIGNED(B));
	Sum     <= SIGNED(Product) + SIGNED(RegMem);
	--RegMem  <= Sum;
	--mac_out <= RegMem;
	mac_out <= Sum;
end Behave;

-- architecture Structural of Multiplier is
-- 
-- 	Product STD_LOGIC_VECTOR(((2*n)-1) downto 0);
-- 	Sum STD_LOGIC_VECTOR((2*n) downto 0);
-- 	Cout STD_LOGIC;
-- 	RegMem STD_LOGIC_VECTOR((2*n) downto 0);
-- 
-- begin
-- 
--     Mult : entity work.Full_Adder_Nbit
--     generic map (N => n)
--     port map
--     (
--         A       =>  A,
--         B       =>  B,
--         Product =>  Product
--     );
-- 
--     Add : entity work.Full_Adder_Nbit
--     generic map (N => ((2*N)+1))
--     port map
--     (
--         A    =>    RegMem,
--         B    =>    '0' & Product,
--         Cin  =>    '0',
--         Sum  =>    Sum,
--         Cout =>    Cout
--     );
-- 
--     RegMem <= Sum;
-- 
--     mac_out <= RegMem;
-- 
-- end Structural;
-- 
