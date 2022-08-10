library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_bcd is
  port (
    s1 : in unsigned (4 downto 0);
    s2 : in unsigned (4 downto 0);

    h256 : in std_logic;
    h128 : in std_logic;
    h64 : in std_logic;
    h32 : in std_logic;
    h16 : in std_logic;
    h8 : in std_logic;
    h4 : in std_logic;

    v128 : in std_logic;
    v64 : in std_logic;
    v32 : in std_logic;
    v16 : in std_logic;
    v8 : in std_logic;
    v4 : in std_logic;

    segments : out unsigned (6 downto 0)
  );
end entity;

architecture rtl of score_bcd is
  signal c6_y1 : std_logic;
  signal c6_y2 : std_logic;

  signal d6_y1 : std_logic;
  signal d6_y2 : std_logic;

  signal e3b_out : std_logic;
  signal e2c_out : std_logic;

  signal d2c_out : std_logic;
  signal f2a_out : std_logic;
begin
  C6 : entity work.ic74153_double port map (
    select_a => h32,
    select_b => h64,

    in_a_0 => '1',
    in_a_1 => s1(0),
    in_a_2 => '1',
    in_a_3 => s2(0),

    in_b_0 => not s1(4),
    in_b_1 => s1(1),
    in_b_2 => not s2(4),
    in_b_3 => s2(1),

    not_enable_a => '0',
    not_enable_b => '0',

    output_a => c6_y1,
    output_b => c6_y2
    );

  D6 : entity work.ic74153_double port map (
    select_a => h32,
    select_b => h64,

    in_a_0 => not s1(4),
    in_a_1 => s1(2),
    in_a_2 => not s2(4),
    in_a_3 => s2(2),

    in_b_0 => not s1(4),
    in_b_1 => s1(3),
    in_b_2 => not s2(4),
    in_b_3 => s2(3),

    not_enable_a => '0',
    not_enable_b => '0',

    output_a => d6_y1,
    output_b => d6_y2
    );

  e3b_out <= not h256 and not h64 and h128;
  e2c_out <= not (not h128 and h64 and h256);

  d2c_out <= not e3b_out and e2c_out;
  f2a_out <= v32 and not v64 and not v128 and not d2c_out;

  C5 : entity work.ic7448 port map (input => d6_y2 & d6_y1 & c6_y2 & c6_y1, not_blanking => f2a_out, output => segments);
end architecture;