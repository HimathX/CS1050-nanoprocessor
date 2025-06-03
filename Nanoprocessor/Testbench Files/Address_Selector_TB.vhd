library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- You must compile/work with BusDefinitions before this TB if it's referenced

entity Address_Selector_TB is
end Address_Selector_TB;

architecture Behavioral of Address_Selector_TB is

    -- Component under test
    component Address_Selector is
        port (
            Sequential_Address : in  STD_LOGIC_VECTOR(2 downto 0);
            Jump_Address       : in  STD_LOGIC_VECTOR(2 downto 0);
            Jump_Enable        : in  std_logic;
            Selected_Address   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signals for testing
    signal Sequential_Address : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Jump_Address       : STD_LOGIC_VECTOR(2 downto 0) := "111";
    signal Jump_Enable        : STD_LOGIC := '0';
    signal Selected_Address   : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate UUT
    UUT: Address_Selector
        port map (
            Sequential_Address => Sequential_Address,
            Jump_Address       => Jump_Address,
            Jump_Enable        => Jump_Enable,
            Selected_Address   => Selected_Address
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Case 1: Jump_Enable = 0 (sequential address selected)
        Sequential_Address <= "010";
        Jump_Address       <= "101";
        Jump_Enable        <= '0';
        wait for 20 ns;

        -- Case 2: Jump_Enable = 1 (jump address selected)
        Jump_Enable <= '1';
        wait for 20 ns;

        -- Case 3: Change addresses again
        Sequential_Address <= "001";
        Jump_Address       <= "100";
        Jump_Enable        <= '0';
        wait for 20 ns;

        Jump_Enable <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
