library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Needed for signed comparisons
use work.BusDefinitions.all; 

entity Comparator_4_bit is
    Port(
        Input_A           : in  DataBus;
        Input_B           : in  DataBus;
        Equal_Flag        : out STD_LOGIC;
        LessThan_Flag     : out STD_LOGIC;
        GreaterThan_Flag  : out STD_LOGIC
    );
end Comparator_4_bit;

architecture Behavioral of Comparator_4_bit is
begin
    Compare_Process: process(Input_A, Input_B)
    begin
        if SIGNED(Input_A) = SIGNED(Input_B) then
            Equal_Flag        <= '1';
            LessThan_Flag     <= '0';
            GreaterThan_Flag  <= '0';
        elsif SIGNED(Input_A) < SIGNED(Input_B) then
            Equal_Flag        <= '0';
            LessThan_Flag     <= '1';
            GreaterThan_Flag  <= '0';
        else
            Equal_Flag        <= '0';
            LessThan_Flag     <= '0';
            GreaterThan_Flag  <= '1';
        end if;
    end process;
end Behavioral;
