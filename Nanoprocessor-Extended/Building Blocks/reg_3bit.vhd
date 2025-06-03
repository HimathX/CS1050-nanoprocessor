library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_3bit is
    Port (
        D   : in  STD_LOGIC_VECTOR(2 downto 0);
        Res : in  STD_LOGIC;
        En  : in  STD_LOGIC;
        Clk : in  STD_LOGIC;
        Q   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end reg_3bit;
architecture Behavioral of reg_3bit is
    signal Q_internal : STD_LOGIC_VECTOR(2 downto 0);
begin
    process(Clk, Res)
    begin
        if Res = '1' then
            Q_internal <= (others => '0');
        elsif rising_edge(Clk) then
            if En = '1' then
                Q_internal <= D;
            end if;
        end if;
    end process;
    Q <= Q_internal;
end Behavioral;