library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pong is
  port (
    clk_7_159 : in std_logic;

    p1_up : in std_logic;
    p1_down : in std_logic;
    p2_up : in std_logic;
    p2_down : in std_logic;

    start_button : std_logic;

    video_de : out std_logic;
    -- TODO: Remove
    video_vs : out std_logic;
    video_hs : out std_logic;
    video_rgb : out unsigned (23 downto 0)
  );
end entity;

architecture rtl of pong is
  signal h_sync : std_logic;
  signal h_blank : std_logic;
  signal h_reset : std_logic;

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

  -- TODO: Implement
  signal attract : std_logic := '0';
  signal serve : std_logic;
  signal reset_speed : std_logic := '1';

  signal hit_sound : std_logic := '0';
  signal score_sound : std_logic := '0';

  signal input_count : unsigned (12 downto 0) := 13d"0";
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

    pad_1 => pad_1,
    pad_2 => pad_2,

    h_ball_video => h_ball_video,
    v_ball_video => v_ball_video,

    h_sync => h_sync,
    h_blank => h_blank,
    h_reset => h_reset,
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
    paddle_pos => paddle_pos_1,

    h_sync => h_sync,

    v256 => v_count(8),
    h256 => h_count(8),
    h128 => h_count(7),
    h4 => h_count(2),

    paddle_b => paddle_b_1,
    paddle_c => paddle_c_1,
    paddle_d => paddle_d_1,

    pad => pad_1
    );

  PAD2 : entity work.paddle port map (
    paddle_pos => paddle_pos_2,

    h_sync => h_sync,

    v256 => v_count(8),
    -- Only difference from pad1, intentionally inverted
    h256 => not h_count(8),
    h128 => h_count(7),
    h4 => h_count(2),

    paddle_b => paddle_b_2,
    paddle_c => paddle_c_2,
    paddle_d => paddle_d_2,

    pad => pad_2
    );

  BALL_HORIZONTAL : entity work.ball_horizontal port map (
    clk_7_159 => clk_7_159,

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

    h_ball_video => h_ball_video
    );

  BALL_VERTICAL : entity work.ball_vertical port map (
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

    v_ball16 => v_ball16,
    v_ball32 => v_ball32,
    v_ball240 => v_ball240,

    v_ball_video => v_ball_video
    );

  -- TODO: Remove
  serve <= start_button;

  video_de <= (not h_blank) and (not v_blank);
  video_vs <= v_sync;
  video_hs <= h_sync;
  video_rgb <= mono_video_out & mono_video_out & mono_video_out;

  -- Controllers
  process (clk_7_159)
  begin
    if rising_edge(clk_7_159) then
      if input_count = 0 then
        input_count <= '1' & 12x"AAA";

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