library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pong is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    p1_up : in std_logic;
    p1_down : in std_logic;
    p2_up : in std_logic;
    p2_down : in std_logic;

    coin_insert : in std_logic;

    -- Configuration
    -- This is configurable via a dip switch. When low, the game will end when the score = 11, when high, it will end at 15
    score_stop_at_15 : in std_logic;

    -- This isn't functionality in the standard arcade. Many people added this functionality though
    double_paddle_height : in std_logic;

    training_mode : in std_logic;

    video_de : out std_logic;
    video_vs : out std_logic;
    video_hs : out std_logic;
    video_rgb : out unsigned (23 downto 0);

    sound : out std_logic
  );
end entity;

architecture rtl of pong is
  signal h_sync : std_logic;
  signal h_blank : std_logic;

  signal v_sync : std_logic;
  signal v_blank : std_logic;
  signal v_reset : std_logic;

  signal h_count : unsigned (8 downto 0);
  signal v_count : unsigned (8 downto 0);

  signal hit : std_logic;
  signal hit_1 : std_logic;
  signal hit_2 : std_logic;

  signal h_ball_video : std_logic;
  signal v_ball_video : std_logic;

  signal score_video : std_logic;

  signal attract : std_logic;
  signal serve : std_logic;
  signal reset_speed : std_logic;
  signal miss : std_logic;
  signal stop_game : std_logic;

  signal hit_sound : std_logic;
  signal score_sound : std_logic;

  signal ball_left : std_logic;
  signal ball_right : std_logic;

  signal input_count : unsigned (13 downto 0) := 14d"0";
  signal paddle_pos_1 : unsigned (7 downto 0) := 8d"128";
  signal paddle_pos_2 : unsigned (7 downto 0) := 8d"128";
  signal pad_1 : std_logic;
  signal pad_2 : std_logic;

  signal paddle_b_1 : std_logic;
  signal paddle_b_2 : std_logic;
  signal paddle_c_1 : std_logic;
  signal paddle_c_2 : std_logic;
  signal paddle_d_1 : std_logic;
  signal paddle_d_2 : std_logic;

  signal v_ball16 : std_logic;
  signal v_ball32 : std_logic;
  signal v_ball240 : std_logic;

  signal mono_video_out : unsigned (7 downto 0);
begin
  VIDEO_GEN : entity work.video port map (
    clk_7_159 => clk_7_159,
    clk_sync => clk_sync,

    pad_1 => pad_1,
    pad_2 => pad_2,

    h_ball_video => h_ball_video,
    v_ball_video => v_ball_video,

    score_video => score_video,

    h_sync => h_sync,
    h_blank => h_blank,
    h_count => h_count,
    v_sync => v_sync,
    v_blank => v_blank,
    v_reset => v_reset,
    v_count => v_count,

    hit => hit,
    hit_1 => hit_1,
    hit_2 => hit_2,

    mono_video_out => mono_video_out
    );

  PAD1 : entity work.paddle port map (
    clk_sync => clk_sync,

    paddle_pos => paddle_pos_1,

    h_sync => h_sync,

    v256 => v_count(8),
    h256 => h_count(8),
    h128 => h_count(7),
    h4 => h_count(2),

    attract => attract,
    double_paddle_height => double_paddle_height,

    paddle_b => paddle_b_1,
    paddle_c => paddle_c_1,
    paddle_d => paddle_d_1,

    pad => pad_1
    );

  PAD2 : entity work.paddle port map (
    clk_sync => clk_sync,

    paddle_pos => paddle_pos_2,

    h_sync => h_sync,

    v256 => v_count(8),
    -- Only difference from pad1, intentionally inverted
    h256 => not h_count(8),
    h128 => h_count(7),
    h4 => h_count(2),

    attract => attract,
    double_paddle_height => double_paddle_height,
    training_mode => training_mode,

    paddle_b => paddle_b_2,
    paddle_c => paddle_c_2,
    paddle_d => paddle_d_2,

    pad => pad_2
    );

  SCORE : entity work.score port map (
    clk_sync => clk_sync,

    h_ball_video => h_ball_video,
    h_blank => h_blank,

    attract => attract,
    coin_insert => coin_insert,
    ball_left => ball_left,
    ball_right => ball_right,

    score_stop_at_15 => score_stop_at_15,

    h256 => h_count(8),
    h128 => h_count(7),
    h64 => h_count(6),
    h32 => h_count(5),
    h16 => h_count(4),
    h8 => h_count(3),
    h4 => h_count(2),

    v128 => v_count(7),
    v64 => v_count(6),
    v32 => v_count(5),
    v16 => v_count(4),
    v8 => v_count(3),
    v4 => v_count(2),

    miss => miss,
    stop_game => stop_game,

    score_video => score_video
    );

  BALL_HORIZONTAL : entity work.ball_horizontal port map (
    clk_7_159 => clk_7_159,
    clk_sync => clk_sync,

    v_reset => v_reset,
    h_blank => h_blank,

    h256 => h_count(8),

    hit_1 => hit_1,
    hit_2 => hit_2,

    attract => attract,
    serve => serve,

    reset_speed => reset_speed,

    hit_sound => hit_sound,
    score_sound => score_sound,

    ball_left => ball_left,
    ball_right => ball_right,

    h_ball_video => h_ball_video
    );

  BALL_VERTICAL : entity work.ball_vertical port map (
    clk_sync => clk_sync,

    v_blank => v_blank,
    h_sync => h_sync,
    h256 => h_count(8),

    hit => hit,
    attract => attract,

    paddle_b_1 => paddle_b_1,
    paddle_b_2 => paddle_b_2,
    paddle_c_1 => paddle_c_1,
    paddle_c_2 => paddle_c_2,
    paddle_d_1 => paddle_d_1,
    paddle_d_2 => paddle_d_2,

    v_ball240 => v_ball240,
    v_ball32 => v_ball32,
    v_ball16 => v_ball16,

    v_ball_video => v_ball_video
    );

  SOUND_GEN : entity work.sound port map (
    clk_7_159 => clk_7_159,
    clk_sync => clk_sync,

    attract => attract,
    serve => serve,

    hit => hit,
    miss => miss,

    v_blank => v_blank,
    v_ball_video => v_ball_video,
    v_ball240 => v_ball240,
    v_ball32 => v_ball32,
    v_ball16 => v_ball16,

    v32 => v_count(5),

    hit_sound => hit_sound,
    score_sound => score_sound,

    sound_out => sound
    );

  CONTROL : entity work.game_control port map (
    clk_7_159 => clk_7_159,
    clk_sync => clk_sync,

    pad_1 => pad_1,

    miss => miss,
    coin_insert => coin_insert,
    stop_game => stop_game,

    attract => attract,
    serve => serve,

    reset_speed => reset_speed
    );

  video_de <= (not h_blank) and (not v_blank);
  video_vs <= v_sync;
  video_hs <= h_sync;
  video_rgb <= mono_video_out & mono_video_out & mono_video_out;

  -- Controllers
  process (clk_7_159)
  begin
    if rising_edge(clk_7_159) then
      if input_count = 0 then
        input_count <= b"11" & 12x"CCC";

        if p1_up = '1' then
          if paddle_pos_1 > 1 then
            paddle_pos_1 <= paddle_pos_1 - 1;
          end if;
        elsif p1_down = '1' then
          if paddle_pos_1 < 255 then
            paddle_pos_1 <= paddle_pos_1 + 1;
          end if;
        end if;

        if p2_up = '1' then
          if paddle_pos_2 > 1 then
            paddle_pos_2 <= paddle_pos_2 - 1;
          end if;
        elsif p2_down = '1' then
          if paddle_pos_2 < 255 then
            paddle_pos_2 <= paddle_pos_2 + 1;
          end if;
        end if;
      end if;

      input_count <= input_count - 1;
    end if;
  end process;
end architecture;