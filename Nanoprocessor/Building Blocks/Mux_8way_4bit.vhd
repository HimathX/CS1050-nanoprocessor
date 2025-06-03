library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_8way_4bit is
    Port (
        Input_0    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_1    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_2    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_3    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_4    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_5    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_6    : in  STD_LOGIC_VECTOR(3 downto 0);
        Input_7    : in  STD_LOGIC_VECTOR(3 downto 0);
        Sel        : in  STD_LOGIC_VECTOR(2 downto 0);  -- 3 bits needed for 8 inputs (log2 8 = 3)
        Output     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Mux_8way_4bit;

architecture Behavioral of Mux_8way_4bit is
begin
    -- Using a selected signal assignment with case
    with Sel select
        Output <=
            Input_0 when "000",
            Input_1 when "001",
            Input_2 when "010",
            Input_3 when "011",
            Input_4 when "100",
            Input_5 when "101",
            Input_6 when "110",
            Input_7 when "111",
            (others => 'X') when others;  -- For completeness, though this case shouldn't occur
end Behavioral;