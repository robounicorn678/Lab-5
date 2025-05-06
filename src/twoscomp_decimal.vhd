library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity twos_comp is
  port (
    i_binary   : in  std_logic_vector(7 downto 0);
    o_negative : out std_logic;
    o_hundreds : out std_logic_vector(3 downto 0);
    o_tens     : out std_logic_vector(3 downto 0);
    o_ones     : out std_logic_vector(3 downto 0)
  );
end twos_comp;

architecture Behavioral of twos_comp is
  -- no changes needed here, just refer to the new port names
begin
  process(i_binary)
    variable signed_val : integer;
    variable abs_val    : integer;
  begin
    signed_val := to_integer(signed(i_binary));
    if signed_val < 0 then
      o_negative <= '1';
      abs_val := -signed_val;
    else
      o_negative <= '0';
      abs_val := signed_val;
    end if;

    o_hundreds <= std_logic_vector(to_unsigned(abs_val/100,4));
    abs_val := abs_val mod 100;
    o_tens     <= std_logic_vector(to_unsigned(abs_val/10,4));
    abs_val := abs_val mod 10;
    o_ones     <= std_logic_vector(to_unsigned(abs_val,4));
  end process;
end Behavioral;
