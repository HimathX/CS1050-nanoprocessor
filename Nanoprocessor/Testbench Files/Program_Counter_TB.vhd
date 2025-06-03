library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Program_Counter_TB is
end Program_Counter_TB;

architecture Behavioral of Program_Counter_TB is

    -- Component under test
    component Program_Counter is
        Port (
            PC_Next    : in  ProgramCounter; 
            Res        : in  STD_LOGIC;
            Clk        : in  STD_LOGIC;
            PC_Current : out ProgramCounter
        );
    end component;

    -- Signals
    signal tb_PC_Next    : ProgramCounter := (others => '0');
    signal tb_Res        : STD_LOGIC := '0';
    signal tb_Clk        : STD_LOGIC := '0';
    signal tb_PC_Current : ProgramCounter;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Program_Counter
        port map (
            PC_Next    => tb_PC_Next,
            Res        => tb_Res,
            Clk        => tb_Clk,
            PC_Current => tb_PC_Current
        );

    -- Clock generation process
    clk_process: process
    begin
        while now < 200 ns loop
            tb_Clk <= '0';
            wait for CLK_PERIOD / 2;
            tb_Clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply Reset
        tb_Res <= '1';
        wait for CLK_PERIOD;
        tb_Res <= '0';

        -- Load new PC values on each clock cycle
        for i in 0 to 7 loop
            tb_PC_Next <= std_logic_vector(to_unsigned(i, 3));
            wait for CLK_PERIOD;
        end loop;

        wait;
    end process;

end Behavioral;
