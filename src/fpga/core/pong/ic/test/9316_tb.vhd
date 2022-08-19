-- These test benches are out of date and will not function without modificiation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity ic9316_tb is
end entity;

architecture rtl of ic9316_tb is
  signal clk : std_logic := '0';

  signal clr : std_logic := '1';

  signal input : unsigned (3 downto 0) := x"7";

  signal load : std_logic := '1';
  signal en_p : std_logic := '1';
  signal en_t : std_logic := '1';

  signal output : unsigned (3 downto 0);
  signal ripple_carry_output : std_logic;

  constant period : time := 2 ns;
  constant half_period : time := period / 2;

  -- signal input
begin
  UUT : entity work.ic9316 port map (
    clk => clk,
    clr => clr,

    input => input,

    load => load,
    en_p => en_p,
    en_t => en_t,

    output => output,
    ripple_carry_output => ripple_carry_output
    );

  clk <= not clk after half_period;

  process
  begin
    wait for half_period;

    -- Test basic counting
    for i in 0 to 20 loop
      assert(output = to_unsigned(i, 4));
      wait for period;
    end loop;

    -- Counting should stop when setting enables to low
    en_p <= '0';
    -- en_t <= '0';

    for i in 0 to 5 loop
      assert(output = x"5");
      wait for period;
    end loop;

    en_p <= '1';
    en_t <= '0';

    for i in 0 to 5 loop
      assert(output = x"5");
      wait for period;
    end loop;

    en_p <= '0';
    en_t <= '0';

    for i in 0 to 5 loop
      assert(output = x"5");
      wait for period;
    end loop;

    -- Clear should reset everything
    clr <= '0';
    wait for period;
    clr <= '1';
    wait for period;
    assert(output = x"0");

    load <= '0';
    wait for period;
    load <= '1';
    assert(output = x"7");

    en_p <= '1';
    en_t <= '1';

    wait for period;
    assert(output = x"8");
    wait for period;
    assert(output = x"9");

    load <= '0';
    wait for period;
    load <= '1';
    assert(output = x"7");

    -- Check ripple
    assert(ripple_carry_output = '0');
    input <= x"F";
    load <= '0';
    wait for period;
    load <= '1';
    assert(ripple_carry_output = '1');

    -- Turning off en_t should disable ripple_carry
    en_t <= '0';
    wait for period;
    assert(ripple_carry_output = '0');

    stop;
  end process;
end architecture;