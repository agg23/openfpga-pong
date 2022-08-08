library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sr_latch is
  port (
    -- Clock is a hack to try to enforce some propogation delays
    clk : in std_logic;

    s : in std_logic;
    r : in std_logic;

    q : out std_logic
  );
end entity;

architecture rtl of sr_latch is
  signal latch : std_logic := '0';
begin
  q <= latch;

  process (clk)
    variable sr : unsigned (1 downto 0);
  begin
    if rising_edge(clk) then
      sr := s & r;
      case sr is
        when b"01" =>
          latch <= '1';
        when b"10" =>
          latch <= '0';
        when others => null;
      end case;
    end if;
  end process;
end architecture;