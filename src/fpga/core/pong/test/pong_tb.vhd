library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity pong_tb is
end entity;

architecture tb of pong_tb is
  signal clk : std_logic := '0';
  signal clk_sync : std_logic := '0';

  signal coin_insert : std_logic := '0';

  constant period : time := 140 ns;
  constant half_period : time := period / 2;
  constant sync_half_period : time := half_period / 4;
begin
  UUT : entity work.pong port map (
    clk_7_159 => clk,
    clk_sync => clk_sync,

    p1_up => '0',
    p1_down => '0',
    p2_up => '0',
    p2_down => '0',
    coin_insert => coin_insert);

  clk <= not clk after half_period;
  clk_sync <= not clk_sync after sync_half_period;

  process
  begin
    -- for i in 0 to 454 * 261 * 50 loop
    --   wait for period;
    -- end loop;
    wait for 50 ms;

    coin_insert <= '1';

    wait for 10 ms;

    coin_insert <= '0';

    wait for 200 ms;

    -- wait for 100 ms;
    stop;
  end process;

end architecture;