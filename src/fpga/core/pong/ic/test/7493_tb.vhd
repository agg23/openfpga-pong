-- These test benches are out of date and will not function without modificiation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity ic7493_tb is
end entity;

architecture tb of ic7493_tb is
  signal clk_sync : std_logic := '0';

  signal bit1 : std_logic := '0';
  signal bit3 : std_logic := '0';

  signal r_1 : std_logic := '0';
  signal r_2 : std_logic := '0';

  signal count : unsigned (3 downto 0);

  constant clk_period : time := 8 ns;

  constant clk_half_period : time := clk_period / 2;
  constant sync_half_period : time := clk_half_period / 4;

  procedure ToggleClock(signal clk : inout std_logic) is
  begin
    clk <= '1';
    wait for clk_half_period;
    clk <= '0';
    wait for clk_half_period;
  end procedure;
begin
  UUT : entity work.ic7493 port map (clk_sync => clk_sync, in_1bit => bit1, in_3bit => bit3, r_1 => r_1, r_2 => r_2, count => count);

  clk_sync <= not clk_sync after sync_half_period;

  process
  begin
    -- Test single bit
    -- r_1 <= '1';
    -- r_2 <= '1';
    -- wait for clk_half_period;
    -- r_1 <= '0';
    -- r_2 <= '0';

    wait for 0.5 ns;
    bit1 <= '1';
    wait for 0.5 ns;

    bit1 <= '0';
    wait for 0.5 ns;

    bit1 <= '1';
    wait for 0.5 ns;

    bit1 <= '0';
    wait for 0.5 ns;

    -- assert(count = x"0");

    -- bit1 <= '1';
    -- wait for clk_half_period;

    -- assert(count = x"0");

    -- bit1 <= '0';
    -- wait for clk_half_period;

    -- assert(count = x"1");

    -- ToggleClock(bit1);
    -- assert(count = x"0");

    -- for i in 1 to 7 loop
    --   ToggleClock(bit3);
    --   assert(count = to_unsigned(i, 3) & '0');
    -- end loop;

    -- ToggleClock(bit1);
    -- assert(count = x"F");

    -- ToggleClock(bit3);
    -- assert(count = x"1");

    -- r_1 <= '1';
    -- assert(count = x"1");

    -- wait for clk_half_period;

    -- r_2 <= '1';
    -- assert(count = x"0");

    -- ToggleClock(bit1);
    -- ToggleClock(bit3);
    -- assert(count = x"0");

    stop;
  end process;
end architecture;