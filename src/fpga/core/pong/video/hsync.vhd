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
  -- Clocked on the falling edge of the main (not sync) clock to ensure the timing for the horizontal ball period lines up correctly
  -- not_h_blank _must_ rise after clk_7_159 when 0x50 is counted, such that it goes high shortly before 0x51. Missing this timing messes up the horizontal ball period
  H5 : entity work.sr_nand_sync port map (clk_sync => not clk_7_159, s_not => not (h16 and h64), r_not => not h_reset, output => not_h_blank);

  h_blank <= not not_h_blank;
  h_sync <= h_blank and h32;
end architecture;