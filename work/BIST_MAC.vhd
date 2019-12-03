----------------------------------------------------------------------------------
-- Company : RIT
-- Engineer: Erez Binyamin
--
-- Create Date:    8:12:25 12/02/19
-- Design Name:
-- Module Name:    BIST_MAC - Structural
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies: MAC.vhd LFSR.vhd MISR.vhd
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
-- *          MAC Unit with Built in self test         * -- 
-----------------------------------------------------------
-- *        tst_mode            A           B          * -- 
-- *           |                |           |          * -- 
-- *           |   ------       |           |          * -- 
-- *           +--| LFSR |      |           |          * -- 
-- *           |   ------       |           |          * -- 
-- *           |      |         |           |          * -- 
-- *           |  lfsr_out      |           |          * -- 
-- *           |      |         |           |          * -- 
-- *           +------+--------[?]          |          * -- 
-- *           |                |           |          * -- 
-- *           |              mac_A         |          * -- 
-- *           |                |           |          * -- 
-- *           |              ------------------       * -- 
-- *           |             |       MAC        |      * -- 
-- *           |              ------------------       * -- 
-- *           |                      |                * -- 
-- *           |                   mac_out             * -- 
-- *           |                      |                * -- 
-- *           +---------------------[?]------+        * -- 
-- *           |                      |       |        * -- 
-- *           |                   -------    |        * -- 
-- *           +------------------|  MISR |   |        * -- 
-- *           |                   -------    |        * -- 
-- *           |                      |       |        * -- 
-- *           |                      |       |        * -- 
-- *           +---------------------[?]------+        * -- 
-- *                                  |                * -- 
-- *                                output             * -- 
-----------------------------------------------------------


entity BIST_MAC is
    generic (n : integer := 16);
    port
     (
	  tst_mode :   in     STD_LOGIC; 
          A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
	  rst      :   in     STD_LOGIC;
	  clk      :   in     STD_LOGIC;
	  output   :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
     );
end MAC;

architecture Structural of BIST_MAC is

begin
	-- LFSR Input
	rand_in : entity work.LFSR
	port map
	(
	    clk     => clk,
	    rst     => rst,
	    enable  => tst_mode,
	    bit_p   => lfsr_out
	);

	-- MAC Unit
	MacU: entity work.MAC
	generic map (N => n)
	port map
	(
	    A       =>  mac_A,
	    B       =>  mac_B,
	    rst     =>  rst,
	    clk     =>  clk,
	    mac_out =>  mac_out
	);

	-- MISR Check output
	rand_in : entity work.MISR
	port map
	(
	    clk       => clk,
	    rst       => rst,
	    enable    => tst_mode,
	    mult_r    => mac_out,
	    signature => misr_sig,
	);

	-- Logic for tst vs not tst
end Structural;

