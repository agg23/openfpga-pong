library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sound is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    attract : in std_logic;
    serve : in std_logic;

    hit : in std_logic;
    miss : in std_logic;

    v_blank : in std_logic;
    v_ball_video : in std_logic;
    v_ball240 : in std_logic;
    v_ball32 : in std_logic;
    v_ball16 : in std_logic;

    v32 : in std_logic;

    hit_sound : out std_logic;
    -- Labeled SC
    score_sound : out std_logic;
    sound_out : out std_logic
  );
end entity;

architecture rtl of sound is
  signal f3a_out : std_logic;
  signal c2a_out : std_logic;

  signal c3a_out : std_logic;
  signal c3b_out : std_logic;
  signal c3c_out : std_logic;

  signal c4b_out : std_logic;

  signal timer_g4_out : std_logic;
begin
  F3a : entity work.ic74107 port map (
    j => v_ball_video,
    k => not v_ball_video,

    clk => v_blank,
    clk_sync => clk_sync,
    reset => not serve,
    set => '1',

    output => f3a_out
    );

  C2a : entity work.ic7474 port map (
    data => '1',

    clk => v_ball240,
    clk_sync => clk_sync,

    reset => '1',
    clr => not hit,

    output => c2a_out
    );

  G4_TIMER : entity work.ic555 generic map (duration_ms => 240) port map (
    clk_7_159 => clk_7_159,

    not_trigger => not miss,

    output => timer_g4_out
    );

  c3b_out <= not (v_ball32 and f3a_out);

  c3a_out <= not (not c2a_out and v_ball16);

  c3c_out <= not (v32 and timer_g4_out);

  c4b_out <= not (c3b_out and c3a_out and c3c_out);

  sound_out <= not (not attract and c4b_out);
  hit_sound <= not c2a_out;
  score_sound <= timer_g4_out;
end architecture;