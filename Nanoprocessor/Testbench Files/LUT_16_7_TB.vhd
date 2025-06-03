library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT_16_7_TB is
end LUT_16_7_TB;

architecture Behavioral of LUT_16_7_TB is

    -- Component declaration
    component LUT_16_7 is
        Port (
            address : in  STD_LOGIC_VECTOR(3 downto 0);
            data    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals for stimulus and observation
    signal address : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal data    : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- Instantiate the unit under test
    UUT: LUT_16_7
        port map (
            address => address,
            data    => data
        );

    -- Test process
    stimulus: process
    begin
        for i in 0 to 15 loop
            address <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;

        wait;
    end process;

end Behavioral;
