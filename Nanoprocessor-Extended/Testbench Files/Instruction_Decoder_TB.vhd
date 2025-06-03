library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Instruction_Decoder_TB is
--  Testbench has no ports
end Instruction_Decoder_TB;

architecture Behavioral of Instruction_Decoder_TB is
    -- Component declaration for the Unit Under Test (UUT)
    component Instruction_Decoder
        port (
            Instruction           : in  InstructionWord;
            Register_Value_For_Jump : in  DataBus;
            Register_Enable       : out RegisterSelect;
            Register_Select_A     : out RegisterSelect;
            Register_Select_B     : out RegisterSelect;
            Operation_Select      : out OperationSelection;
            Immediate_Value       : out DataBus;
            Jump_Enable           : out STD_LOGIC;
            Jump_Address          : out ProgramCounter;
            Load_Select           : out STD_LOGIC
        );
    end component;
    
    -- Test signals
    signal Instruction_tb         : InstructionWord := (others => '0');
    signal Register_Value_For_Jump_tb : DataBus := "0000";
    signal Register_Enable_tb     : RegisterSelect;
    signal Register_Select_A_tb   : RegisterSelect;
    signal Register_Select_B_tb   : RegisterSelect;
    signal Operation_Select_tb    : OperationSelection;
    signal Immediate_Value_tb     : DataBus;
    signal Jump_Enable_tb         : STD_LOGIC;
    signal Jump_Address_tb        : ProgramCounter;
    signal Load_Select_tb         : STD_LOGIC;
    
    -- Helper function to convert opcode to string
    function opcode_to_string(op: std_logic_vector(1 downto 0)) return string is
    begin
        case op is
            when MOVI_OP => return "MOVI";
            when ALU_OP  => return "ALU";
            when NEG_OP  => return "NEG";
            when JZR_OP  => return "JZR";
            when others  => return "Unknown";
        end case;
    end function;
    
    -- Helper function to convert ALU operation to string
    function alu_op_to_string(op: std_logic_vector(2 downto 0)) return string is
    begin
        case op is
            when ALU_ADD => return "ADD";
            when ALU_SUB => return "SUB";
            when ALU_NEG => return "NEG";
            when ALU_AND => return "AND";
            when ALU_OR  => return "OR";
            when ALU_XOR => return "XOR";
            when ALU_CMP => return "CMP";
            when others  => return "Unknown";
        end case;
    end function;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Instruction_Decoder 
        port map (
            Instruction => Instruction_tb,
            Register_Value_For_Jump => Register_Value_For_Jump_tb,
            Register_Enable => Register_Enable_tb,
            Register_Select_A => Register_Select_A_tb,
            Register_Select_B => Register_Select_B_tb,
            Operation_Select => Operation_Select_tb,
            Immediate_Value => Immediate_Value_tb,
            Jump_Enable => Jump_Enable_tb,
            Jump_Address => Jump_Address_tb,
            Load_Select => Load_Select_tb
        );

    -- Stimulus process
    stim_proc: process
        -- Helper procedure to format and display decoder outputs
        procedure display_output(test_name: string) is
            variable op_name: string(1 to 10) := (others => ' ');
        begin
            op_name(1 to 3) := opcode_to_string(Instruction_tb(11 downto 10))(1 to 3);
            
        end procedure;
        
    begin
        -- Wait for global reset
        wait for clk_period;
        

        
        -- Test 1: MOVI Instruction - Move immediate value 7 to register R2
        Instruction_tb <= "10" & "010" & "000" & "0111";  -- MOVI R2, 7
        wait for clk_period;
        display_output("MOVI R2, 7");
        
        -- Test 2: ALU ADD Instruction - R1 = R1 + R2
        Instruction_tb <= "00" & "001" & "010" & "0000";  -- ADD R1, R2
        wait for clk_period;
        display_output("ADD R1, R2");
        
        -- Test 3: ALU SUB Instruction - R3 = R3 - R1
        Instruction_tb <= "00" & "011" & "001" & "0001";  -- SUB R3, R1
        wait for clk_period;
        display_output("SUB R3, R1");
        
        -- Test 4: ALU AND Instruction - R4 = R4 & R5
        Instruction_tb <= "00" & "100" & "101" & "0010";  -- AND R4, R5
        wait for clk_period;
        display_output("AND R4, R5");
        
        -- Test 5: ALU OR Instruction - R6 = R6 | R2
        Instruction_tb <= "00" & "110" & "010" & "0011";  -- OR R6, R2
        wait for clk_period;
        display_output("OR R6, R2");
        
        -- Test 6: ALU XOR Instruction - R5 = R5 ^ R3
        Instruction_tb <= "00" & "101" & "011" & "0100";  -- XOR R5, R3
        wait for clk_period;
        display_output("XOR R5, R3");
        
        -- Test 7: ALU CMP Instruction - Compare R1 and R2
        Instruction_tb <= "00" & "001" & "010" & "0111";  -- CMP R1, R2
        wait for clk_period;
        display_output("CMP R1, R2");
        
        -- Test 8: NEG Instruction - R7 = -R7
        Instruction_tb <= "01" & "111" & "000" & "0000";  -- NEG R7
        wait for clk_period;
        display_output("NEG R7");
        
        -- Test 9: JZR Instruction with zero register - Jump if R1 == 0 to address 5
        Instruction_tb <= "11" & "001" & "000" & "0101";  -- JZR R1, 5
        Register_Value_For_Jump_tb <= "0000";  -- R1 is zero, should jump
        wait for clk_period;
        display_output("JZR R1, 5 (with R1==0)");
        
        -- Test 10: JZR Instruction with non-zero register - Jump if R1 == 0 to address 5
        Instruction_tb <= "11" & "001" & "000" & "0101";  -- JZR R1, 5
        Register_Value_For_Jump_tb <= "0011";  -- R1 is non-zero, should not jump
        wait for clk_period;
        display_output("JZR R1, 5 (with R1!=0)");
        

        
        -- End simulation
        wait;
    end process;
end Behavioral;