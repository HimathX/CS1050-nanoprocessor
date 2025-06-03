library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;  

entity Program_ROM is
    port(
        program_counter : in ProgramCounter;   -- Address input from program counter
        instruction_out : out InstructionWord  -- 12-bit instruction output
    ); 
end Program_ROM;

architecture Behavioral of Program_ROM is
    -- ROM memory type stores 8 instructions of 12 bits each
    type instruction_memory_type is array (0 to 7) of std_logic_vector(11 downto 0);
    
    -- Program that adds numbers from 1 to 3
    signal program_instructions : instruction_memory_type := (
            "101110000000", -- 0:        MOVI R7, 0            ; Initialize R7 to 0
            "100010000001", -- 1:        MOVI R1, 1            ; Initialize R1 to 1
            "100100000010", -- 2:        MOVI R2, 2            ; Initialize R2 to 2
            "100110000011", -- 3:        MOVI R3, 3            ; Initialize R3 to 3
            "001110010000", -- 4:        ADD R7, R1            ; R7 <= R1 + R7
            "001110100000", -- 5:        ADD R7, R2            ; R7 <= R2 + R7
            "001110110000", -- 6:        ADD R7, R3            ; R7 <= R3 + R7
            "110000000100"  -- 7:        JZR R0, 7             ; If R0 == 0, jump to address 4
        );
        
begin
    -- Map ROM address (program counter) to instruction output
    instruction_out <= program_instructions(to_integer(unsigned(program_counter)));
end Behavioral;