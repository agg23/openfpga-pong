library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vcounter is
  port (
    h_reset_clk : in std_logic;

    v_reset : out std_logic := '0';
    v_count : out unsigned (8 downto 0)
  );
end entity;

architecture rtl of vcounter is
  signal count : unsigned (8 downto 0) := 9b"0";
begin
  v_count <= count;

  process (h_reset_clk)
  begin
    if v_reset then
      count <= 9b"0";
    elsif falling_edge(h_reset_clk) then
      count <= count + 1;
    end if;
  end process;

  process (h_reset_clk)
  begin
    if rising_edge(h_reset_clk) then
      if count = 261 then
        v_reset <= '1';
      else
        v_reset <= '0';
      end if;
    end if;
  end process;
end architecture;