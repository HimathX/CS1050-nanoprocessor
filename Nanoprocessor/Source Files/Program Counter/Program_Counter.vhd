library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;  

entity Program_Counter is
    Port (
        PC_Next    : in  ProgramCounter; 
        Res        : in  STD_LOGIC;
        Clk        : in  STD_LOGIC;
        PC_Current : out ProgramCounter
    );
end Program_Counter;

architecture Behavioral of Program_Counter is
    component reg_3bit
        Port (
            D   : in  STD_LOGIC_VECTOR(2 downto 0);
            Res : in  STD_LOGIC;
            En  : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Q   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component; 
begin
    PC_Register : reg_3bit
        port map(
            D   => PC_Next,
            Res => Res, 
            En  => '1',
            Clk => Clk, 
            Q   => PC_Current
        );
end Behavioral;