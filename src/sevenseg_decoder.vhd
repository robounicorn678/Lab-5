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
    -- 1) BLANK & MINUS
    o_seg_n <=
--      "1111111" when "1111",  -- BLANK: all segments off
--      "0111111" when "1110",  -- MINUS: only g=1 (off), a-f=0 (on)

    -- 2) DIGITS 0-9
      "1000000" when "0000",  -- 0: a-f on (0), g off (1)
      "1111001" when "0001",  -- 1: b,c on
      "0100100" when "0010",  -- 2: a,b,d,e,g
      "0110000" when "0011",  -- 3: a,b,c,d,g
      "0011001" when "0100",  -- 4: b,c,f,g
      "0010010" when "0101",  -- 5: a,c,d,f,g
      "0000010" when "0110",  -- 6: a,c,d,e,f,g
      "1111000" when "0111",  -- 7: a,b,c
      "0000000" when "1000",  -- 8: all segments on
      "0011000" when "1001",  -- 9: a,b,c,d,f,g
      
      -- A-F
      "0001000" when "1010",  -- A
      "0000011" when "1011",  -- b
      "0001101" when "1100",  -- C
      "1000110" when "1101",  -- d
      "0000110" when "1110",  -- E
      "0001110" when "1111",  -- F

    -- 3) DEFAULT → BLANK
      "1111111" when others;  -- catch-all off
end rtl;
