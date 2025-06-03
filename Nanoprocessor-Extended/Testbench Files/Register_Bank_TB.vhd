library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Register_Bank_TB is
end Register_Bank_TB;

architecture Behavioral of Register_Bank_TB is
    -- Component Declaration
    component Register_Bank
        Port (
            Data             : in  DataBus;
            Reset            : in  STD_LOGIC;
            Reg_En           : in  RegisterSelect;
            Clock            : in  STD_LOGIC;
            Register_Outputs : out RegisterFile
        );
    end component;
    
    -- Test signals
    signal Data_TB           : DataBus := "0000";
    signal Reset_TB          : STD_LOGIC := '0';
    signal Reg_En_TB         : RegisterSelect := "000";
    signal Clock_TB          : STD_LOGIC := '0';
    signal Register_Outputs_TB : RegisterFile;
    
    -- Clock period
    constant Clock_Period : time := 100 ns;
    
begin
    -- Instantiate Register Bank
    UUT: Register_Bank port map (
        Data             => Data_TB,
        Reset            => Reset_TB,
        Reg_En           => Reg_En_TB,
        Clock            => Clock_TB,
        Register_Outputs => Register_Outputs_TB
    );
    
    -- Clock generation - run for longer to accommodate all test cases
    Clock_process: process
    begin
        while now < 1200 ns loop  -- Extended simulation time
            Clock_TB <= '0';
            wait for Clock_Period/2;
            Clock_TB <= '1';
            wait for Clock_Period/2;
        end loop;
        wait; -- Stop the clock after simulation time
    end process;
    
    -- Test sequence
    Stim_process: process
    begin
        -- Initial reset
        Reset_TB <= '1';
        wait for 100 ns;  -- Full clock cycle for reset
        Reset_TB <= '0';
        
        -- Change values after falling edge, capture on rising edge
        wait until falling_edge(Clock_TB);
        
        -- Test Register 1
        Reg_En_TB <= "001";  -- Select R1
        Data_TB <= "0101";   -- Value 5
        wait for Clock_Period;  -- Wait for full clock cycle
        
        -- Test Register 2
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "010";  -- Select R2
        Data_TB <= "1010";   -- Value 10
        wait for Clock_Period;
        
        -- Test Register 3
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "011";  -- Select R3
        Data_TB <= "1111";   -- Value 15
        wait for Clock_Period;
        
        -- Test Register 4
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "100";  -- Select R4
        Data_TB <= "0011";   -- Value 3
        wait for Clock_Period;
        
        -- Test Register 5
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "101";  -- Select R5
        Data_TB <= "0111";   -- Value 7
        wait for Clock_Period;
        
        -- Test Register 6
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "110";  -- Select R6
        Data_TB <= "1001";   -- Value 9
        wait for Clock_Period;
        
        -- Test Register 7
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "111";  -- Select R7
        Data_TB <= "1100";   -- Value 12
        wait for Clock_Period;
        
        -- Try to write to Register 0 (should remain 0)
        wait until falling_edge(Clock_TB);
        Reg_En_TB <= "000";  -- Select R0
        Data_TB <= "1111";   -- Try to write 15
        wait for Clock_Period;
        
        -- Test reset after writing
        wait until falling_edge(Clock_TB);
        Reset_TB <= '1';
        wait for Clock_Period;
        Reset_TB <= '0';
        
        -- Complete the test
        report "Test complete. Check waveform for verification.";
        wait;
    end process;
end Behavioral;