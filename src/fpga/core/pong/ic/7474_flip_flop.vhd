library ieee;
use ieee.std_logic_1164.all;

entity ic7474_old is
  port (
    data : in std_logic;

    clk : in std_logic;

    reset : in std_logic;
    clr : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic7474_old is
begin
  process (clk, reset, clr)
  begin
    if clr = '0' then
      output <= '0';
    elsif reset = '0' then
      output <= '1';
    elsif rising_edge(clk) then
      output <= data;
    end if;
  end process;
end architecture;