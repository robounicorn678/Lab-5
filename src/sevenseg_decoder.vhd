library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenseg_decoder is
  port(
    i_Hex   : in  STD_LOGIC_VECTOR(3 downto 0);  -- TB drives this
    o_seg_n : out STD_LOGIC_VECTOR(6 downto 0)   -- TB probes this
    );
end sevenseg_decoder;

architecture rtl of sevenseg_decoder is
begin
  with i_Hex select
    -- blank and minus
    o_seg_n <= 
      "1111111" when "1111",  -- BLANK (all off)
      "0111111" when "1110",  -- MINUS (only bit6=g=0 → middle bar)

    -- digits 0-9
      "1000000" when "0000",  -- 0: a-f on, g off
      "1111001" when "0001",  -- 1: b,c on
      "0100100" when "0010",  -- 2: a,b,d,e,g on
      "0110000" when "0011",  -- 3: a,b,c,d,g on
      "0011001" when "0100",  -- 4: b,c,f,g on
      "0010010" when "0101",  -- 5: a,c,d,f,g on
      "0000010" when "0110",  -- 6: a,c,d,e,f,g on
      "1111000" when "0111",  -- 7: a,b,c on
      "0000000" when "1000",  -- 8: all on
      "0000100" when "1001",  -- 9: a,b,c,d,f,g on

    -- default → blank
      "1111111" when others;  -- catch-all off
end rtl;
