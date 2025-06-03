library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_2_to_4 is
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           EN : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end Decoder_2_to_4;

architecture Behavioral of Decoder_2_to_4 is
begin
    process(I, EN)
    begin   
        Y(0) <= EN and (not I(0)) and (not I(1));  -- For input "00"
        Y(1) <= EN and (not I(1)) and I(0);        -- For input "01" 
        Y(2) <= EN and I(1) and (not I(0));        -- For input "10"
        Y(3) <= EN and I(1) and I(0); 
    end process;
end Behavioral;