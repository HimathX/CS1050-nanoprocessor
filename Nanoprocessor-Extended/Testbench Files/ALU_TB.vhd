library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity ALU_TB is
end entity ALU_TB;

architecture Behavioral of ALU_TB is
    component ALU is
        Port(
            A               : in  DataBus;
            B               : in  DataBus;
            Operation       : in  OperationSelection;
            Result          : out DataBus;
            Zero            : out STD_LOGIC;
            Overflow        : out STD_LOGIC;
            Equal           : out STD_LOGIC;
            LessThan        : out STD_LOGIC;
            GreaterThan     : out STD_LOGIC
        );
    end component;
    
    -- Test signals
    signal A_Test           : DataBus := "0000";
    signal B_Test           : DataBus := "0000";
    signal Operation_Test   : OperationSelection := "000";
    signal Result_Test      : DataBus;
    signal Zero_Test        : STD_LOGIC;
    signal Overflow_Test    : STD_LOGIC;
    signal Equal_Test       : STD_LOGIC;
    signal LessThan_Test    : STD_LOGIC;
    signal GreaterThan_Test : STD_LOGIC;
    
begin
    -- Instantiate Unit Under Test
    UUT: ALU
        port map(
            A               => A_Test,
            B               => B_Test,
            Operation       => Operation_Test,
            Result          => Result_Test,
            Zero            => Zero_Test,
            Overflow        => Overflow_Test,
            Equal           => Equal_Test,
            LessThan        => LessThan_Test,
            GreaterThan     => GreaterThan_Test
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Test addition: 2 + 3 = 5
        A_Test <= "0010";  -- 2
        B_Test <= "0011";  -- 3
        Operation_Test <= ALU_ADD;
        wait for 10 ns;
        
        -- Test subtraction: 5 - 2 = 3
        A_Test <= "0101";  -- 5
        B_Test <= "0010";  -- 2
        Operation_Test <= ALU_SUB;
        wait for 10 ns;
        
        -- Test multiplication (positive): 2 * 3 = 6
        A_Test <= "0010";  -- 2
        B_Test <= "0011";  -- 3
        Operation_Test <= ALU_MUL;
        wait for 10 ns;
        
        -- Test multiplication (overflow): 4 * 4 = 16 (overflow)
        A_Test <= "0100";  -- 4
        B_Test <= "0100";  -- 4
        Operation_Test <= ALU_MUL;
        wait for 10 ns;
        
        -- Test multiplication (negative): -2 * 3 = -6
        A_Test <= "1110";  -- -2 in two's complement
        B_Test <= "0011";  -- 3
        Operation_Test <= ALU_MUL;
        wait for 10 ns;
        
        -- Test multiplication (negative * negative): -2 * -2 = 4
        A_Test <= "1110";  -- -2 in two's complement
        B_Test <= "1110";  -- -2 in two's complement
        Operation_Test <= ALU_MUL;
        wait for 10 ns;
        
        -- Test AND: 1010 AND 1100 = 1000
        A_Test <= "1010";
        B_Test <= "1100";
        Operation_Test <= ALU_AND;
        wait for 10 ns;
        
        -- Test OR: 1010 OR 0011 = 1011
        A_Test <= "1010";
        B_Test <= "0011";
        Operation_Test <= ALU_OR;
        wait for 10 ns;
        
        -- Test XOR: 1010 XOR 1100 = 0110
        A_Test <= "1010";
        B_Test <= "1100";
        Operation_Test <= ALU_XOR;
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process stim_proc;
    
end architecture Behavioral;