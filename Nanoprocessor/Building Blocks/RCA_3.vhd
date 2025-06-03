library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_3 is
    Port ( 
        A     : in  STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit input A as a bus
        B     : in  STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit input B as a bus
        C_in  : in  STD_LOGIC;                     -- Carry input
        S     : out STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit sum output as a bus
        C_out : out STD_LOGIC                      -- Carry output
    );
end RCA_3;

architecture Behavioral of RCA_3 is 
    -- Full Adder component declaration
    component FA   
        port (   
            A     : in  std_logic;   
            B     : in  std_logic; 
            C_in  : in  std_logic;   
            S     : out std_logic; 
            C_out : out std_logic
        );   
    end component; 
     
    -- Internal carry signals
    SIGNAL carry : std_logic_vector(2 downto 0);
     
begin 
    -- First Full Adder
    FA_0 : FA 
        port map (   
            A     => A(0),   
            B     => B(0), 
            C_in  => C_in,   -- External carry input
            S     => S(0),   
            C_Out => carry(0)
        );  
 
    -- Second Full Adder
    FA_1 : FA 
        port map (   
            A     => A(1),   
            B     => B(1), 
            C_in  => carry(0),    
            S     => S(1),   
            C_Out => carry(1)
        ); 

    -- Third Full Adder
    FA_2 : FA 
        port map (   
            A     => A(2),   
            B     => B(2), 
            C_in  => carry(1),    
            S     => S(2),   
            C_Out => C_out
        ); 
                        
end Behavioral;