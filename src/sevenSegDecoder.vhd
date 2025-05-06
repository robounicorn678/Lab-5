library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenSegDecoder is
  port(
    i_D : in  STD_LOGIC_VECTOR(3 downto 0);  -- hex digit or special code
    o_S : out STD_LOGIC_VECTOR(6 downto 0)   -- segments a-g, active-low
  );
end sevenSegDecoder;

architecture rtl of sevenSegDecoder is
begin
  -- bit 6 = a (top)
  -- bit 5 = b (top right)
  -- bit 4 = c (bottom right)
  -- bit 3 = d (bottom)
  -- bit 2 = e (bottom left)
  -- bit 1 = f (top left)
  -- bit 0 = g (middle)
  with i_D select
    -- 1) Sign codes:
    --    "1111" => blank => all segments off = "1111111"
    --    "1110" => minus => only middle (g) ON = bit6=0, others=1 => "0111111"
    o_S <= "1111111" when "1111",
           "0111111" when "1110",

    -- 2) Digits 0-9:
    --    Active-high pattern for 0 is a,b,c,d,e,f=1, g=0  → invert for active-low:
    --    a..f=0, g=1 → bits [g=1,f=0,e=0,d=0,c=0,b=0,a=0] = "1000000"
           "1000000" when "0000",  -- 0
           "1111001" when "0001",  -- 1 (b,c ON)
           "0100100" when "0010",  -- 2 (a,b,d,e,g ON)
           "0110000" when "0011",  -- 3 (a,b,c,d,g ON)
           "0011001" when "0100",  -- 4 (b,c,f,g ON)
           "0010010" when "0101",  -- 5 (a,c,d,f,g ON)
           "0000010" when "0110",  -- 6 (a,c,d,e,f,g ON)
           "1111000" when "0111",  -- 7 (a,b,c ON)
           "0000000" when "1000",  -- 8 (all seven ON)
           "0010000" when "1001",  -- 9 (a,b,c,d,f,g ON)

    -- 3) Default to blank:
           "1111111" when others;
end rtl;
