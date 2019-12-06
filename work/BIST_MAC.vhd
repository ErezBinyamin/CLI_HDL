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
-- ***      tst_mode            A           B        *** -- 
-- *           |                |           |          * -- 
-- *           |   ------       |           |          * -- 
-- *           +--| LFSR |      |           |          * -- 
-- *           |   ------       |           |          * -- 
-- *           |      |         |           |          * -- 
-- *           |  lfsr_out      |           |          * -- 
-- *           |      |         |           |          * -- 
-- *           +------+--------[?]---------[?]         * -- 
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
-- ***                              output           *** -- 
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
end BIST_MAC;

architecture Structural of BIST_MAC is
	signal lfsr_out : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0'); --32 bit LFSR
	signal lfsr_A   : STD_LOGIC_VECTOR((n-1) downto 0)     := (others => '0'); --16 bit A input
	signal lfsr_B   : STD_LOGIC_VECTOR((n-1) downto 0)     := (others => '0'); --16 bit B input
	signal mac_A    : STD_LOGIC_VECTOR((n-1) downto 0)     := (others => '0'); --16 bit A input
	signal mac_B    : STD_LOGIC_VECTOR((n-1) downto 0)     := (others => '0'); --16 bit B input
	signal mac_out  : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0'); --32 bit mac output
	signal misr_sig : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0'); --32 bit MISR signature
begin
	-- LFSR Input
	lfsr_in : entity work.LFSR
	port map
	(
	    clk     => clk,
	    rst     => clk,       --IDK why but we had to do this
	    enable  => tst_mode,

	    bit_p   => lfsr_out
	);

	-- Assign LFSR inputs to MAC
	lfsr_A <= lfsr_out(((2*n)-1) downto n);
        lfsr_B <= lfsr_out((n-1) downto 0);

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
	misr_out : entity work.MISR
	port map
	(
	    clk       => clk,
	    rst       => clk,       -- Fukin insane
	    enable    => tst_mode,
	    mult_r    => mac_out,

	    signature => misr_sig
	);

	-- Logic for tst vs not tst
	process(clk)
	begin
		if(clk'event and clk='1')
		then
			if(rst='0' and tst_mode='0')
			then
				mac_A  <= A;
				mac_B  <= B;
				output <= mac_out;
			elsif(rst='0' and tst_mode='1')
			then
				mac_A  <= lfsr_A;
				mac_B  <= lfsr_B;
				output <= misr_sig;
			elsif(rst='1')
			then
				mac_A  <= (others => '0');
				mac_B  <= (others => '0');
				output <= mac_out;
			end if;
		end if;
	end process;
end Structural;

