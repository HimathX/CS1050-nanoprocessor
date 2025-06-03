library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity RegisterData_Multiplexer_TB is
-- Testbench has no ports
end RegisterData_Multiplexer_TB;

architecture Behavioral of RegisterData_Multiplexer_TB is
    -- Component declaration for Unit Under Test (UUT)
    component RegisterData_Multiplexer
        Port ( 
            DataSources   : in  RegisterFile;
            SelectAddress : in  RegisterSelect;
            OutputData    : out DataBus
        );
    end component;
    
    -- Test signals
    signal test_DataSources   : RegisterFile;
    signal test_SelectAddress : RegisterSelect;
    signal test_OutputData    : DataBus;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: RegisterData_Multiplexer port map (
        DataSources   => test_DataSources,
        SelectAddress => test_SelectAddress,
        OutputData    => test_OutputData
    );
    
    -- Simple stimulus process
    stim_proc: process
    begin
        -- Initialize all registers with test data
        test_DataSources(0) <= "0000";  -- R0 = 0
        test_DataSources(1) <= "0001";  -- R1 = 1
        test_DataSources(2) <= "0010";  -- R2 = 2
        test_DataSources(3) <= "0011";  -- R3 = 3
        test_DataSources(4) <= "0100";  -- R4 = 4
        test_DataSources(5) <= "0101";  -- R5 = 5
        test_DataSources(6) <= "0110";  -- R6 = 6
        test_DataSources(7) <= "0111";  -- R7 = 7
        
        -- Test a few register selections
        
        -- Test Register 0
        test_SelectAddress <= "000";
        wait for 100 ns;
        assert test_OutputData = "0000" 
            report "Test failed for R0";
        
        -- Test Register 3
        test_SelectAddress <= "011";
        wait for 100 ns;
        assert test_OutputData = "0011" 
            report "Test failed for R3";
        
        -- Test Register 7
        test_SelectAddress <= "111";
        wait for 100 ns;
        assert test_OutputData = "0111" 
            report "Test failed for R7";
        
        -- Change some register values and test again
        test_DataSources(3) <= "1100";  -- Change R3 to 12
        test_SelectAddress <= "011";    -- Select R3
        wait for 100 ns;
        assert test_OutputData = "1100" 
            report "Test failed for R3 after change";
        
        -- Report test completion
        report "All tests passed successfully";
        wait;  -- End simulation
    end process;
end Behavioral;