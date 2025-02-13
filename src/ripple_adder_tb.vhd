--+----------------------------------------------------------------------------
--| Testbench for 4-bit Ripple-Carry Adder
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ripple_adder_tb is
end ripple_adder_tb;

architecture test_bench of ripple_adder_tb is 
	
  -- declare the component of your top-level design unit under test (UUT)
  component ripple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC
       );
   end component ripple_adder;
  
 
	-- declare signals needed to stimulate the UUT inputs
	signal w_addends     : std_logic_vector(7 downto 0) := x"00"; -- the numbers being added
	signal w_sum         : std_logic_vector(3 downto 0) := x"0";
	signal w_Cin, w_Cout : std_logic;

begin
	-- PORT MAPS ----------------------------------------
	ripple_adder_uut : ripple_adder port map (
	   A    => w_addends(3 downto 0),
	   B    => w_addends(7 downto 4),
	   Cin  => w_Cin,
	   S    => w_sum,
	   Cout => w_Cout
	);
	
	-- PROCESSES ----------------------------------------	
	-- Test Plan Process
	-- Implement the test plan here.  Body of process is continuously from time = 0  
	test_process : process 
	begin
	
	   -- Test all zeros input
	   w_addends <= x"00"; w_Cin <= '0'; wait for 10 ns;
	       assert (w_sum = x"0" and w_Cout = '0') report "bad with zeros" severity failure;
       -- Test all ones input
       w_addends <= x"FF"; w_Cin <= '1'; wait for 10 ns;
	       assert (w_sum = x"F" and w_Cout = '1') report "bad with ones" severity failure;
       -- TODO, a few other test cases
        w_addends <= x"0F"; w_Cin <= '0'; wait for 10 ns;
        assert (w_sum = x"0F" and w_Cout = '0') report "Mismatch in simple sum" severity failure;
    
        w_addends <= x"F0"; w_Cin <= '0'; wait for 10 ns;
        assert (w_sum = x"F0" and w_Cout = '0') report "Mismatch in simple sum" severity failure;
    
        w_addends <= x"01"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"02" and w_Cout = '0') report "Carry propagation failed" severity failure;
    
        w_addends <= x"7F"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"80" and w_Cout = '0') report "Carry propagation across bits failed" severity failure;
    
        w_addends <= x"FF"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"00" and w_Cout = '1') report "Overflow condition failed" severity failure;
    
        w_addends <= x"55"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"56" and w_Cout = '0') report "Alternating bits addition failed" severity failure;
    
        w_addends <= x"AA"; w_Cin <= '1'; wait for 10 ns;
        assert (w_sum = x"AB" and w_Cout = '0') report "Alternating bits addition failed" severity failure;
    
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;
