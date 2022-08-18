library ieee;
use ieee.std_logic_1164.all;

entity net is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    v_blank : in std_logic;

    v4 : in std_logic;
    h256 : in std_logic;

    net : out std_logic
  );
end entity;

architecture rtl of net is
  signal f3b_out : std_logic;

begin
  F3b : entity work.ic74107 port map (
    clk => not clk_7_159,
    clk_sync => clk_sync,

    j => h256,
    k => not h256,
    reset => '1',
    set => '1',
    output => f3b_out
    );

  net <= not v_blank and not v4 and (h256 and not f3b_out);
end architecture;