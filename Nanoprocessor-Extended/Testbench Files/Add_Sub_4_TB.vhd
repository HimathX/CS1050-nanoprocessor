library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Add_Sub_4_bit_TB is
-- Test bench doesn't have ports
end Add_Sub_4_bit_TB;

architecture Behavioral of Add_Sub_4_bit_TB is
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT Add_Sub_4_bit
        Port(
            Input_A    : in  STD_LOGIC_VECTOR (3 DOWNTO 0);
            Input_B    : in  STD_LOGIC_VECTOR (3 DOWNTO 0);
            Mode_Sel   : in  STD_LOGIC;
            Result     : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            Zero_Flag  : out STD_LOGIC;
            Overflow_Flag : out STD_LOGIC
        );
    END COMPONENT;
    
    -- Signals
    signal Input_A : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Input_B : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Mode_Sel : STD_LOGIC := '0';
    signal Result : STD_LOGIC_VECTOR(3 downto 0);
    signal Zero_Flag : STD_LOGIC;
    signal Overflow_Flag : STD_LOGIC;
    
    -- Clock signal
    signal clk : STD_LOGIC := '0';
    constant clk_period : time := 10 ns;
    
begin
    -- Instantiate the Unit Under Test
    uut: Add_Sub_4_bit PORT MAP (
        Input_A => Input_A,
        Input_B => Input_B,
        Mode_Sel => Mode_Sel,
        Result => Result,
        Zero_Flag => Zero_Flag,
        Overflow_Flag => Overflow_Flag
    );
    
    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Test stimulus process
    stim_proc: process
    begin
        -- Wait for initialization
        wait for 100 ns;
        
        -------------------------------------
        -- Addition Tests (Mode_Sel = '0')
        -------------------------------------
        Mode_Sel <= '0';
        
        -- Test 1: 0 + 0 = 0
        Input_A <= "0000";
        Input_B <= "0000";
        wait for clk_period;
        report "Test 1: 0 + 0 = " & integer'image(to_integer(unsigned(Result)));
        
        -- Test 2: 5 + 3 = 8
        Input_A <= "0101";
        Input_B <= "0011";
        wait for clk_period;
        report "Test 2: 5 + 3 = " & integer'image(to_integer(unsigned(Result)));
        
        -- Test 3: 7 + 1 = 8 (overflow in 2's complement)
        Input_A <= "0111";
        Input_B <= "0001";
        wait for clk_period;
        report "Test 3: 7 + 1 = " & integer'image(to_integer(unsigned(Result))) & 
               ", Overflow = " & std_logic'image(Overflow_Flag);
        
        -- Test 4: -8 + (-1) = -9 (overflow in 2's complement)
        Input_A <= "1000";
        Input_B <= "1111";
        wait for clk_period;
        report "Test 4: -8 + (-1) = " & integer'image(to_integer(signed(Result))) & 
               ", Overflow = " & std_logic'image(Overflow_Flag);
        
        -------------------------------------
        -- Subtraction Tests (Mode_Sel = '1')
        -------------------------------------
        Mode_Sel <= '1';
        
        -- Test 5: 5 - 3 = 2
        Input_A <= "0101";
        Input_B <= "0011";
        wait for clk_period;
        report "Test 5: 5 - 3 = " & integer'image(to_integer(unsigned(Result)));
        
        -- Test 6: 3 - 5 = -2
        Input_A <= "0011";
        Input_B <= "0101";
        wait for clk_period;
        report "Test 6: 3 - 5 = " & integer'image(to_integer(signed(Result)));
        
        -- Test 7: -8 - 1 = -9 (overflow in 2's complement)
        Input_A <= "1000";
        Input_B <= "0001";
        wait for clk_period;
        report "Test 7: -8 - 1 = " & integer'image(to_integer(signed(Result))) & 
               ", Overflow = " & std_logic'image(Overflow_Flag);
        
        -- Test 8: 7 - (-1) = 8 (overflow in 2's complement)
        Input_A <= "0111";
        Input_B <= "1111";
        wait for clk_period;
        report "Test 8: 7 - (-1) = " & integer'image(to_integer(signed(Result))) & 
               ", Overflow = " & std_logic'image(Overflow_Flag);
        
        -- Test 9: -1 - 7 = -8 (no overflow, edge case)
        Input_A <= "1111";
        Input_B <= "0111";
        wait for clk_period;
        report "Test 9: -1 - 7 = " & integer'image(to_integer(signed(Result))) & 
               ", Overflow = " & std_logic'image(Overflow_Flag);
        
        -- End the simulation
        report "All tests completed";
        wait;
    end process;
end Behavioral;