library ieee;
use ieee.std_logic_1164.all;

entity ball_horizontal_direction is
  port (
    clk_sync : in std_logic;

    move : in std_logic;

    hit_1 : in std_logic;
    hit_2 : in std_logic;

    attract : in std_logic;
    score_sound : in std_logic;

    -- Values to feed into G7 and H7 ball period counter
    -- When aa: 0, ba: 1, period will be 374
    -- When aa: 1, ba: 1, period will be 373 (move ball left)
    -- When aa: 1, ba: 0, period will be 375 (move ball right)
    out_aa : out std_logic;
    out_ba : out std_logic;

    ball_left : out std_logic;
    ball_right : out std_logic
  );
end entity;

architecture rtl of ball_horizontal_direction is
  signal ball_left_int : std_logic;
  signal ball_right_int : std_logic;
begin
  H3b : entity work.ic7474 port map (
    -- not (not (score and attract))
    clk => score_sound and attract,
    clk_sync => clk_sync,

    reset => not hit_2,
    clr => not hit_1,

    data => ball_right_int,
    output => ball_left_int);

  ball_right_int <= not ball_left_int;

  -- H4b
  out_ba <= not (ball_right_int and move);
  -- H4d
  out_aa <= not (out_ba and not (ball_left_int and move));

  ball_left <= ball_left_int;
  ball_right <= ball_right_int;
end architecture;