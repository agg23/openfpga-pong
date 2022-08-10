library ieee;
use ieee.std_logic_1164.all;

entity jk_clr_flip_flop is
  port (
    j : in std_logic;
    k : in std_logic;

    clk : in std_logic;
    set : in std_logic;
    clr : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of jk_clr_flip_flop is
begin
  process (clk, set, clr)
  begin
    if clr = '0' then
      output <= '0';
    elsif set = '0' then
      output <= '1';
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