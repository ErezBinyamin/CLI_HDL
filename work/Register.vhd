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

entity RegMem is
     generic (n : integer := 4);
     port
     (
          clk   :   in   STD_LOGIC;
          rst   :   in   STD_LOGIC;
          Data  :   in   STD_LOGIC_VECTOR(n downto 0);
          Mem   :   out  STD_LOGIC_VECTOR(n downto 0)
     );
end RegMem;

architecture Behavioral of RegMem is
begin
	process(clk, Data)
	begin
		if(clk'event and clk = '1')
		then
			if(rst = '0')
			then
				Mem <= Data;
			else
				Mem <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

