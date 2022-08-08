library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video is
  port (
    clk_7_159 : in std_logic;

    pad_1 : in std_logic;
    pad_2 : in std_logic;

    h_sync : out std_logic;
    h_blank : out std_logic;

    v_sync : out std_logic;
    v_blank : out std_logic;

    h_count : out unsigned (8 downto 0);
    v_count : out unsigned (8 downto 0);

    mono_video_out : out unsigned (7 downto 0)
  );
end entity;

architecture rtl of video is
  signal h_reset : std_logic;
  signal h_count_int : unsigned (8 downto 0);
  signal h_blank_int : std_logic;
  -- signal h_sync : std_logic;

  signal v_reset : std_logic;
  signal v_count_int : unsigned (8 downto 0);
  signal v_blank_int : std_logic;
  -- signal v_sync : std_logic;

  signal net : std_logic;

  -- Generated video
  signal combined_sync : std_logic;
  signal combined_pads_net : std_logic;

  signal video : unsigned (7 downto 0);
begin
  HCOUNTER : entity work.hcounter port map (clk_7_159 => clk_7_159, h_reset => h_reset, h_count => h_count_int);
  VCOUNTER : entity work.vcounter port map (h_reset_clk => h_reset, v_reset => v_reset, v_count => v_count_int);

  HSYNC : entity work.hsync port map (
    clk_7_159 => clk_7_159,

    h16 => h_count_int(4),
    h32 => h_count_int(5),
    h64 => h_count_int(6),

    h_reset => h_reset,
    h_blank => h_blank_int,
    h_sync => h_sync
    );

  VSYNC : entity work.vsync port map (
    clk_7_159 => clk_7_159,

    v4 => v_count_int(2),
    v8 => v_count_int(3),
    v16 => v_count_int(4),

    v_reset => v_reset,
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

  -- Unused in output
  -- combined_sync <= not ((not hsync) xor (not vsync));

  combined_pads_net <= pad_1 or pad_2 or net;

  mono_video_out <= video;

  h_blank <= h_blank_int;
  h_count <= h_count_int;
  v_blank <= v_blank_int;
  v_count <= v_count_int;

  process (h_blank_int, h_blank_int, combined_pads_net)
  begin
    if h_blank_int = '1' or h_blank_int = '1' then
      video <= x"00";
    elsif combined_pads_net = '1' then
      video <= x"FF";
    else
      video <= x"00";
    end if;
  end process;
end architecture;