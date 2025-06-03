library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Load_Selector is
    Port (
        RegisterValue  : in  DataBus;           -- Input from register (for ADD/NEG)
        ImmediateValue : in  DataBus;           -- Immediate value (for MOVI)
        LoadSelect     : in  STD_LOGIC;         -- Selection control from instruction decoder
        OutputData     : out DataBus            -- Selected output to ALU
    );
end Load_Selector;

architecture Behavioral of Load_Selector is
    -- Component declaration for 2-way 4-bit MUX
    component Mux_2way_4bit
        Port (
            Input_0 : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_1 : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel     : in  STD_LOGIC;
            Output  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin
    -- Instantiate the 2-way 4-bit MUX
    DataSourceMux: Mux_2way_4bit port map (
        Input_1 => RegisterValue,     -- When LoadSelect=1, use register value
        Input_0 => ImmediateValue,    -- When LoadSelect=0, use immediate value
        Sel     => LoadSelect,
        Output  => OutputData
    );
    
end Behavioral;