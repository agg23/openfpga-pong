library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity vcounter_tb is
end entity;

architecture tb of vcounter_tb is
  signal clk : std_logic := '0';

  signal v_reset : std_logic;

  constant half_period : time := 1 ns;

  procedure ToggleClock(signal clk : out std_logic) is
  begin
    clk <= '1';
    wait for half_period;
    clk <= '0';
    wait for half_period;
  end procedure;
begin
  UUT : entity work.vcounter port map (h_reset_clk => clk, v_reset => v_reset);

  process
  begin
    for i in 0 to 261 loop
      assert(v_reset = '0');
      ToggleClock(clk);
    end loop;

    assert(v_reset = '1');

    ToggleClock(clk);

    for i in 0 to 259 loop
      assert(v_reset = '0');
      ToggleClock(clk);
    end loop;

    assert(v_reset = '1');

    stop;
  end process;
end architecture;