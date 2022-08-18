library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score is
  port (
    clk_sync : in std_logic;

    h_ball_video : in std_logic;
    h_blank : in std_logic;

    attract : in std_logic;
    -- Listed as SRST
    coin_insert : in std_logic;
    ball_left : in std_logic;
    ball_right : in std_logic;

    score_stop_at_15 : in std_logic;

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

    miss : out std_logic;
    stop_game : out std_logic;

    score_video : out std_logic
  );
end entity;

architecture rtl of score is
  signal s1 : unsigned (4 downto 0);
  signal s2 : unsigned (4 downto 0);

  signal segments : unsigned (6 downto 0);
begin
  COUNTER : entity work.score_counter port map (
    clk_sync => clk_sync,

    h_ball_video => h_ball_video,
    h_blank => h_blank,

    attract => attract,
    coin_insert => coin_insert,
    ball_left => ball_left,
    ball_right => ball_right,

    score_stop_at_15 => score_stop_at_15,

    miss => miss,
    stop_game => stop_game,
    s1_out => s1,
    s2_out => s2
    );

  BCD : entity work.score_bcd port map (
    s1 => s1,
    s2 => s2,

    h256 => h256,
    h128 => h128,
    h64 => h64,
    h32 => h32,
    h16 => h16,
    h8 => h8,
    h4 => h4,

    v128 => v128,
    v64 => v64,
    v32 => v32,
    v16 => v16,
    v8 => v8,
    v4 => v4,

    segments => segments
    );

  SEG : entity work.score_segments port map (
    segments => segments,

    h16 => h16,
    h8 => h8,
    h4 => h4,

    v16 => v16,
    v8 => v8,
    v4 => v4,

    score_video => score_video
    );
end architecture;