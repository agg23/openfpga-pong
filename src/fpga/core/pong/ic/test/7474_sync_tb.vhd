library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity ic7474_sync_tb is
end entity;

architecture tb of ic7474_sync_tb is
  signal data : std_logic := '0';
  signal clk_sync : std_logic := '0';
  signal clk : std_logic := '0';

  signal reset : std_logic := '1';
  signal clr : std_logic := '1';

  signal output : std_logic;

  constant clk_period : time := 8 ns;

  constant clk_half_period : time := clk_period / 2;
  constant sync_half_period : time := clk_half_period / 4;
begin
  UUT : entity work.ic7474_sync port map (data => data, clk_sync => clk_sync, clk => clk, reset => reset, clr => clr, output => output);

  clk <= not clk after clk_half_period;
  clk_sync <= not clk_sync after sync_half_period;

  process
  begin
    wait for clk_period;
    wait for clk_period;

    data <= '1';

    wait for clk_period;

    data <= '0';

    wait for clk_period;

    data <= '1';

    wait for clk_period / 2;

    data <= '0';

    wait for clk_period / 2;

    stop;
  end process;
end architecture;