library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.constants.all;

entity ALU is
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
end ALU;

architecture Behavioral of ALU is 
    component Add_Sub_4_bit
        Port(
            Input_A        : in  DataBus;
            Input_B        : in  DataBus;
            Mode_Sel       : in  STD_LOGIC;
            Result         : out DataBus;
            Zero_Flag      : out STD_LOGIC;
            Overflow_Flag  : out STD_LOGIC
        );
    end component;
    
    component Comparator_4_bit
        Port(
            Input_A           : in  DataBus;
            Input_B           : in  DataBus;
            Equal_Flag        : out STD_LOGIC;
            LessThan_Flag     : out STD_LOGIC;
            GreaterThan_Flag  : out STD_LOGIC
        );
     end component;
     
    component Multiplier_4_bit
        Port(
            Input_A        : in  DataBus;
            Input_B        : in  DataBus;
            Result         : out DataBus;
            Overflow       : out STD_LOGIC
        );
    end component;
     
    -- Internal signals
    signal AddSub_Mode      : STD_LOGIC;
    signal AddSub_Result    : DataBus;
    signal AddSub_Zero      : STD_LOGIC;      
    signal AddSub_Overflow  : STD_LOGIC;
    signal Zero_Value       : DataBus := "0000";    
    signal Logic_Result     : DataBus;
    signal Logic_Zero       : STD_LOGIC;
    signal CMP_Equal        : STD_LOGIC;
    signal CMP_LessThan     : STD_LOGIC;
    signal CMP_GreaterThan  : STD_LOGIC;
    signal Mul_Result       : DataBus;
    signal Mul_Overflow     : STD_LOGIC;
    signal Mul_Zero         : STD_LOGIC;
    
    -- Signals for input selection to the AddSub unit
    signal Selected_Input_A : DataBus;
    signal Selected_Input_B : DataBus;
begin
    -- Input selection for Add_Sub_4_bit based on operation
    Input_Selection: process(A, B, Operation)
    begin
        -- Default assignment
        Selected_Input_A <= A;
        Selected_Input_B <= B;
        
        -- Special case for NEG operation
        if Operation = ALU_NEG then
            -- Method 1: 0 - A
            Selected_Input_A <= Zero_Value;  -- Use 0 as first input
            Selected_Input_B <= A;           -- Use A as second input
        end if;
    end process Input_Selection;
    
    AddSub_Unit : Add_Sub_4_bit
        port map(
            Input_A        => Selected_Input_A,
            Input_B        => Selected_Input_B,
            Mode_Sel       => AddSub_Mode,
            Result         => AddSub_Result,
            Zero_Flag      => AddSub_Zero,     
            Overflow_Flag  => AddSub_Overflow  
        );
    
    Comparator_Unit : Comparator_4_bit
        port map(
            Input_A        => A,
            Input_B        => B,
            Equal_Flag     => CMP_Equal,
            LessThan_Flag  => CMP_LessThan,
            GreaterThan_Flag => CMP_GreaterThan
        );
        
    Multiplier_Unit : Multiplier_4_bit
        port map(
            Input_A        => A,
            Input_B        => B,
            Result         => Mul_Result,
            Overflow       => Mul_Overflow
        );
     
    AddSub_Mode_Control : process(Operation)
    begin
        if Operation = ALU_ADD then
            AddSub_Mode <= '0';  -- Addition mode
        elsif Operation = ALU_SUB then
            AddSub_Mode <= '1';  -- Subtraction mode
        elsif Operation = ALU_NEG then
            AddSub_Mode <= '1';  -- Use subtraction mode for negation (0-A)
        else
            -- Default to addition for any other operation
            AddSub_Mode <= '0';
        end if;
    end process AddSub_Mode_Control;
    
    -- Logic operations processing
    Logic_Operations: process(A, B, Operation)
    begin
        if Operation = ALU_AND then
            Logic_Result <= A and B; 
        elsif Operation = ALU_OR then
            Logic_Result <= A or B; 
        elsif Operation = ALU_XOR then
            Logic_Result <= A xor B; 
        else
            Logic_Result <= (others => '0');  -- Default case
        end if;
    end process Logic_Operations;
    
    -- Output multiplexing
    Logic_Zero_Detection: process(Logic_Result)
    begin
        if Logic_Result = Zero_Value then
            Logic_Zero <= '1';  -- Result is zero
        else
            Logic_Zero <= '0';  -- Result is non-zero
        end if;
    end process Logic_Zero_Detection;
    
    -- Multiplication zero detection
    Mul_Zero_Detection: process(Mul_Result)
    begin
        if Mul_Result = Zero_Value then
            Mul_Zero <= '1';  -- Result is zero
        else
            Mul_Zero <= '0';  -- Result is non-zero
        end if;
    end process Mul_Zero_Detection;
    
    Result_Selection : process(Operation, Logic_Zero, Logic_Result, AddSub_Result, AddSub_Zero, AddSub_Overflow, CMP_Equal, CMP_LessThan, CMP_GreaterThan, Mul_Result, Mul_Zero, Mul_Overflow)
    begin
        case Operation is
            when ALU_ADD | ALU_SUB | ALU_NEG =>
                Result <= AddSub_Result;
                Zero <= AddSub_Zero;
                Overflow <= AddSub_Overflow;
                Equal <= '0';           
                LessThan <= '0';        
                GreaterThan <= '0'; 
            
            when ALU_AND | ALU_OR | ALU_XOR =>
                Result <= Logic_Result;
                Zero <= Logic_Zero;
                Overflow <= '0';
                Equal <= '0';           
                LessThan <= '0';        
                GreaterThan <= '0'; 
                
            when ALU_MUL =>
                Result <= Mul_Result;
                Zero <= Mul_Zero;
                Overflow <= Mul_Overflow;
                Equal <= '0';           
                LessThan <= '0';        
                GreaterThan <= '0';
            
            when ALU_CMP =>
                Result <= Zero_Value;
                Zero <= '1';
                Overflow <= '0';
                Equal <= CMP_Equal;           
                LessThan <= CMP_LessThan;       
                GreaterThan <= CMP_GreaterThan;     
            
            when others =>
                -- For any undefined operation, return zero with appropriate flags
                Result <= Zero_Value;
                Zero <= '1';
                Overflow <= '0';
                Equal <= '0';           
                LessThan <= '0';        
                GreaterThan <= '0'; 
        end case;
    end process Result_Selection;
end architecture Behavioral;