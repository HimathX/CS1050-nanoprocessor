library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package Constants is
    -- Clock
    constant clk_period : time := 10 ns;
    constant clk_half_period : time := clk_period / 2;    
    -- OP Codes
    constant MOVI_OP : std_logic_vector(1 downto 0) := "10";
    constant ALU_OP : std_logic_vector(1 downto 0) := "00";
    constant NEG_OP : std_logic_vector(1 downto 0) := "01";
    constant JZR_OP : std_logic_vector(1 downto 0) := "11";
    
    -- ALU operation codes (3 bits)
    constant ALU_ADD : std_logic_vector(2 downto 0) := "000";  -- Addition
    constant ALU_SUB : std_logic_vector(2 downto 0) := "001";  -- Subtraction
    constant ALU_NEG : std_logic_vector(2 downto 0) := "010";  -- Negation (2's complement)
    -- Bitwise Operations
    constant ALU_AND : std_logic_vector(2 downto 0) := "011";  -- Bitwise AND
    constant ALU_OR  : std_logic_vector(2 downto 0) := "100";  -- Bitwise OR
    constant ALU_XOR : std_logic_vector(2 downto 0) := "101";  -- Bitwise XOR
    -- Multiplication operation
    constant ALU_MUL : std_logic_vector(2 downto 0) := "110";  -- Multiplication
    --comparison operations
    constant ALU_CMP : std_logic_vector(2 downto 0) := "111";  -- Compare
    
    -- ALU sub-opcodes (last 4 bits)
    constant SUBOP_ADD : std_logic_vector(3 downto 0) := "0000";  -- ADD instruction
    constant SUBOP_SUB : std_logic_vector(3 downto 0) := "0001";  -- SUB instruction
    constant SUBOP_AND : std_logic_vector(3 downto 0) := "0010";  -- AND instruction
    constant SUBOP_OR  : std_logic_vector(3 downto 0) := "0011";  -- OR instruction
    constant SUBOP_XOR : std_logic_vector(3 downto 0) := "0100";  -- XOR instruction
    constant SUBOP_MUL : std_logic_vector(3 downto 0) := "0101";  -- MULTIPLY instruction
    constant SUBOP_CMP : std_logic_vector(3 downto 0) := "0111";  -- COMPARE instruction
end package Constants;