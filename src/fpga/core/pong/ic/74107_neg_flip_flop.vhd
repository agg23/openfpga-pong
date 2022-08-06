library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic74107_single is
  port (
    j : in std_logic;
    k : in std_logic;

    clk : in std_logic;
    reset : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic74107_single is
begin
  process (clk, reset)
  begin
    if reset = '0' then
      output <= '0';
    elsif falling_edge(clk) then
      if j = '1' and k = '0' then
        output <= '1';
      elsif j = '0' and k = '1' then
        output <= '0';
      elsif j = '1' and k = '1' then
        output <= not output;
      end if;
    end if;
  end process;
end architecture;