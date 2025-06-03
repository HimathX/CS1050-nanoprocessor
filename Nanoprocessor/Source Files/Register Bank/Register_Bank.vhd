library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Register_Bank is
    Port (
        Data             : in  DataBus;          -- Data input to write to registers
        Reset            : in  STD_LOGIC;        -- Asynchronous reset signal
        Reg_En           : in  RegisterSelect;   -- Register selection address
        Clock            : in  STD_LOGIC;        -- System clock signal
        Register_Outputs : out RegisterFile      -- Array of all register contents
    );
end Register_Bank;

architecture Behavioral of Register_Bank is
    -- Component declarations
    component Decoder_3_to_8
        Port (
            I  : in  STD_LOGIC_VECTOR (2 downto 0);
            EN : in  STD_LOGIC;
            Y  : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    component Reg 
        Port (
            D   : in  STD_LOGIC_VECTOR(3 downto 0);
            Res : in  STD_LOGIC;
            En  : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Q   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    -- Internal signals
    signal Reg_Sel : STD_LOGIC_VECTOR(7 downto 0);  -- One-hot register selection signals
    
begin
    -- Address decoder - converts 3-bit address to one-hot selection
    Decoder_3_to_8_0 : Decoder_3_to_8
        port map(
            I  => Reg_En,
            EN => '1',        -- Always enabled
            Y  => Reg_Sel
        );
        
    -- Register 0 - Always contains zero
    Zero_Register : Reg
        port map(
            D   => "0000",    -- Hardwired to zero
            Res => Reset,
            En  => '1',       -- Always enabled
            Clk => Clock,
            Q   => Register_Outputs(0)
        );
    
    -- Registers 1-7 - General purpose registers
Register_1 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(1),   -- Enable for Register 1
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(1)
        );
    
    -- Register 2
    Register_2 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(2),   -- Enable for Register 2
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(2)
        );
    
    -- Register 3
    Register_3 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(3),   -- Enable for Register 3
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(3)
        );
    
    -- Register 4
    Register_4 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(4),   -- Enable for Register 4
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(4)
        );
    
    -- Register 5
    Register_5 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(5),   -- Enable for Register 5
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(5)
        );
    
    -- Register 6
    Register_6 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(6),   -- Enable for Register 6
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(6)
        );
    
    -- Register 7
    Register_7 : Reg
        port map(
            D   => Data,         -- Data input
            Res => Reset,        -- Reset signal
            En  => Reg_Sel(7),   -- Enable for Register 7
            Clk => Clock,        -- Clock signal
            Q   => Register_Outputs(7)
        );
    
end Behavioral;