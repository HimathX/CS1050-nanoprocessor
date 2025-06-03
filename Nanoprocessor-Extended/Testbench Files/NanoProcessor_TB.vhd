library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity NanoProcessor_TB is
-- No ports in testbench
end NanoProcessor_TB;

architecture Behavioral of NanoProcessor_TB is
    -- Component declaration
    component NanoProcessor
        port(
            Clock        : in  std_logic;
            Reset        : in  std_logic;
            Overflow     : out std_logic;
            Zero         : out std_logic;
            Equal        : out STD_LOGIC;
            LessThan     : out STD_LOGIC;
            GreaterThan  : out STD_LOGIC;
            S_7Seg       : out STD_LOGIC_VECTOR(6 downto 0);
            anode   : out STD_LOGIC_VECTOR(3 downto 0);
            Data_7       : out DataBus;
            Data_6       : out DataBus
        );
    end component;
    
    -- Input signals
    signal Clock    : std_logic := '0';
    signal Reset    : std_logic := '0';
    
    -- Output signals
    signal Overflow     : std_logic;
    signal Zero         : std_logic;
    signal Equal        : std_logic;
    signal LessThan     : std_logic;
    signal GreaterThan  : std_logic;
    signal S_7Seg       : STD_LOGIC_VECTOR(6 downto 0);
    signal anode        : STD_LOGIC_VECTOR(3 downto 0);
    signal Data_7       : DataBus;
    signal Data_6       : DataBus;
    
begin
    -- Instantiate NanoProcessor
    UUT: NanoProcessor port map(
        Clock        => Clock,
        Reset        => Reset,
        Overflow     => Overflow,
        Zero         => Zero,
        Equal        => Equal,
        LessThan     => LessThan,
        GreaterThan  => GreaterThan,
        anode        => anode,
        S_7Seg       => S_7Seg,
        Data_7       => Data_7,
        Data_6       => Data_6
    );
    
    -- Clock process
    Clock_process: process
    begin
        Clock <= '0';
        wait for 50 ns;
        Clock <= '1';
        wait for 50 ns;
    end process;
    
    -- Stimulus process
    Stimulus_process: process
    begin
        -- Initial reset
        Reset <= '1';
        wait for 10 ns;
        
        -- Release reset and let the program run
        Reset <= '0';
        
        -- Wait for program execution
        wait for 20 ns;
        
        -- End simulation
        wait;
    end process;
    
end Behavioral;