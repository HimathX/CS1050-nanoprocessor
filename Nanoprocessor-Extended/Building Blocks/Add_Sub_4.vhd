library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Add_Sub_4_bit is
    Port(
        Input_A    : in  DataBus;
        Input_B    : in  DataBus;
        Mode_Sel   : in  STD_LOGIC;
        Result     : out DataBus;
        Zero_Flag  : out STD_LOGIC;
        Overflow_Flag : out STD_LOGIC
    );
end Add_Sub_4_bit;

architecture Behavioral of Add_Sub_4_bit is
    COMPONENT RCA_4
        Port (
            A0 : in STD_LOGIC;
            A1 : in STD_LOGIC;
            A2 : in STD_LOGIC;
            A3 : in STD_LOGIC;
            B0 : in STD_LOGIC;
            B1 : in STD_LOGIC;
            B2 : in STD_LOGIC;
            B3 : in STD_LOGIC;
            C_in : in STD_LOGIC;
            S0 : out STD_LOGIC;
            S1 : out STD_LOGIC;
            S2 : out STD_LOGIC;
            S3 : out STD_LOGIC;
            C_out : out STD_LOGIC
        );
    END COMPONENT;
    
    SIGNAL Modified_B, Temp_Result: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL RCA_Cout : STD_LOGIC; -- Carry output from RCA
begin
    RCA_4_inst : RCA_4 port map(
        A0 => Input_A(0),
        A1 => Input_A(1),
        A2 => Input_A(2),
        A3 => Input_A(3),
        B0 => Modified_B(0),
        B1 => Modified_B(1),
        B2 => Modified_B(2),
        B3 => Modified_B(3),
        C_in => Mode_Sel,
        S0 => Temp_Result(0),
        S1 => Temp_Result(1),
        S2 => Temp_Result(2),
        S3 => Temp_Result(3),
        C_out => RCA_Cout -- Store Carry Output in a signal instead of directly connecting to Overflow_Flag
    );
    
    -- XOR each bit of Input_B with the Mode_Sel signal for 2's complement in subtraction
    Modified_B(0) <= Input_B(0) XOR Mode_Sel;
    Modified_B(1) <= Input_B(1) XOR Mode_Sel;
    Modified_B(2) <= Input_B(2) XOR Mode_Sel;
    Modified_B(3) <= Input_B(3) XOR Mode_Sel;
    
    -- Process to determine if result is zero
    process (Temp_Result)
    begin
        if Temp_Result = "0000" then
            Zero_Flag <= '1';
        else
            Zero_Flag <= '0';
        end if;
    end process;

    -- True overflow detection for both addition and subtraction
    -- For addition: Overflow occurs when adding two numbers of the same sign results in a different sign
    -- For subtraction: Overflow occurs when subtracting two numbers of different signs results in a sign not matching A
    process (Input_A, Input_B, Temp_Result, Mode_Sel)
    begin
        if Mode_Sel = '0' then
            -- Addition mode: Check if inputs have same sign but result has different sign
            Overflow_Flag <= (Input_A(3) AND Input_B(3) AND (NOT Temp_Result(3))) OR
                            ((NOT Input_A(3)) AND (NOT Input_B(3)) AND Temp_Result(3));
        else
            -- Subtraction mode: Check if inputs have different signs and result's sign doesn't match Input_A
            -- Since B is already complemented for subtraction, we need to check NOT(Input_B(3))
            Overflow_Flag <= (Input_A(3) AND (NOT Input_B(3)) AND (NOT Temp_Result(3))) OR
                            ((NOT Input_A(3)) AND Input_B(3) AND Temp_Result(3));
        end if;
    end process;
    
    -- Transfer temporary result to output
    Result <= Temp_Result;
end Behavioral;