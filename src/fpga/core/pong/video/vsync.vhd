library ieee;
use ieee.std_logic_1164.all;

entity vsync is
  port (
    clk_7_159 : in std_logic;

    v4 : in std_logic;
    v8 : in std_logic;
    v16 : in std_logic;

    v_reset : in std_logic;

    v_blank : out std_logic;
    v_sync : out std_logic
  );
end entity;

architecture rtl of vsync is
  signal v_blank_int : std_logic;
begin
  F5 : entity work.sr_latch port map (clk => clk_7_159, s => not v_reset, r => not v16, q => v_blank_int);

  v_blank <= v_blank_int;
  v_sync <= v_blank and v4 and not v8;
end architecture;