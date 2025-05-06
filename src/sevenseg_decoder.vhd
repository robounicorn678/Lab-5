library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenSegDecoder is
  port(
    i_Data : in  STD_LOGIC_VECTOR(3 downto 0);  -- hex digit or special code
    o_Seg  : out STD_LOGIC_VECTOR(6 downto 0)   -- [6]=a … [0]=g, active-low
  );
end sevenSegDecoder;

architecture rtl of sevenSegDecoder is
begin
  with i_Data select
    -- 1) Sign codes
    o_Seg <= 
      "1111111" when "1111",  -- BLANK (all OFF)
      "1111110" when "1110",  -- MINUS (g=0, all others=1)

    -- 2) Digits 0-9
      "0000001" when "0000",  -- 0: a-f=0, g=1
      "1001111" when "0001",  -- 1: b,c
      "0010010" when "0010",  -- 2: a,b,d,e,g
      "0000110" when "0011",  -- 3: a,b,c,d,g
      "1001100" when "0100",  -- 4: b,c,f,g
      "0100100" when "0101",  -- 5: a,c,d,f,g
      "0100000" when "0110",  -- 6: a,c,d,e,f,g
      "0001111" when "0111",  -- 7: a,b,c
      "0000000" when "1000",  -- 8: a-g all on
      "0000100" when "1001",  -- 9: a,b,c,d,f,g

    -- 3) Default → blank
      "1111111" when others;
end rtl;
