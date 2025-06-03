library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.constants.all;

entity Instruction_Decoder_TB is
end Instruction_Decoder_TB;

architecture Behavioral of Instruction_Decoder_TB is
    -- Component declaration
    component Instruction_Decoder
        port (
            Instruction           : in  InstructionWord;
            Register_Value_For_Jump : in  DataBus;
            Register_Enable       : out RegisterSelect;
            Register_Select_A     : out RegisterSelect;
            Register_Select_B     : out RegisterSelect;
            Operation_Select      : out STD_LOGIC;
            Immediate_Value       : out DataBus;
            Jump_Enable           : out STD_LOGIC;
            Jump_Address          : out ProgramCounter;
            Load_Select           : out STD_LOGIC
        );
    end component;
    
    -- Inputs
    signal tb_Instruction : InstructionWord := (others => '0');
    signal tb_Register_Value : DataBus := (others => '0');
    
    -- Outputs
    signal tb_Register_Enable : RegisterSelect;
    signal tb_Register_Select_A : RegisterSelect;
    signal tb_Register_Select_B : RegisterSelect;
    signal tb_Operation_Select : STD_LOGIC;
    signal tb_Immediate_Value : DataBus;
    signal tb_Jump_Enable : STD_LOGIC;
    signal tb_Jump_Address : ProgramCounter;
    signal tb_Load_Select : STD_LOGIC;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Instruction_Decoder
        port map (
            Instruction => tb_Instruction,
            Register_Value_For_Jump => tb_Register_Value,
            Register_Enable => tb_Register_Enable,
            Register_Select_A => tb_Register_Select_A,
            Register_Select_B => tb_Register_Select_B,
            Operation_Select => tb_Operation_Select,
            Immediate_Value => tb_Immediate_Value,
            Jump_Enable => tb_Jump_Enable,
            Jump_Address => tb_Jump_Address,
            Load_Select => tb_Load_Select
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Wait 100 ns for initialization
        wait for 100 ns;
        
        -- Test MOVI instruction
        -- MOVI R3, 5 (Move immediate value 5 to R3)
        tb_Instruction <= "10" & "011" & "000" & "0" & "101";
        wait for 20 ns;
        
        -- Test ADD instruction
        -- ADD R2, R4 (Add R2 = R2 + R4)
        tb_Instruction <= "00" & "010" & "100" & "0000";
        wait for 20 ns;
        
        -- Test NEG instruction
        -- NEG R5 (R5 = -R5 = 0 - R5)
        tb_Instruction <= "01" & "101" & "0000000";
        wait for 20 ns;
        
        -- Test JZR instruction with zero register
        -- JZR R1, 7 (Jump to address 7 if R1 = 0)
        tb_Instruction <= "11" & "001" & "0000" & "111";
        tb_Register_Value <= "0000";  -- R1 contains 0
        wait for 20 ns;
        
        -- Test JZR instruction with non-zero register
        -- JZR R1, 7 (Don't jump if R1 ? 0)
        tb_Instruction <= "11" & "001" & "0000" & "111";
        tb_Register_Value <= "0010";  -- R1 contains non-zero
        wait for 20 ns;
        
        wait;
    end process;
end Behavioral;