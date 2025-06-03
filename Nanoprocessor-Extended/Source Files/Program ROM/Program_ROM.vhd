library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Program_ROM is
    port(
        program_counter : in ProgramCounter;   -- Address input from program counter
        instruction_out : out InstructionWord  -- 12-bit instruction output
    ); 
end Program_ROM;

architecture Behavioral of Program_ROM is
    -- ROM memory type stores 8 instructions of 12 bits each
    type instruction_memory_type is array (0 to 7) of std_logic_vector(11 downto 0);
    
    -- Comprehensive test program using only R6 and R7 (visible registers)
    -- Program that performs summation with loops
    signal program_instructions : instruction_memory_type := (
        -- Initialize registers with test values
        "101110000101", -- 0: MOVI R7,5  ; R7 ? 5 (0101)
        "101100000011", -- 1: MOVI R6,3  ; R6 ? 3 (0011)
        
        -- Test various ALU operations
        "001111100000", -- 2: ADD R7,R6  ; R7 ? R7 + R6 = 8  (1000)
        "001101110001", -- 3: SUB R6,R7  ; R6 ? R6 - R7 = -5 (1011)
        "001111100101", -- 4: MUL R7,R6  ; R7 ? R7 * R6 = 8 (with overflow)
        "001101110011", -- 5: OR R6,R7   ; R6 ? R6 OR R7 = 11 OR 8 = 11 (1011)
        "001111100100", -- 6: XOR R7,R6  ; R7 ? R7 XOR R6 = 8 XOR 11 = 3 (0011)
        "001111000111"  -- 7: CMP R7,R6  ; Compare R7(3) with R6(11): GT=1
    );
        
begin
    -- Map ROM address (program counter) to instruction output
    instruction_out <= program_instructions(to_integer(unsigned(program_counter)));
end Behavioral;