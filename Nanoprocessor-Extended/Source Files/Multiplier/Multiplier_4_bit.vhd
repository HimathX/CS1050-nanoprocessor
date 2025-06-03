library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Multiplier_4_bit is
    Port(
        Input_A   : in  DataBus;      -- 4-bit input A
        Input_B   : in  DataBus;      -- 4-bit input B
        Result    : out DataBus;      -- 4-bit result (lower 4 bits of multiplication)
        Overflow  : out STD_LOGIC     -- Indicates if multiplication result exceeds 4 bits
    );
end entity Multiplier_4_bit;

architecture Behavioral of Multiplier_4_bit is
    signal Full_Result : signed(7 downto 0);  -- Full 8-bit signed result
    signal Sign_Extension : std_logic_vector(3 downto 0);  -- For overflow checking
begin
    process(Input_A, Input_B)
        variable temp_A       : signed(3 downto 0);
        variable temp_B       : signed(3 downto 0);
        variable temp_Result  : signed(7 downto 0);
    begin
        -- Convert 4-bit input to signed
        temp_A := signed(Input_A);
        temp_B := signed(Input_B);
        
        -- Perform multiplication
        temp_Result := temp_A * temp_B;
        
        -- Store result
        Full_Result <= temp_Result;
    end process;
    
    -- Create sign extension vector for comparison
    Sign_Extension <= (others => Full_Result(3));
    
    -- Assign lower 4 bits to Result (convert signed to std_logic_vector)
    Result <= std_logic_vector(Full_Result(3 downto 0));
    
    -- Overflow detection: compare upper 4 bits with sign extension
    Overflow <= '1' when std_logic_vector(Full_Result(7 downto 4)) /= Sign_Extension else '0';
    
end architecture Behavioral;