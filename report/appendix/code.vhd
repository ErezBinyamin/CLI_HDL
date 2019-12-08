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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-----------------------------------------------------------
----------         Example for n = 3             ----------
-- *                                                      *
-- *       A     A      ... A                             *
-- *        n-1   n-2        0                            *
-- *    X                             Initial A,B values  *
-- *       B     B      ... B         (n-1 downto 0)      *
-- *        n-1   n-2        0                            *
-- *     ---------------------------                      *
-- *       000 000 A B  A B  A B                          *
-- *       000 000 AND  AND  AND                          *
-- *    +                                                 *
-- *       000 A B A B  A B  000      Partial products    *
-- *       000 AND AND  AND  000      (2n-2 downto 0)     *
-- *    +                                                 *
-- *       A B A B A B  000  000                          *
-- *       AND AND AND  000  000                          *
-- *     ---------------------------                      *
-- *                                                      *
-- *     Cout  SUM SUM SUM SUM SUM    Final Product       *
-- *                                  (2n-1 downto 0)     *
-----------------------------------------------------------
entity Multiplier is
    generic (n : integer := 16);
    port
     (
          A         :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          B         :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          Product   :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
     );
end Multiplier;

--architecture Behave of Multiplier is
--begin
--	Product <= (SIGNED(A) * SIGNED(B));
--end Behave;

architecture Structural of Multiplier is

--Type Define a "vector_array"
    type vector_array is array (n downto 0) of std_logic_vector(((2*n)-2) downto 0);

--Multipling each bit together to generate Partial Product array
    signal Partial_products : vector_array := (others => (others => '0'));

--Adding all partial products using an accumulator and Carry_array for MSB
    signal Accumulator      : vector_array := (others => (others => '0'));
    signal Carry_array      : STD_LOGIC_VECTOR((n-1) downto 0) := (others => '0');

begin

--GENERATE: Partial_products 
--Populate 'n' partial products with AND'ed values of A,B
--Populates i'th vector starting at the j+i'th bit (to account for leading 0's)
    Whcih_Vector : for i in 0 to n-1 generate begin
        Whcih_Bit : for j in 0 to n-1 generate begin
            Partial_products(i)(j+i) <= ((A(j)) AND (B(i)));
        end generate Whcih_Bit;
    end generate Whcih_Vector;

--GENERATE:  Accumulator, and Carry_array
--Add 'n' partial products unsing 'n' '(2n-1)-bit' adders
    Add : for i in 0 to n-1 generate

         Full_Adder_i : entity work.Full_Adder_Nbit
         generic map (N => ((2*N)-1))
         port map
         (
             A    =>    Partial_products(i),
             B    =>    Accumulator(i),
             Cin  =>    '0',
             Sum  =>    Accumulator(i+1),
             Cout =>    Carry_array(i)
         );

    end generate Add;

--Assign final Product output with last Accumulator Vector
--Assign final Product output MSB with last Carry bit
    Product <= Carry_array(n-1) & Accumulator(n);

end Structural;

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
-- *    |             Sum                    2N-1      * --         
-- *    |              |                               * --                
-- *    |    +---------------------+                   * --               
-- *    +----|       RegMem        |         2N-1      * --              
-- *         +---------------------+                   * --            
-- *                   |                               * --             
-- *                 MacOut                  2N-1      * --               
-----------------------------------------------------------


entity MAC is
    generic (n : integer := 16);
    port
     (
          A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
          B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
	  rst      :   in     STD_LOGIC;
	  clk      :   in     STD_LOGIC;
	  mac_out  :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
     );
end MAC;

architecture Structural of MAC is
	signal Product : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Adder_B : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal RegMem  : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Sum     : STD_LOGIC_VECTOR(((2*n)-1) downto 0) := (others => '0');
	signal Cout    : STD_LOGIC                            := '0';

begin
	-- Multiply A and B
	Mult : entity work.Multiplier
	generic map (N => n)
	port map
	(
	    A       =>  A,
	    B       =>  B,
	    Product =>  Product
	);

	--Add Product and RegMem
	 Add : entity work.Full_Adder_Nbit
	 generic map (N => (2*n))
	 port map
	 (
	     A    =>    Product,
	     B    =>    Adder_B,
	     Cin  =>    '0',
	     Sum  =>    Sum,
	     Cout =>    Cout
	 );

	-- Output RegMem
	process(clk, RegMem, Sum)
	begin
		if(clk'event and clk = '1')
		then
			if(rst = '0')
			then
				Adder_B <= RegMem;
				RegMem  <= Sum;
			else
				Adder_B <= (others => '0');
				RegMem  <= (others => '0');
			end if;

			mac_out <= Sum;
		end if;
	end process;

end Structural;

-- DESIGN NAME: LFSR.vhd
-- SHORT DESCRIPTION:
--      A 32-bit Linear feedback shift register
--      For generating a random number sequence
--      as an input to an 16-bit multiplier.
--      (Generating the A and B inputs)
-- For More Taps visit:
--			http://courses.cse.tamu.edu/walker/csce680/lfsr_table.pdf

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-----------------------------------------------------------
----------     Linear Feedback Shift Register    ----------
-- *                                                      *
-- *                                                      *
-- *        __  _______________________________________   *
-- *     _ (  //                                      |   *
-- *    |  (__\\___________________________           |   *
-- *    |   ___         ___         ___    |    ___   |   *
-- *    |--|D Q|--- ---|D Q|-------|D Q|---o---|D Q|--o   *
-- *       |   |       |   |       |   |       |   |      *
-- *       |>  |       |>  |       |>  |       |>  |      *
-- *        ---         ---         ---         ---       *
-----------------------------------------------------------
entity LFSR is
    port (
    --INPUTS
            clk     : in std_logic;
            rst     : in std_logic;
            enable  : in std_logic;
    --OUTPUTS
            bit_p   : out std_logic_vector(31 downto 0)
    );
end LFSR;

architecture Behavioral of LFSR is
    signal xnorn    : std_logic_vector(31 downto 0) := "00000000000000000000000000000001"; --DEFAULT TO 1 because 0 is a NO NO
    signal zero_bit : std_logic := '0';
begin

--SYNCHRONOUS shift register
--with a bit of LFSR pizaz (taps)
    process (clk, rst, enable) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "00000000000000000000000000000001"; --RESET
                else
                    if enable = '1' then
			    zero_bit <= xnorn(0); -- Save Zero bit for TAPS
			    xnorn(0)  <= xnorn(1);               -- DFF 
			    xnorn(1)  <= xnorn(2);               -- DFF 
			    xnorn(2)  <= xnorn(3);               -- DFF 
			    xnorn(3)  <= xnorn(4);               -- DFF 
			    xnorn(4)  <= xnorn(5);               -- DFF 
			    xnorn(5)  <= xnorn(6);               -- DFF 
			    xnorn(6)  <= xnorn(7);               -- DFF 
			    xnorn(7)  <= xnorn(8);               -- DFF 
			    xnorn(8)  <= xnorn(9);               -- DFF 
			    xnorn(9)  <= xnorn(10);              -- DFF
			    xnorn(10) <= xnorn(11);              -- DFF
			    xnorn(11) <= xnorn(12);              -- DFF
			    xnorn(12) <= xnorn(13);              -- DFF
			    xnorn(13) <= xnorn(14);              -- DFF
			    xnorn(14) <= xnorn(15);              -- DFF
			    xnorn(15) <= xnorn(16);              -- DFF
			    xnorn(16) <= xnorn(17);              -- DFF
			    xnorn(17) <= xnorn(18);              -- DFF
			    xnorn(18) <= xnorn(19);              -- DFF
			    xnorn(19) <= xnorn(20);              -- DFF
			    xnorn(20) <= xnorn(21);              -- DFF
			    xnorn(21) <= xnorn(22);              -- DFF
			    xnorn(22) <= xnorn(23);              -- DFF
			    xnorn(23) <= xnorn(24);              -- DFF
			    xnorn(24) <= xnorn(25);              -- DFF
			    xnorn(25) <= xnorn(26);              -- DFF
			    xnorn(26) <= xnorn(27) xor zero_bit; -- TAP 27
			    xnorn(27) <= xnorn(28);              -- DFF
			    xnorn(28) <= xnorn(29) xor zero_bit; -- TAP 29
			    xnorn(29) <= xnorn(30) xor zero_bit; -- TAP 30
			    xnorn(30) <= xnorn(31);              -- DFF
			    xnorn(31) <= zero_bit;               -- TAP 32
	            else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
bit_p <= xnorn; --OUTPUT assign
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MISR is
    port (
    --INPUTS
            clk         : in std_logic;
            rst         : in std_logic;
            enable      : in std_logic;
            mult_r      : in std_logic_vector(31 downto 0);
    --OUTPUTS
            signature   : out std_logic_vector(31 downto 0)
    );
end MISR;

architecture Behavioral of MISR is
    signal xnorn : std_logic_vector(31 downto 0) := "00000000000000000000000000000001"; --DEFAULT TO 1 because 0 is a NO NO
    signal zero_bit : std_logic := '0';
begin

--SYNCHRONOUS shift register
--with a bit of LFSR pizaz (taps)
    process (clk, rst, enable) is
    begin
            if (rising_edge(clk)) then
                if rst = '0' then
                    xnorn <= "00000000000000000000000000000001"; --RESET
                else
                    if enable = '1' then
			    zero_bit  <= xnorn(0); -- Save Zero bit for TAPS
			    xnorn(0)  <= mult_r(0) xor xnorn(1);               -- DFF 
			    xnorn(1)  <= mult_r(1) xor xnorn(2);               -- DFF 
			    xnorn(2)  <= mult_r(2) xor xnorn(3);               -- DFF 
			    xnorn(3)  <= mult_r(3) xor xnorn(4);               -- DFF 
			    xnorn(4)  <= mult_r(4) xor xnorn(5);               -- DFF 
			    xnorn(5)  <= mult_r(5) xor xnorn(6);               -- DFF 
			    xnorn(6)  <= mult_r(6) xor xnorn(7);               -- DFF 
			    xnorn(7)  <= mult_r(7) xor xnorn(8);               -- DFF 
			    xnorn(8)  <= mult_r(8) xor xnorn(9);               -- DFF 
			    xnorn(9)  <= mult_r(9) xor xnorn(10);              -- DFF
			    xnorn(10) <= mult_r(10) xor xnorn(11);              -- DFF
			    xnorn(11) <= mult_r(11) xor xnorn(12);              -- DFF
			    xnorn(12) <= mult_r(12) xor xnorn(13);              -- DFF
			    xnorn(13) <= mult_r(13) xor xnorn(14);              -- DFF
			    xnorn(14) <= mult_r(14) xor xnorn(15);              -- DFF
			    xnorn(15) <= mult_r(15) xor xnorn(16);              -- DFF
			    xnorn(16) <= mult_r(16) xor xnorn(17);              -- DFF
			    xnorn(17) <= mult_r(17) xor xnorn(18);              -- DFF
			    xnorn(18) <= mult_r(18) xor xnorn(19);              -- DFF
			    xnorn(19) <= mult_r(19) xor xnorn(20);              -- DFF
			    xnorn(20) <= mult_r(20) xor xnorn(21);              -- DFF
			    xnorn(21) <= mult_r(21) xor xnorn(22);              -- DFF
			    xnorn(22) <= mult_r(22) xor xnorn(23);              -- DFF
			    xnorn(23) <= mult_r(23) xor xnorn(24);              -- DFF
			    xnorn(24) <= mult_r(24) xor xnorn(25);              -- DFF
			    xnorn(25) <= mult_r(25) xor xnorn(26);              -- DFF
			    xnorn(26) <= mult_r(26) xor xnorn(27) xor zero_bit; -- TAP 27
			    xnorn(27) <= mult_r(27) xor xnorn(28);              -- DFF
			    xnorn(28) <= mult_r(28) xor xnorn(29) xor zero_bit; -- TAP 29
			    xnorn(29) <= mult_r(29) xor xnorn(30) xor zero_bit; -- TAP 30
			    xnorn(30) <= mult_r(30) xor xnorn(31);              -- DFF
			    xnorn(31) <= mult_r(31) xor zero_bit;               -- TAP 32
                    else
                        xnorn <= xnorn;       --HOLD
                    end if;
                end if;
            end if; 
        end process;
    
signature <= xnorn; --OUTPUT assign
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
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
	    rst     => clk, --rst REPLACED rst signal with clk
	    --rst     => rst,
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
	    rst       => clk, --rst, REPLACED rst signal with clk
	    --rst       => rst,
	    enable    => tst_mode,
	    mult_r    => mac_out,

	    signature => misr_sig
	);

	-- Logic for tst vs not tst
	process(clk, rst, tst_mode)
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

