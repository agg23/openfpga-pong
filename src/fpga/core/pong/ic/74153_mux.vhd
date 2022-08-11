library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic74153 is
  port (
    select_a : in std_logic;
    select_b : in std_logic;

    in_0 : in std_logic;
    in_1 : in std_logic;
    in_2 : in std_logic;
    in_3 : in std_logic;

    not_enable : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of ic74153 is
begin
  process (select_a, select_b, not_enable)
    variable selector : unsigned (1 downto 0);
  begin
    if not_enable = '1' then
      output <= '0';
    else
      selector := select_b & select_a;

      case selector is
        when b"00" => output <= in_0;
        when b"01" => output <= in_1;
        when b"10" => output <= in_2;
        when b"11" => output <= in_3;
        when others => null;
      end case;
    end if;
  end process;
end architecture;