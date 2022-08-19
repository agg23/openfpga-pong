library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_counter is
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

    miss : out std_logic;
    stop_game : out std_logic;
    s1_out : out unsigned (4 downto 0);
    s2_out : out unsigned (4 downto 0)
  );
end entity;

architecture rtl of score_counter is
  signal e6c_out : std_logic;
  signal e1a_out : std_logic;

  signal c7_out : unsigned (3 downto 0);
  signal c8a_out : std_logic;

  signal d7_out : unsigned (3 downto 0);
  signal c8b_out : std_logic;
begin
  -- Check if ball is colliding with one of the edges (the h_blank period)
  e6c_out <= not (h_ball_video and h_blank);
  miss <= not e6c_out;

  e1a_out <= not (not e6c_out and not attract);

  -- Count points on collision with the left side
  C7 : entity work.ic7490 port map (
    clk_sync => clk_sync,

    clk_1bit => not e1a_out and not ball_left,
    clk_3bit => c7_out(0),

    r0_1 => coin_insert,
    r0_2 => coin_insert,
    r9_1 => '0',
    r9_2 => '0',

    output => c7_out
    );

  C8a : entity work.ic74107 port map (
    j => '1',
    k => '1',

    clk => c7_out(3),
    clk_sync => clk_sync,

    reset => not coin_insert,
    set => '1',
    output => c8a_out
    );

  -- Count points on collision with the right side
  D7 : entity work.ic7490 port map (
    clk_sync => clk_sync,

    clk_1bit => not e1a_out and not ball_right,
    clk_3bit => d7_out(0),

    r0_1 => coin_insert,
    r0_2 => coin_insert,
    r9_1 => '0',
    r9_2 => '0',

    output => d7_out
    );

  C8b : entity work.ic74107 port map (
    j => '1',
    k => '1',

    clk => d7_out(3),
    clk_sync => clk_sync,

    reset => not coin_insert,
    set => '1',
    output => c8b_out
    );

  s1_out <= c8a_out & c7_out;
  s2_out <= c8b_out & d7_out;

  -- Synchronous variant of stop_game NAND. Without clocking the output, a large comb. loop is formed
  process (clk_sync)
    variable s1_met_score : std_logic;
    variable s2_met_score : std_logic;
  begin
    if rising_edge(clk_sync) then
      if score_stop_at_15 = '1' then
        -- 10 + 4 + 1 = 15
        s1_met_score := not (s1_out(0) and s1_out(2) and s1_out(4));
        s2_met_score := not (s2_out(0) and s2_out(2) and s2_out(4));
      else
        -- 10 + 1 = 11
        s1_met_score := not (s1_out(0) and s1_out(4));
        s2_met_score := not (s2_out(0) and s2_out(4));
      end if;

      stop_game <= not (s1_met_score and s2_met_score);
    end if;
  end process;
end architecture;