library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity pong_tb is
end entity;

architecture tb of pong_tb is
  signal clk : std_logic := '0';

  constant period : time := 140 ns;
  constant half_period : time := period / 2;
begin
  UUT : entity work.pong port map (
    clk_7_159 => clk,

    p1_up => '0',
    p1_down => '0',
    p2_up => '0',
    p2_down => '0',
    coin_insert => '0');

  clk <= not clk after half_period;

  process
  begin
    -- for i in 0 to 454 * 261 * 50 loop
    --   wait for period;
    -- end loop;
    wait for 200 ms;

    stop;
  end process;

end architecture;