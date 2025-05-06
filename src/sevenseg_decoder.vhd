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
    -- 1) Sign codes (inverted+reversed)
    o_seg_n <= 
      "0000000" when "1111",  -- BLANK: was "1111111" → inv="0000000" → rev="0000000"
      "1000000" when "1110",  -- MINUS: was "1111110" → inv="0000001" → rev="1000000"

    -- 2) Digits 0-9 (inverted+reversed)
      "0111111" when "0000",  -- 0: was "0000001" → inv="1111110" → rev="0111111"
      "0000110" when "0001",  -- 1: was "1001111" → inv="0110000" → rev="0000110"
      "1011011" when "0010",  -- 2: was "0010010" → inv="1101101" → rev="1011011"
      "1001111" when "0011",  -- 3: was "0000110" → inv="1111001" → rev="1001111"
      "1100110" when "0100",  -- 4: was "1001100" → inv="0110011" → rev="1100110"
      "1101101" when "0101",  -- 5: was "0100100" → inv="1011011" → rev="1101101"
      "1111101" when "0110",  -- 6: was "0100000" → inv="1011111" → rev="1111101"
      "0000111" when "0111",  -- 7: was "0001111" → inv="1110000" → rev="0000111"
      "1111111" when "1000",  -- 8: was "0000000" → inv="1111111" → rev="1111111"
      "1101111" when "1001",  -- 9: was "0000100" → inv="1111011" → rev="1101111"

    -- 3) Default → blank
      "0000000" when others;  -- catch-all blank
end rtl;
