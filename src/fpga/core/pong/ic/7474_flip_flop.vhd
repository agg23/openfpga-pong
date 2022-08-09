library ieee;
use ieee.std_logic_1164.all;

entity ic7474 is
  port (
    data : in std_logic;

    clk : in std_logic;

    reset : in std_logic;
    clr : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic7474 is
begin
  process (clk, reset, clr)
  begin
    if falling_edge(clr) then
      output <= '0';
    elsif falling_edge(reset) then
      output <= '1';
    elsif rising_edge(clk) then
      output <= data;
    end if;
  end process;
end architecture;