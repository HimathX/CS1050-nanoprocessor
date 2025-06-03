library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package BusDefinitions is
    -- Standard width vector definitions
    subtype std_logic_vector_3 is std_logic_vector(2 downto 0);   -- 3-bit vector
    subtype std_logic_vector_4 is std_logic_vector(3 downto 0);   -- 4-bit vector
    subtype std_logic_vector_8 is std_logic_vector(7 downto 0);   -- 8-bit vector
    subtype std_logic_vector_12 is std_logic_vector(11 downto 0); -- 12-bit vector
    
    -- Composite data structures
    type reg_array_8x4 is array (7 downto 0) of std_logic_vector_4;  -- 8x4-bit register array
    type mem_array_4x8 is array (3 downto 0) of std_logic_vector_8;  -- 4x8-bit memory array
    
    -- Architecture-specific bus definitions
    subtype RegisterFile is reg_array_8x4;         -- Collection of 8 registers, each 4 bits wide
    subtype ProgramCounter is std_logic_vector_3;  -- 3-bit address pointer for program memory (0-7)
    subtype InstructionWord is std_logic_vector_12; -- 12-bit machine instruction format
    subtype DataBus is std_logic_vector_4;       -- 4-bit data value used in calculations
    subtype RegisterSelect is std_logic_vector_3;  -- 3-bit identifier to select registers (R0-R7)
    subtype OperationSelection is std_logic_vector_3;
    
end package BusDefinitions;