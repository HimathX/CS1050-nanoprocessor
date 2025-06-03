library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Multiplier_4_bit_TB is
    --  No ports for a testbench
end entity Multiplier_4_bit_TB;

architecture Behavioral of Multiplier_4_bit_TB is

    -- Component declaration
    component Multiplier_4_bit is
        Port(
            Input_A        : in  DataBus;
            Input_B        : in  DataBus;
            Result         : out DataBus;
            Overflow       : out STD_LOGIC
        );
    end component;
    
    -- Signals to drive and observe DUT
    signal A_Test        : DataBus := "0000";
    signal B_Test        : DataBus := "0000";
    signal Result_Test   : DataBus;
    signal Overflow_Test : STD_LOGIC;
    
begin

    -- Instantiate the DUT
    UUT: Multiplier_4_bit
        port map (
            Input_A   => A_Test,
            Input_B   => B_Test,
            Result    => Result_Test,
            Overflow  => Overflow_Test
        );

    -- Stimulus process
    process
    begin
        -- Test 1: 2 * 3
        A_Test <= "0010";  -- 2
        B_Test <= "0011";  -- 3
        wait for 10 ns;

        -- Test 2: 4 * 5
        A_Test <= "0100";  -- 4
        B_Test <= "0101";  -- 5
        wait for 10 ns;

        -- Test 3: -3 * 2 (two's complement: -3 = 1101)
        A_Test <= "1101";  -- -3
        B_Test <= "0010";  -- 2
        wait for 10 ns;

        -- Test 4: -2 * -2 (should be +4)
        A_Test <= "1110";  -- -2
        B_Test <= "1110";  -- -2
        wait for 10 ns;

        -- Test 5: 7 * 7 (Overflow expected)
        A_Test <= "0111";  -- 7
        B_Test <= "0111";  -- 7
        wait for 10 ns;

        wait;
    end process;

end architecture Behavioral;
