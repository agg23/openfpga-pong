library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity hcounter_tb is
end entity;

architecture tb of hcounter_tb is
  signal clk : std_logic := '0';

  signal h_reset : std_logic;

  constant half_period : time := 1 ns;

  procedure ToggleClock(signal clk : out std_logic) is
  begin
    clk <= '1';
    wait for half_period;
    clk <= '0';
    wait for half_period;
  end procedure;
begin
  UUT : entity work.hcounter port map (clk => clk, h_reset => h_reset);

  process
  begin
    for i in 0 to 454 loop
      assert(h_reset = '0');
      ToggleClock(clk);
    end loop;

    assert(h_reset = '1');

    ToggleClock(clk);

    for i in 0 to 452 loop
      assert(h_reset = '0');
      ToggleClock(clk);
    end loop;

    assert(h_reset = '1');

    stop;
  end process;
end architecture;