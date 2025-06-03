library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity RegisterData_Multiplexer is
    Port ( 
        DataSources   : in  RegisterFile;
        SelectAddress : in  RegisterSelect;
        OutputData    : out DataBus
    );
end RegisterData_Multiplexer;

architecture Behavioral of RegisterData_Multiplexer is
    component Mux_8way_4bit
        port(
            Input_0    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_1    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_2    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_3    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_4    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_5    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_6    : in  STD_LOGIC_VECTOR(3 downto 0);
            Input_7    : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel        : in  STD_LOGIC_VECTOR(2 downto 0);
            Output     : out STD_LOGIC_VECTOR(3 downto 0)
        );   
    end component;    
begin
    -- Instantiate the multiplexer component and connect the ports
    MUX_INST: Mux_8way_4bit port map(
        Input_0 => DataSources(0),
        Input_1 => DataSources(1),
        Input_2 => DataSources(2),
        Input_3 => DataSources(3),
        Input_4 => DataSources(4),
        Input_5 => DataSources(5),
        Input_6 => DataSources(6),
        Input_7 => DataSources(7),
        Sel     => SelectAddress,
        Output  => OutputData
    );
end Behavioral;