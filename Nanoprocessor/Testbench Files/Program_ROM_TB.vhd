library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Program_ROM_TB is
end Program_ROM_TB;

architecture Behavioral of Program_ROM_TB is
    -- Component declaration
    component Program_ROM is
        port(
            program_counter : in ProgramCounter;
            instruction_out : out InstructionWord
        );
    end component;

    -- Testbench signals
    signal tb_pc : ProgramCounter := (others => '0');
    signal tb_instruction : InstructionWord;

begin
    -- Instantiate Unit Under Test (UUT)
    UUT: Program_ROM
        port map (
            program_counter => tb_pc,
            instruction_out => tb_instruction
        );

    -- Stimulus process
    stim_proc: process
    begin
        for i in 0 to 7 loop
            tb_pc <= std_logic_vector(to_unsigned(i, tb_pc'length));
            wait for 10 ns;
        end loop;
        
        wait;
    end process;

end Behavioral;
