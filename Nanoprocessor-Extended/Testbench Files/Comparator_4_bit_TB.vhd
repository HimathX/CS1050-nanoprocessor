library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Comparator_4_bit_TB is
-- Testbench has no ports
end Comparator_4_bit_TB;

architecture Behavioral of Comparator_4_bit_TB is
    -- Component declaration for the Unit Under Test
    component Comparator_4_bit
        Port(
            Input_A           : in  DataBus;
            Input_B           : in  DataBus;
            Equal_Flag        : out STD_LOGIC;
            LessThan_Flag     : out STD_LOGIC;
            GreaterThan_Flag  : out STD_LOGIC
        );
    end component;
    
    -- Test signals
    signal tb_Input_A          : DataBus := (others => '0');
    signal tb_Input_B          : DataBus := (others => '0');
    signal tb_Equal            : STD_LOGIC;
    signal tb_LessThan         : STD_LOGIC;
    signal tb_GreaterThan      : STD_LOGIC;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: Comparator_4_bit 
    port map (
        Input_A          => tb_Input_A,
        Input_B          => tb_Input_B,
        Equal_Flag       => tb_Equal,
        LessThan_Flag    => tb_LessThan,
        GreaterThan_Flag => tb_GreaterThan
    );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Equal (both 0)
        tb_Input_A <= "0000";
        tb_Input_B <= "0000";
        wait for 10 ns;
        
        -- Test case 2: Equal (both positive)
        tb_Input_A <= "0101";
        tb_Input_B <= "0101";
        wait for 10 ns;
        
        -- Test case 3: Equal (both negative)
        tb_Input_A <= "1000";
        tb_Input_B <= "1000";
        wait for 10 ns;
        
        -- Test case 4: A < B (positive numbers)
        tb_Input_A <= "0001";
        tb_Input_B <= "0010";
        wait for 10 ns;
        
        -- Test case 5: A < B (negative vs zero)
        tb_Input_A <= "1000";
        tb_Input_B <= "0000";
        wait for 10 ns;
        
        -- Test case 6: A < B (negative vs negative)
        tb_Input_A <= "1011";
        tb_Input_B <= "1010";
        wait for 10 ns;
        
        -- Test case 7: A > B (positive numbers)
        tb_Input_A <= "0111";
        tb_Input_B <= "0011";
        wait for 10 ns;
        
        -- Test case 8: A > B (zero vs negative)
        tb_Input_A <= "0000";
        tb_Input_B <= "1000";
        wait for 10 ns;
        
        -- Test case 9: A > B (negative vs negative)
        tb_Input_A <= "1010";
        tb_Input_B <= "1011";
        wait for 10 ns;
        
        -- End of test
        wait;
    end process;

end Behavioral;