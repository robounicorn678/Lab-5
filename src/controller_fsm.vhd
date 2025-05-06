library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenSegDecoder is
  port(
    i_D : in  STD_LOGIC_VECTOR(3 downto 0);  -- hex digit 0-F
    o_S : out STD_LOGIC_VECTOR(6 downto 0)   -- segments a-g
  );
end sevenSegDecoder;

architecture rtl of sevenSegDecoder is
begin
  -- common-cathode: '1' lights a segment, '0' turns it off
  with i_D select
    o_S <= "1111110" when "0000",  -- 0
           "0110000" when "0001",  -- 1
           "1101101" when "0010",  -- 2
           "1111001" when "0011",  -- 3
           "0110011" when "0100",  -- 4
           "1011011" when "0101",  -- 5
           "1011111" when "0110",  -- 6
           "1110000" when "0111",  -- 7
           "1111111" when "1000",  -- 8
           "1111011" when "1001",  -- 9
           "1110111" when "1010",  -- A
           "0011111" when "1011",  -- b
           "1001110" when "1100",  -- C
           "0111101" when "1101",  -- d
           "1001111" when "1110",  -- E
           "1000111" when "1111",  -- F
           "0000000" when others;  -- all segments off
end rtl;
