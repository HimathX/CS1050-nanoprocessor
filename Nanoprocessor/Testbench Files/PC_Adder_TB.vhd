library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity PC_Adder_TB is
end PC_Adder_TB;

architecture Behavioral of PC_Adder_TB is

    -- Component declaration
    component PC_Adder is
        port (
            current_address : in  ProgramCounter;
            next_address    : out ProgramCounter
        );
    end component;

    -- Signals to connect to UUT
    signal tb_current_address : ProgramCounter := (others => '0');
    signal tb_next_address    : ProgramCounter;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: PC_Adder
        port map (
            current_address => tb_current_address,
            next_address    => tb_next_address
        );

    -- Stimulus process
    stim_proc: process
    begin
        for i in 0 to 7 loop
            tb_current_address <= std_logic_vector(to_unsigned(i, tb_current_address'length));
            wait for 10 ns;
        end loop;

        wait;
    end process;

end Behavioral;
