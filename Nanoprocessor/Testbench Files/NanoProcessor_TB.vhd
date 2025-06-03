library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity NanoProcessor_TB is
-- No ports for testbench
end NanoProcessor_TB;

architecture Behavioral of NanoProcessor_TB is
    -- Component declaration for the Unit Under Test (UUT)
    component NanoProcessor
        port(
            Clock    : in  std_logic;
            Reset    : in  std_logic;
            Overflow : out std_logic;
            Zero     : out std_logic;
            S_7Seg   : out STD_LOGIC_VECTOR(6 downto 0);
            Data     : out DataBus
        );
    end component;
    
    -- Input signals
    signal Clock    : std_logic := '0';
    signal Reset    : std_logic := '0';
    
    -- Output signals
    signal Overflow : std_logic;
    signal Zero     : std_logic;
    signal S_7Seg   : STD_LOGIC_VECTOR(6 downto 0);
    signal Data     : DataBus;
    
    -- Clock period definition
    constant Clock_period : time := 10 ns;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: NanoProcessor port map(
        Clock    => Clock,
        Reset    => Reset,
        Overflow => Overflow,
        Zero     => Zero,
        S_7Seg   => S_7Seg,
        Data     => Data
    );
    
    -- Clock process
    Clock_process: process
    begin
        Clock <= '0';
        wait for Clock_period/2;
        Clock <= '1';
        wait for Clock_period/2;
    end process;
    
    -- Stimulus process
    Stimulus_process: process
    begin
        -- Hold reset state for 100 ns
        Reset <= '1';
        wait for 100 ns;
        
        -- Release reset
        Reset <= '0';
        
        -- Wait for program execution (adjust based on your program length)
        -- For an 8-instruction program with slow clock, this should be enough time
        wait for 3000 ns;
        
        -- Apply reset again to restart program (optional)
        Reset <= '1';
        wait for 100 ns;
        Reset <= '0';
        
        -- Continue simulation
        wait for 3000 ns;
        
        -- End simulation
        wait;
    end process;
    
    -- Monitor process to display outputs
    Monitor_process: process(Clock)
    begin
        if rising_edge(Clock) then
        end if;
    end process;
    
end Behavioral;