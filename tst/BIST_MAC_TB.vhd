-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

-- Generate Random numbers
use ieee.math_real.uniform;
use ieee.math_real.floor;

entity BIST_MAC_tb is
end;

architecture bench of BIST_MAC_tb is
	constant N : INTEGER := 16;
	component BIST_MAC
	port
	(
		tst_mode :   in     STD_LOGIC; 
		A        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
		B        :   in     STD_LOGIC_VECTOR(n-1 downto 0);
		rst      :   in     STD_LOGIC;
		clk      :   in     STD_LOGIC;
		output   :   out    STD_LOGIC_VECTOR(((2*n)-1) downto 0)
	);
	end component;

	signal tst_mode		: STD_LOGIC				:= '0';
	signal A		: STD_LOGIC_VECTOR(n-1 downto 0)	:= (others => '0');
	signal B		: STD_LOGIC_VECTOR(n-1 downto 0)	:= (others => '0');
	signal rst		: STD_LOGIC				:= '0';
	signal clk		: STD_LOGIC				:= '0';
	signal output		: STD_LOGIC_VECTOR(((2*n)-1) downto 0)	:= (others => '0');
	constant CLK_PERIOD	: TIME					:= 10 ns;

begin
	-- Insert values for generic parameters !!
	uut: BIST_MAC
	port map
	(
		tst_mode => tst_mode, 
		A        => A, 
		B        => B, 
		rst      => rst, 
		clk      => clk, 
		output   => output 
	);

	-- Establish clk
	clk <= not clk after CLK_PERIOD / 2;

	-- Put test bench stimulus code here
	stimulus: process is
	begin
		-- Reset
		wait for CLK_PERIOD;
		A <= (others => '0');
		B <= (others => '0');
		tst_mode <= '0';
		rst <= '1';
		wait for CLK_PERIOD;
		rst <= '0';
		wait for CLK_PERIOD;
	
		-- Turn on Test Mode (LFSR and MISR)
		tst_mode <= '1';
		wait for CLK_PERIOD * 100;

		-- Reset
		wait for CLK_PERIOD;
		A <= (others => '0');
		B <= (others => '0');
		rst <= '1';
		wait for CLK_PERIOD;
		rst <= '0';
		wait for CLK_PERIOD;
	    wait;
	end process;
end;
