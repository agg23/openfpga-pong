library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity vcounter is
  port (
    h_reset_clk : in std_logic;

    v_reset : out std_logic := '0'
  );
end entity;

architecture rtl of vcounter is
  signal count : unsigned (8 downto 0) := 9b"0";
begin
  process (h_reset_clk)
  begin
    if rising_edge(h_reset_clk) then
      v_reset <= '1' when count = 9d"261" else '0';

      if count = 9d"261" then
        count <= 9b"0";
      end if;
    elsif falling_edge(h_reset_clk) then
      count <= count + 1;
    end if;
  end process;
end architecture;