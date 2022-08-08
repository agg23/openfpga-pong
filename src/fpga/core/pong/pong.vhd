library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pong is
  port (
    clk_7_159 : in std_logic;

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

  signal v_sync : std_logic;
  signal v_blank : std_logic;

  signal mono_video_out : unsigned (7 downto 0);
begin
  VIDEO_GEN : entity work.video port map (
    clk_7_159 => clk_7_159,

    h_sync => h_sync,
    h_blank => h_blank,
    v_sync => v_sync,
    v_blank => v_blank,

    mono_video_out => mono_video_out
    );

  video_de <= (not h_blank) and (not v_blank);
  video_vs <= v_sync;
  video_hs <= h_sync;
  video_rgb <= mono_video_out & mono_video_out & mono_video_out;
  -- video_rgb <= x"52a832";
end architecture;