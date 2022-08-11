library ieee;
use ieee.std_logic_1164.all;

entity hsync is
  port (
    clk_7_159 : in std_logic;

    h16 : in std_logic;
    h32 : in std_logic;
    h64 : in std_logic;

    h_reset : in std_logic;

    h_blank : out std_logic;
    h_sync : out std_logic
  );
end entity;

architecture rtl of hsync is
  signal not_h_blank : std_logic;
begin
  -- Count to 64 + 16 = 80 (0x50) to fire h_blank
  H5 : entity work.sr_latch port map (clk => not clk_7_159, s => not (h16 and h64), r => not h_reset, q => not_h_blank);

  h_blank <= not not_h_blank;
  h_sync <= h_blank and h32;
end architecture;