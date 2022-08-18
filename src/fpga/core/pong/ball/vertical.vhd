library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_vertical is
  port (
    clk_sync : in std_logic;

    v_blank : in std_logic;
    h_sync : in std_logic;
    h256 : in std_logic;

    hit : in std_logic;
    attract : in std_logic;

    paddle_b_1 : in std_logic;
    paddle_b_2 : in std_logic;
    paddle_c_1 : in std_logic;
    paddle_c_2 : in std_logic;
    paddle_d_1 : in std_logic;
    paddle_d_2 : in std_logic;

    v_ball240 : out std_logic;
    v_ball32 : out std_logic;
    v_ball16 : out std_logic;

    v_ball_video : out std_logic
  );
end entity;

architecture rtl of ball_vertical is
  signal a2a_out : std_logic;

  signal b5a_out : std_logic;
  signal a5a_out : std_logic;
  signal a5b_out : std_logic;

  signal b6a_out : std_logic;

  signal b4_sum : unsigned (3 downto 0);
  signal b3_out : unsigned (3 downto 0);
  signal b3_ripple_carry : std_logic;

  signal a3_out : unsigned (3 downto 0);
  signal a3_ripple_carry : std_logic;

  signal b2b_out : std_logic;

  signal v_ball_video_int : std_logic;
begin
  A2a : entity work.ic74107 port map (
    j => v_ball_video_int,
    k => v_ball_video_int,
    clk => v_blank,
    clk_sync => clk_sync,
    reset => not hit,
    set => '1',
    output => a2a_out
    );

  B5a : entity work.ic7474 port map (
    data => not ((paddle_d_1 and not h256) or (paddle_d_2 and h256)),
    clk => hit,
    clk_sync => clk_sync,
    reset => '1',
    clr => not attract,
    output => b5a_out
    );

  A5a : entity work.ic7474 port map (
    data => not ((paddle_c_1 and not h256) or (paddle_c_2 and h256)),
    clk => hit,
    clk_sync => clk_sync,
    reset => '1',
    clr => not attract,
    output => a5a_out
    );

  A5b : entity work.ic7474 port map (
    data => not ((paddle_b_1 and not h256) or (paddle_b_2 and h256)),
    clk => hit,
    clk_sync => clk_sync,
    reset => '1',
    clr => not attract,
    output => a5b_out
    );

  b6a_out <= not ((a2a_out and b5a_out) or (not a2a_out and not b5a_out));

  B4 : entity work.ic7483_no_carry port map (
    a => '0' & b6a_out & (a2a_out xor a5a_out) & (a2a_out xor a5b_out),
    b => b"011" & not b6a_out,
    sum => b4_sum
    );

  B3 : entity work.ic9316 port map (
    clk => not h_sync,
    clk_sync => clk_sync,
    clr => '1',

    load => b2b_out,
    en_p => '1',
    en_t => not v_blank,

    input => b4_sum,

    output => b3_out,
    ripple_carry_output => b3_ripple_carry
    );

  A3 : entity work.ic9316 port map (
    clk => not h_sync,
    clk_sync => clk_sync,
    clr => '1',

    load => b2b_out,
    en_p => b3_ripple_carry,
    en_t => '1',

    input => x"0",

    output => a3_out,
    ripple_carry_output => a3_ripple_carry
    );

  v_ball16 <= a3_out(0);
  v_ball32 <= a3_out(1);
  v_ball240 <= a3_ripple_carry;

  b2b_out <= not (a3_ripple_carry and b3_ripple_carry);

  v_ball_video_int <= v_ball240 and b3_out(3) and b3_out(2);
  v_ball_video <= v_ball_video_int;
end architecture;