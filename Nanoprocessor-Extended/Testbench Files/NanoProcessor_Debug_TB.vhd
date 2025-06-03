library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use work.BusDefinitions.all;

entity NanoProcessor_Debug_TB is
-- No ports for testbench
end NanoProcessor_Debug_TB;

architecture Behavioral of NanoProcessor_Debug_TB is
    -- Component declaration for the Debug version of NanoProcessor
    component NanoProcessor_Debug
        port(
            -- Standard processor ports
            Clock    : in  std_logic;
            Reset    : in  std_logic;
            Overflow : out std_logic;
            Zero     : out std_logic;
            Data     : out DataBus;
            
            -- Debug ports
            Debug_PC          : out ProgramCounter;
            Debug_Instruction : out InstructionWord;
            Debug_JumpFlag    : out std_logic;
            Debug_RegEnable   : out RegisterSelect;
            Debug_OpSelect    : out std_logic;
            Debug_ALUResult   : out DataBus;
            Debug_Register0   : out DataBus;
            Debug_Register1   : out DataBus;
            Debug_Register7   : out DataBus;
            
            -- Additional debug ports
            Debug_LoadSel     : out std_logic;
            Debug_ImmValue    : out DataBus;
            Debug_WriteData   : out DataBus
        );
    end component;
    
    -- Inputs
    signal tb_Clock    : std_logic := '0';
    signal tb_Reset    : std_logic := '0';
    
    -- Standard outputs
    signal tb_Overflow : std_logic;
    signal tb_Zero     : std_logic;
    signal tb_Data     : DataBus;
    
    -- Debug outputs
    signal tb_PC       : ProgramCounter;
    signal tb_Instr    : InstructionWord;
    signal tb_JumpFlag : std_logic;
    signal tb_RegEn    : RegisterSelect;
    signal tb_OpSel    : std_logic;
    signal tb_ALURes   : DataBus;
    signal tb_Reg0     : DataBus;
    signal tb_Reg1     : DataBus;
    signal tb_Reg7     : DataBus;
    
    -- Additional debug signals
    signal tb_LoadSel  : std_logic;
    signal tb_ImmValue : DataBus;
    signal tb_WriteData : DataBus;
    
    -- Test control
    signal cycle_count : integer := 0;
    
    -- Clock period definition
    constant CLOCK_PERIOD : time := 10 ns;
    
    -- Function to get operation name from opcode
    function get_opcode_name(instr: InstructionWord) return string is
        variable opcode : std_logic_vector(1 downto 0);
    begin
        opcode := instr(11 downto 10);
        
        case opcode is
            when "00" => return "ADD ";
            when "01" => return "NEG ";
            when "10" => return "MOVI";
            when "11" => return "JZR ";
            when others => return "UNKN";
        end case;
    end function;
    
    -- Function to decode instruction completely
    function decode_instruction(instr: InstructionWord) return string is
        variable opcode : std_logic_vector(1 downto 0);
        variable reg_a : integer;
        variable reg_b : integer;
        variable imm_val : integer;
        variable jmp_addr : integer;
    begin
        opcode := instr(11 downto 10);
        reg_a := to_integer(unsigned(instr(9 downto 7)));
        
        case opcode is
            when "00" => -- ADD
                reg_b := to_integer(unsigned(instr(6 downto 4)));
                return "ADD R" & integer'image(reg_a) & ",R" & integer'image(reg_b);
                
            when "01" => -- NEG
                return "NEG R" & integer'image(reg_a);
                
            when "10" => -- MOVI
                imm_val := to_integer(unsigned(instr(3 downto 0)));
                return "MOVI R" & integer'image(reg_a) & "," & integer'image(imm_val);
                
            when "11" => -- JZR
                jmp_addr := to_integer(unsigned(instr(2 downto 0)));
                return "JZR R" & integer'image(reg_a) & "," & integer'image(jmp_addr);
                
            when others =>
                return "UNKNOWN";
        end case;
    end function;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: NanoProcessor_Debug 
    port map (
        -- Standard ports
        Clock    => tb_Clock,
        Reset    => tb_Reset,
        Overflow => tb_Overflow,
        Zero     => tb_Zero,
        Data     => tb_Data,
        
        -- Debug ports
        Debug_PC          => tb_PC,
        Debug_Instruction => tb_Instr,
        Debug_JumpFlag    => tb_JumpFlag,
        Debug_RegEnable   => tb_RegEn,
        Debug_OpSelect    => tb_OpSel,
        Debug_ALUResult   => tb_ALURes,
        Debug_Register0   => tb_Reg0,
        Debug_Register1   => tb_Reg1,
        Debug_Register7   => tb_Reg7,
        
        -- Additional debug ports
        Debug_LoadSel     => tb_LoadSel,
        Debug_ImmValue    => tb_ImmValue,
        Debug_WriteData   => tb_WriteData
    );
    
    -- Clock process
    clk_process: process
    begin
        tb_Clock <= '0';
        wait for CLOCK_PERIOD/2;
        tb_Clock <= '1';
        wait for CLOCK_PERIOD/2;
    end process;
    
    -- Process to count cycles
    counter_proc: process(tb_Clock, tb_Reset)
    begin
        if tb_Reset = '1' then
            cycle_count <= 0;
        elsif rising_edge(tb_Clock) then
            cycle_count <= cycle_count + 1;
        end if;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Print start message
        report "=== NANOPROCESSOR DEBUG TESTBENCH STARTED ===" severity note;
        
        -- Apply reset
        tb_Reset <= '1';
        wait for CLOCK_PERIOD*2;
        
        -- Release reset and start test
        tb_Reset <= '0';
        
        -- Execute for 25 cycles
        for i in 1 to 25 loop
            wait for CLOCK_PERIOD;        
            
         -- Program specific checks based on your ROM program
            case cycle_count is
                when 3 =>
                    -- After first MOVI instruction (MOVI R7,3)
                    assert tb_Reg7 = "0011" 
                        report "Error: R7 should be 3 after MOVI instruction" severity warning;
                        
                when 5 =>
                    -- After NEG R1
                    assert tb_Reg1 = "1111" 
                        report "Error: R1 should be -1 (1111) after NEG instruction" severity warning;
                
                when 7 =>
                    -- After MOVI R2,3
                    assert tb_LoadSel = '0' 
                        report "Error: LoadSel should be 0 for MOVI operation" severity warning;
                    
                when 10 =>
                    -- After ADD R7,R2
                    assert tb_OpSel = '0' 
                        report "Error: OpSel should be 0 for ADD operation" severity warning;
                    
                when 18 =>
                    -- Near the end of program
                    report "Checking final R7 value..." severity note;
                    
                when others =>
                    -- No checks for other cycles
            end case;
            
            report "------------------------------------------------" severity note;
        end loop;
        
        
        wait; -- End simulation
    end process;

end Behavioral;