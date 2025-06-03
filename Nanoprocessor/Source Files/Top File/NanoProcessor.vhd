library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity NanoProcessor is
    port(
        Clock    : in  std_logic;  -- System clock
        Reset    : in  std_logic;  -- Asynchronous reset
        Overflow : out std_logic;  -- Overflow flag from ALU
        Zero     : out std_logic;  -- Zero flag from ALU
        S_7Seg  : out STD_LOGIC_VECTOR(6 downto 0);
        anode   : out STD_LOGIC_VECTOR(3 downto 0);
        Data     : out DataBus     -- Output data (Register 7 contents)
    );
end NanoProcessor;

architecture Behavioral of NanoProcessor is
    -- Clock and reset signals
    signal s_Clk : std_logic;
    signal s_Res : std_logic;
    signal s_SlowClk : std_logic;
    
    -- Program counter and addressing signals
    signal s_PCCurrent        : ProgramCounter;  -- Current program counter value
    signal s_PCNext           : ProgramCounter;  -- PC + 1 value
    signal s_JumpAddr         : ProgramCounter;  -- Jump target address
    signal s_JumpEn           : std_logic;       -- Jump control signal
    signal s_SelectedAddr     : ProgramCounter;  -- Selected next address
    
    -- Instruction and decoding signals
    signal s_Instruction      : InstructionWord;   -- Current instruction
    signal s_RegEn            : RegisterSelect;    -- Register write enable 
    signal s_RegSelA          : RegisterSelect;    -- First operand select
    signal s_RegSelB          : RegisterSelect;    -- Second operand select
    signal s_OpSelect         : std_logic;         -- Operation select (0=ADD, 1=SUB)
    signal s_ImmValue         : DataBus;           -- Immediate value
    signal s_LoadSel          : std_logic;         -- Load select (0=imm, 1=ALU)
    
    -- Data path signals
    signal s_RegFileOutputs   : RegisterFile;      -- All register values
    signal s_OperandA         : DataBus;           -- First ALU operand
    signal s_OperandB         : DataBus;           -- Second ALU operand
    signal s_ALUResult        : DataBus;           -- ALU result
    signal s_WriteData        : DataBus;           -- Data to write to register

    -- Components
    component Program_Counter
        Port (
            PC_Next    : in  ProgramCounter; 
            Res        : in  STD_LOGIC;
            Clk        : in  STD_LOGIC;
            PC_Current : out ProgramCounter
        );
    end component; 
     
    component PC_Adder
        port (
            current_address : in  ProgramCounter;
            next_address    : out ProgramCounter
        );
    end component;

    component Address_Selector
        port (
            Sequential_Address : in  ProgramCounter;
            Jump_Address       : in  ProgramCounter;
            Jump_Enable        : in  std_logic;
            Selected_Address   : out ProgramCounter
        );
    end component;
      
    component Program_ROM
        port(
            program_counter : in  ProgramCounter;
            instruction_out : out InstructionWord
        ); 
    end component;
    
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

    component Load_Selector
        Port (
            RegisterValue  : in  DataBus;
            ImmediateValue : in  DataBus;
            LoadSelect     : in  STD_LOGIC;
            OutputData     : out DataBus
        );
    end component; 
    
    component Register_Bank
        Port (
            Data             : in  DataBus;
            Reset            : in  STD_LOGIC;
            Reg_En           : in  RegisterSelect;
            Clock            : in  STD_LOGIC;
            Register_Outputs : out RegisterFile
        );
    end component;
    
    component RegisterData_Multiplexer
        Port ( 
            DataSources   : in  RegisterFile;
            SelectAddress : in  RegisterSelect;
            OutputData    : out DataBus
        );
    end component;
    
    component Add_Sub_4_bit
        Port(
            Input_A       : in  DataBus;
            Input_B       : in  DataBus;
            Mode_Sel      : in  STD_LOGIC;
            Result        : out DataBus;
            Zero_Flag     : out STD_LOGIC;
            Overflow_Flag : out STD_LOGIC
        );
    end component;
    
    component Slow_Clk
        Port (
            Clk_in  : in  STD_LOGIC;
            Clk_out : out STD_LOGIC
        );
    end component;
    
    component LUT_16_7 
        Port ( 
            address : in  DataBus;
            data    : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

begin
    -- Connect top-level ports to internal signals
    s_Clk <= Clock; 
    s_Res <= Reset;
    anode <= "1110";
    
        U_SlowClock : Slow_Clk
        port map (
            Clk_in  => s_Clk,
            Clk_out => s_SlowClk
        );
        
    
    -- Output register 7 data
    Data <= s_RegFileOutputs(7);

    -- Program counter and instruction fetch
    U_PC : Program_Counter
        port map (
            PC_Next    => s_SelectedAddr,
            Res        => s_Res, 
            Clk        => s_SlowClk,
            PC_Current => s_PCCurrent
        ); 
        
    U_PC_Adder : PC_Adder
        port map (
            current_address => s_PCCurrent,
            next_address    => s_PCNext
        );
    
    U_AddrSel : Address_Selector
        port map (
            Sequential_Address => s_PCNext, 
            Jump_Address       => s_JumpAddr,
            Jump_Enable        => s_JumpEn,
            Selected_Address   => s_SelectedAddr
        );
        
    U_ROM : Program_ROM
        port map(
            program_counter => s_PCCurrent,
            instruction_out => s_Instruction
        );
        
    -- Instruction decode
    U_ID : Instruction_Decoder
        port map(
            Instruction           => s_Instruction,
            Register_Value_For_Jump => s_OperandA,
            Register_Enable       => s_RegEn, 
            Register_Select_A     => s_RegSelA, 
            Register_Select_B     => s_RegSelB, 
            Operation_Select      => s_OpSelect,
            Immediate_Value       => s_ImmValue,
            Jump_Enable           => s_JumpEn,
            Jump_Address          => s_JumpAddr,
            Load_Select           => s_LoadSel
        );
        
    -- Register file and ALU data path
    U_LoadSel : Load_Selector
        port map(
            RegisterValue  => s_ALUResult,
            ImmediateValue => s_ImmValue,
            LoadSelect     => s_LoadSel,
            OutputData     => s_WriteData
        );
    
    U_RegBank : Register_Bank
        port map(
            Data             => s_WriteData,              
            Reset            => s_Res,           
            Reg_En           => s_RegEn,           
            Clock            => s_SlowClk,           
            Register_Outputs => s_RegFileOutputs
        );
     
    U_MuxA : RegisterData_Multiplexer
        port map(
            DataSources   => s_RegFileOutputs,
            SelectAddress => s_RegSelA,
            OutputData    => s_OperandA
        );

    U_MuxB : RegisterData_Multiplexer
        port map(
            DataSources   => s_RegFileOutputs,
            SelectAddress => s_RegSelB,
            OutputData    => s_OperandB
        );
    
    U_ALU : Add_Sub_4_bit
        port map(
            Input_A       => s_OperandA,
            Input_B       => s_OperandB,
            Mode_Sel      => s_OpSelect,
            Result        => s_ALUResult,
            Zero_Flag     => Zero,
            Overflow_Flag => Overflow
        );
     U_LUT_16_7 : LUT_16_7
        port map(
            address => s_RegFileOutputs(7),
            data => S_7Seg);
end Behavioral;