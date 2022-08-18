library ieee;
use ieee.std_logic_1164.all;

entity sr_nor_sync is
  port (
    clk_sync : in std_logic;

    s : in std_logic;
    r : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of sr_nor_sync is
  signal s_buf : std_logic := '0';
  signal r_buf : std_logic := '0';

  signal output_int : std_logic := '0';
  signal prev_output : std_logic := '0';
begin
  process (clk_sync)
  begin
    if rising_edge(clk_sync) then
      prev_output <= output_int;

      s_buf <= s;
      r_buf <= r;
    end if;
  end process;

  process (s_buf, r_buf, prev_output)
  begin
    output_int <= prev_output;

    if s_buf = '1' and r_buf = '0' then
      output_int <= '0';
    elsif s_buf = '0' and r_buf = '1' then
      output_int <= '1';
    end if;
  end process;

  output <= output_int;
end architecture;