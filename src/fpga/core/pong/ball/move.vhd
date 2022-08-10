library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_move is
  port (
    v_reset : in std_logic;
    h256 : in std_logic;

    reset_speed : in std_logic;

    hit_sound : in std_logic;

    move : out std_logic
  );
end entity;

architecture rtl of ball_move is
  signal e1c_out : std_logic;
  signal h1a_out : std_logic;
  signal h1d_out : std_logic;

  signal g1c_out : std_logic;
  signal h1b_out : std_logic;
  signal h1c_out : std_logic;

  signal f1_count : unsigned (3 downto 0);

  signal h2a_out : std_logic;
  signal h2b_out : std_logic;

  signal move_int : std_logic;
begin
  F1 : entity work.ic7493 port map (
    in_1bit => not (hit_sound and e1c_out),
    in_3bit => f1_count(0),

    r_1 => reset_speed,
    r_2 => reset_speed,

    count => f1_count);

  H2b : entity work.ic74107_single port map (clk => g1c_out, j => '1', k => move_int, reset => h1c_out, output => h2b_out);
  H2a : entity work.ic74107_single port map (clk => g1c_out, j => h2b_out, k => '0', reset => h1b_out, output => h2a_out);

  e1c_out <= not (f1_count(2) and f1_count(3));
  -- not (not (count(2) or count(3)))
  h1a_out <= f1_count(2) or f1_count(3);
  h1d_out <= not (e1c_out and h1a_out);

  g1c_out <= not (not h256 or v_reset);
  h1b_out <= not (v_reset and h1a_out);
  h1c_out <= not (v_reset and h1d_out);

  -- H4a
  move_int <= not (h2a_out and h2b_out);
  move <= move_int;
end architecture;