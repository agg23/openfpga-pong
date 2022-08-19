-- These test benches are out of date and will not function without modificiation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity hsync_tb is
end entity;

architecture tb of hsync_tb is
  signal clk : std_logic := '0';

  signal h_reset : std_logic;
  signal h_count : unsigned (8 downto 0);

  signal h_blank : std_logic;
  signal h_sync : std_logic;

  constant period : time := 2 ns;
  constant half_period : time := period / 2;
begin
  HCOUNTER : entity work.hcounter port map (clk_7_159 => clk, h_reset => h_reset, h_count => h_count);

  UUT : entity work.hsync port map (
    clk_7_159 => clk,

    h16 => h_count(4),
    h32 => h_count(5),
    h64 => h_count(6),

    h_reset => h_reset,
    h_blank => h_blank,
    h_sync => h_sync
    );

  clk <= not clk after half_period;

  process
  begin
    for i in 0 to 454 * 2 loop
      wait for period;
    end loop;

    stop;
  end process;
end architecture;