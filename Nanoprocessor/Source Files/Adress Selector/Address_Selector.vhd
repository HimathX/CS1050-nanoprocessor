library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.ProgramCounter;

entity Address_Selector is
    port (
        Sequential_Address : in  ProgramCounter; -- PC+1 address for sequential execution
        Jump_Address       : in  ProgramCounter; -- Target address when jump occurs
        Jump_Enable        : in  std_logic;      -- Jump control signal (1=Jump, 0=Continue)
        Selected_Address   : out ProgramCounter  -- Address selected for next execution
    );
end entity Address_Selector;

architecture Behavioral of Address_Selector is
    component Mux_2way_3bit is
        port (
            Input_0 : in  STD_LOGIC_VECTOR(2 downto 0); -- First 3-bit input
            Input_1 : in  STD_LOGIC_VECTOR(2 downto 0); -- Second 3-bit input
            Sel     : in  STD_LOGIC;                    -- Selection control (1 bit for 2 inputs)
            Output  : out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit output
        );
    end component Mux_2way_3bit;
begin
    Program_Mux : Mux_2way_3bit
        port map (
            Input_0 => Sequential_Address,
            Input_1 => Jump_Address,
            Sel     => Jump_Enable,
            Output  => Selected_Address
        );
end architecture Behavioral;