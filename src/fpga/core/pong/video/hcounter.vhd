library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity hcounter is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    h_reset : out std_logic := '0';
    h_count : out unsigned (8 downto 0)
  );
end entity;

architecture rtl of hcounter is
  signal count : unsigned (8 downto 0) := 9b"0";
  signal f8_count : unsigned (3 downto 0);
  signal f9_count : unsigned (3 downto 0);

  signal h256 : std_logic;

  signal count_454 : std_logic;
  signal not_h_reset : std_logic;
  signal h_reset_int : std_logic;
begin
  E7b : entity work.ic7474 port map(
    clk => clk_7_159,
    clk_sync => clk_sync,

    data => not count_454,
    reset => '1',
    clr => '1',
    output => not_h_reset
    );

  F6b : entity work.ic74107 port map (
    clk => f9_count(3),
    clk_sync => clk_sync,

    j => '1',
    k => '1',

    reset => not h_reset_int,
    set => '1',
    output => h256
    );

  -- F8 4 bit counter feeds into F9 4 bit counter to produce an 8 bit counter. This counts to 454
  F8 : entity work.ic7493 port map (
    clk_sync => clk_sync,

    in_1bit => clk_7_159,
    in_3bit => f8_count(0),

    r_1 => h_reset_int,
    r_2 => h_reset_int,

    count => f8_count
    );

  F9 : entity work.ic7493 port map (
    clk_sync => clk_sync,

    in_1bit => f8_count(3),
    in_3bit => f9_count(0),

    r_1 => h_reset_int,
    r_2 => h_reset_int,

    count => f9_count
    );

  -- 2 + 4 + 64 + 128 + 256 = 454 -> 0x6 in F8, 0xC in F9
  count_454 <= f8_count(1) and f8_count(2) and f9_count(2) and f9_count(3) and h256;

  h_reset_int <= not not_h_reset;
  h_reset <= h_reset_int;

  h_count <= h256 & f9_count & f8_count;
end architecture;