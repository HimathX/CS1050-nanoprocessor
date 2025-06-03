library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2way_4bit is
    Port (
        Input_0    : in  STD_LOGIC_VECTOR(3 downto 0);  -- First 4-bit input
        Input_1    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Second 4-bit input
        Sel        : in  STD_LOGIC;                     -- Selection control
        Output     : out STD_LOGIC_VECTOR(3 downto 0)   -- 4-bit output
    );
end Mux_2way_4bit;

architecture Behavioral of Mux_2way_4bit is
begin
    -- Behavioral implementation
    Output <= Input_0 when Sel = '0' else Input_1;
end Behavioral;