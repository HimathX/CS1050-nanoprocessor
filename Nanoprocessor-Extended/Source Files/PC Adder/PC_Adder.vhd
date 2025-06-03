library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.ProgramCounter;

entity PC_Adder is
    port (
        current_address : in  ProgramCounter;  -- Current program counter value
        next_address    : out ProgramCounter   -- Next program counter value (current + 1)
    );
end PC_Adder;

architecture Behavioral of PC_Adder is
    COMPONENT RCA_3
        Port (
            A     : in  STD_LOGIC_VECTOR(2 downto 0);  
            B     : in  STD_LOGIC_VECTOR(2 downto 0);  
            C_in  : in  STD_LOGIC;                     
            S     : out STD_LOGIC_VECTOR(2 downto 0);  
            C_out : out STD_LOGIC                     
        );
    END COMPONENT;
    
    constant INCREMENT_VALUE : std_logic_vector(2 downto 0) := "001";  -- Increment by 1
begin
    AddressAdder : RCA_3 port map (
        A     => current_address,
        B     => INCREMENT_VALUE,
        C_in  => '0',               -- No carry-in for simple addition
        S     => next_address,      -- Sum output is the incremented address
        C_out => open               -- Carry-out not used
    );
end Behavioral;