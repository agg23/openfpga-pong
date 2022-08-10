library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video is
  port (
    clk_7_159 : in std_logic;

    pad_1 : in std_logic;
    pad_2 : in std_logic;

    h_ball_video : in std_logic;
    v_ball_video : in std_logic;

    score_video : in std_logic;

    h_sync : out std_logic;
    h_blank : out std_logic;
    h_reset : out std_logic;

    v_sync : out std_logic;
    v_blank : out std_logic;
    v_reset : out std_logic;

    h_count : out unsigned (8 downto 0);
    v_count : out unsigned (8 downto 0);

    hit : out std_logic;
    hit_1 : out std_logic;
    hit_2 : out std_logic;

    mono_video_out : out unsigned (7 downto 0)
  );
end entity;

architecture rtl of video is
  signal h_count_int : unsigned (8 downto 0);
  signal h_blank_int : std_logic;
  signal h_reset_int : std_logic;

  signal v_count_int : unsigned (8 downto 0);
  signal v_blank_int : std_logic;
  signal v_reset_int : std_logic;

  signal net : std_logic;

  -- Ball video
  signal combined_ball_g1b_out : std_logic;

  -- Generated video
  signal combined_sync : std_logic;
  signal combined_pads_net_ball : std_logic;

  signal video : unsigned (7 downto 0);
begin
  HCOUNTER : entity work.hcounter port map (clk_7_159 => clk_7_159, h_reset => h_reset_int, h_count => h_count_int);
  VCOUNTER : entity work.vcounter port map (h_reset_clk => h_reset_int, v_reset => v_reset_int, v_count => v_count_int);

  HSYNC : entity work.hsync port map (
    clk_7_159 => clk_7_159,

    h16 => h_count_int(4),
    h32 => h_count_int(5),
    h64 => h_count_int(6),

    h_reset => h_reset_int,
    h_blank => h_blank_int,
    h_sync => h_sync
    );

  VSYNC : entity work.vsync port map (
    clk_7_159 => clk_7_159,

    v4 => v_count_int(2),
    v8 => v_count_int(3),
    v16 => v_count_int(4),

    v_reset => v_reset_int,
    v_blank => v_blank_int,
    v_sync => v_sync
    );

  NET_GEN : entity work.net port map (
    clk_7_159 => clk_7_159,

    v_blank => v_blank_int,

    v4 => v_count_int(2),
    h256 => h_count_int(8),

    net => net
    );

  combined_ball_g1b_out <= h_ball_video and v_ball_video;

  hit_1 <= pad_1 and combined_ball_g1b_out;
  hit_2 <= pad_2 and combined_ball_g1b_out;

  hit <= hit_1 or hit_2;

  -- Unused in output
  -- combined_sync <= not ((not hsync) xor (not vsync));
  combined_pads_net_ball <= pad_1 or pad_2 or net or combined_ball_g1b_out;

  mono_video_out <= video;

  h_blank <= h_blank_int;
  h_count <= h_count_int;
  h_reset <= h_reset_int;
  v_blank <= v_blank_int;
  v_count <= v_count_int;
  v_reset <= v_reset_int;

  process (h_blank_int, v_blank_int, combined_pads_net_ball, score_video)
  begin
    if h_blank_int = '1' or v_blank_int = '1' then
      video <= x"00";
    elsif score_video = '1' then
      -- TODO: Find right color
      video <= x"BB";
    elsif combined_pads_net_ball = '1' then
      -- TODO: Find right color
      video <= x"FF";
    else
      video <= x"55";
    end if;
  end process;
end architecture;