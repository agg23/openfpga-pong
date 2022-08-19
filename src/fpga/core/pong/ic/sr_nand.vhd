library ieee;
use ieee.std_logic_1164.all;

entity sr_nand_sync is
  port (
    clk_sync : in std_logic;

    s_not : in std_logic;
    r_not : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of sr_nand_sync is
  signal output_int : std_logic := '0';
  signal prev_output : std_logic := '0';
begin
  process (clk_sync)
  begin
    if rising_edge(clk_sync) then
      if s_not = '0' and r_not = '1' then
        output_int <= '1';
      elsif s_not = '1' and r_not = '0' then
        output_int <= '0';
      end if;

    end if;
  end process;

  output <= output_int;
end architecture;