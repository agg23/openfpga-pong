library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic7474 is
  port (
    data : in std_logic;

    clk : in std_logic;
    reset : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic7474 is
begin
  process (clk, reset)
  begin
    if reset = '0' then
      output <= '0';
    elsif rising_edge(clk) then
      output <= data;
    end if;
  end process;
end architecture;