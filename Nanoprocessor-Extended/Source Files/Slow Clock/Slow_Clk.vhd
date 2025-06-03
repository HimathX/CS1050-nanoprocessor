library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow_Clk is
    Port ( Clk_in : in STD_LOGIC;
           Clk_out : out STD_LOGIC);
end Slow_Clk;

architecture Behavioral of Slow_Clk is
    signal count : integer := 0;
    signal clk_status : std_logic := '0';
begin
    process (Clk_in) begin
        if rising_edge(Clk_in) then
            count <= count + 1;
            
            -- Change this value to adjust clock division factor
            -- 5 will divide clock by 10 (toggle every 5 cycles)
            if(count = 50000000) then     
                clk_status <= not clk_status; -- Toggle clock
                count <= 0;                   -- Reset counter
            end if;
        end if;
    end process;
    
    Clk_out <= clk_status;  -- Connect internal clock status to output
end Behavioral;