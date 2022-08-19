library ieee;
use ieee.std_logic_1164.all;

entity vsync is
  port (
    clk_sync : in std_logic;

    v4 : in std_logic;
    v8 : in std_logic;
    v16 : in std_logic;

    v_reset : in std_logic;

    v_blank : out std_logic;
    v_sync : out std_logic
  );
end entity;

architecture rtl of vsync is
  signal not_v_blank : std_logic;
begin
  F5 : entity work.sr_nor_sync port map (clk_sync => clk_sync, s => v_reset, r => v16, output => not_v_blank);

  v_blank <= not not_v_blank;
  v_sync <= v_blank and v4 and not v8;
end architecture;