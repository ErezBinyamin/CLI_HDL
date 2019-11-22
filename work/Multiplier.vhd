----------------------------------------------------------------------------------
-- Company : RIT
-- Engineer: Erez Binyamin
--
-- Create Date:    20:20:52 10/03/2017
-- Design Name:
-- Module Name:    Multiplier - Structural
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
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
    generic (n : integer := 4);
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

