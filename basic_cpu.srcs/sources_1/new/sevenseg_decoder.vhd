library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- This wrapper makes "sevenseg_decoder" bind to your real sevenSegDecoder
entity sevenseg_decoder is
  port(
    i_Data : in  STD_LOGIC_VECTOR(3 downto 0);
    o_Seg  : out STD_LOGIC_VECTOR(6 downto 0)
  );
end sevenseg_decoder;

architecture rtl of sevenseg_decoder is
begin
  U0: entity work.sevenSegDecoder(rtl)
    port map(
      i_D => i_Data,   -- your real port
      o_S => o_Seg     -- your real port
    );
end rtl;
