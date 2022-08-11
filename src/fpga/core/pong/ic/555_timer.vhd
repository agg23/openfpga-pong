library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic555 is
  generic (duration_ms : natural);
  port (
    clk_7_159 : in std_logic;

    not_trigger : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic555 is
  signal counter : unsigned (31 downto 0) := x"00000000";

  constant timeout : unsigned (31 downto 0) := to_unsigned(7_159_000 / 1000 * duration_ms, 32);
begin
  process (clk_7_159)
  begin
    if rising_edge(clk_7_159) then
      if counter > 0 then
        counter <= counter - 1;

        if counter = 1 then
          output <= '0';
        end if;
      elsif counter = 0 and not_trigger = '0' then
        counter <= timeout;
        output <= '1';
      end if;
    end if;
  end process;
end architecture;