library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow_Clk_TB is
end Slow_Clk_TB;

architecture Behavioral of Slow_Clk_TB is

    -- Component under test
    component Slow_Clk is
        Port (
            Clk_in  : in  STD_LOGIC;
            Clk_out : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal tb_Clk_in  : STD_LOGIC := '0';
    signal tb_Clk_out : STD_LOGIC;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Slow_Clk
        port map (
            Clk_in  => tb_Clk_in,
            Clk_out => tb_Clk_out
        );

    -- Generate input clock (50 MHz => 10 ns period)
    clk_process: process
    begin
        while now < 500 ns loop
            tb_Clk_in <= '0';
            wait for CLK_PERIOD / 2;
            tb_Clk_in <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Optional: Observe Clk_out edges here if needed
    -- You can print to console or use waveform viewer

end Behavioral;
