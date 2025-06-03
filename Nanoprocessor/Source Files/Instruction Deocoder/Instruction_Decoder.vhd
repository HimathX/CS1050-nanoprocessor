library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.constants.all;

entity Instruction_Decoder is
    port (
        Instruction           : in  InstructionWord;  -- Instruction
        Register_Value_For_Jump : in  DataBus;        -- Register value to check for jump condition
        Register_Enable       : out RegisterSelect;   -- Register write enable
        Register_Select_A     : out RegisterSelect;   -- First operand register select
        Register_Select_B     : out RegisterSelect;   -- Second operand register select
        Operation_Select      : out STD_LOGIC;        -- '0' for ADD, '1' for SUB
        Immediate_Value       : out DataBus;          -- Immediate value for operations
        Jump_Enable           : out STD_LOGIC;        -- Jump control flag
        Jump_Address          : out ProgramCounter;   -- Address to jump to
        Load_Select           : out STD_LOGIC         -- Select between immediate or register data
    );
end entity Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
    signal Opcode : std_logic_vector(1 downto 0);     -- Instruction opcode
begin
    Opcode <= Instruction(11 downto 10);              -- Extract opcode from instruction
    
    decode: process(Opcode, Register_Value_For_Jump, Instruction)
    begin
        -- Default values to prevent latches
        Jump_Enable      <= '0';                      -- Disable jump by default
        Immediate_Value  <= "0000";                   -- Zero immediate value 
        Load_Select      <= '0';                      -- Default to immediate load mode
        Register_Enable  <= "000";                    -- No register enabled by default
        Operation_Select <= '0';                      -- Default to ADD operation
        Register_Select_A <= "000";                   -- Default to register R0
        Register_Select_B <= "000";                   -- Default to register R0
        Jump_Address     <= "000";                    -- Default jump to address 0
        
        case Opcode is
            when MOVI_OP =>                           -- Move Immediate
                Immediate_Value <= Instruction(3 downto 0);
                Load_Select     <= '0';               -- Immediate load mode
                Register_Enable <= Instruction(9 downto 7);
                
            when ADD_OP =>                            -- Add operation
                Register_Select_A <= Instruction(9 downto 7);
                Register_Select_B <= Instruction(6 downto 4);
                Operation_Select  <= '0';             -- Addition
                Load_Select       <= '1';             -- Register load mode
                Register_Enable   <= Instruction(9 downto 7);
                
            when NEG_OP =>                            -- Negate operation
                Register_Select_A <= "000";           -- Select R0 (zero)
                Register_Select_B <= Instruction(9 downto 7);
                Operation_Select  <= '1';             -- Subtraction
                Load_Select       <= '1';             -- Register load mode
                Register_Enable   <= Instruction(9 downto 7);
                
            when JZR_OP =>                            -- Jump if Zero
                Register_Select_A <= Instruction(9 downto 7);
                Register_Enable   <= "000";           -- No register writes
                
                if Register_Value_For_Jump = "0000" then
                    Jump_Enable   <= '1';             -- Enable jump
                    Jump_Address  <= Instruction(2 downto 0);
                else
                    Jump_Enable   <= '0';             -- No jump
                end if;
                
            when others =>
                -- All outputs already have default values
        end case;
    end process decode;
end architecture Behavioral;