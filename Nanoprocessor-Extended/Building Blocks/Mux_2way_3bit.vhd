library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2way_3bit is
    Port (
        Input_0    : in  STD_LOGIC_VECTOR(2 downto 0);  -- First 3-bit input
        Input_1    : in  STD_LOGIC_VECTOR(2 downto 0);  -- Second 3-bit input
        Sel        : in  STD_LOGIC;                     -- Selection control (1 bit for 2 inputs)
        Output     : out STD_LOGIC_VECTOR(2 downto 0)   -- 3-bit output
    );
end Mux_2way_3bit;

architecture Behavioral of Mux_2way_3bit is
begin
    -- Behavioral implementation
    Output <= Input_0 when Sel = '0' else Input_1;
end Behavioral;