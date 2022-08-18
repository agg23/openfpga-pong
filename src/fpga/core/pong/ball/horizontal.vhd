library ieee;
use ieee.std_logic_1164.all;

entity ball_horizontal is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    v_reset : in std_logic;
    h_blank : in std_logic;

    h256 : in std_logic;

    hit_1 : in std_logic;
    hit_2 : in std_logic;

    attract : in std_logic;
    serve : in std_logic;

    reset_speed : in std_logic;

    hit_sound : in std_logic;
    score_sound : in std_logic;

    ball_left : out std_logic;
    ball_right : out std_logic;

    -- The output signal for when in the horizontal scan to display the ball
    h_ball_video : out std_logic
  );
end entity;

architecture rtl of ball_horizontal is
  signal move : std_logic;

  signal aa : std_logic;
  signal ba : std_logic;
begin
  BALL_MOVE : entity work.ball_move port map (
    clk_sync => clk_sync,

    v_reset => v_reset,
    h256 => h256,
    reset_speed => reset_speed,
    hit_sound => hit_sound,

    move => move
    );

  BALL_AB : entity work.ball_horizontal_direction port map (
    clk_sync => clk_sync,

    move => move,

    hit_1 => hit_1,
    hit_2 => hit_2,

    score_sound => score_sound,
    attract => attract,

    out_aa => aa,
    out_ba => ba,

    ball_left => ball_left,
    ball_right => ball_right
    );

  BALL_POSITION : entity work.ball_horizontal_position port map (
    clk_7_159 => clk_7_159,
    clk_sync => clk_sync,

    aa => aa,
    ba => ba,

    h_blank => h_blank,

    attract => attract,
    serve => serve,

    h_ball_video => h_ball_video
    );
end architecture;