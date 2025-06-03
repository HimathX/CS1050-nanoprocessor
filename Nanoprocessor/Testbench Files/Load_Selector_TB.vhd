library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Load_Selector_TB is
end Load_Selector_TB;

architecture Behavioral of Load_Selector_TB is

    -- Component under test
    component Load_Selector is
        Port (
            RegisterValue  : in  STD_LOGIC_VECTOR(3 downto 0);
            ImmediateValue : in  STD_LOGIC_VECTOR(3 downto 0);
            LoadSelect     : in  STD_LOGIC;
            OutputData     : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Signals for the testbench
    signal RegisterValue  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal ImmediateValue : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal LoadSelect     : STD_LOGIC := '0';
    signal OutputData     : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the Unit Under Test
    UUT: Load_Selector
        port map (
            RegisterValue  => RegisterValue,
            ImmediateValue => ImmediateValue,
            LoadSelect     => LoadSelect,
            OutputData     => OutputData
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test case 1: LoadSelect = 0 ? Output = ImmediateValue
        ImmediateValue <= "1010";  -- 10
        RegisterValue  <= "0101";  -- 5
        LoadSelect     <= '0';
        wait for 20 ns;

        -- Test case 2: LoadSelect = 1 ? Output = RegisterValue
        LoadSelect <= '1';
        wait for 20 ns;

        -- Test case 3: Change values
        ImmediateValue <= "1111";  -- 15
        RegisterValue  <= "0011";  -- 3
        LoadSelect     <= '0';
        wait for 20 ns;

        LoadSelect <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
