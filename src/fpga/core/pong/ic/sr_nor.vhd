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
  signal output_int : std_logic := '0';
  signal prev_output : std_logic := '0';
begin
  process (clk_sync)
  begin
    if rising_edge(clk_sync) then
      if s = '1' and r = '0' then
        output_int <= '0';
      elsif s = '0' and r = '1' then
        output_int <= '1';
      end if;
    end if;
  end process;

  output <= output_int;
end architecture;