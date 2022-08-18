library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_horizontal_position is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    aa : in std_logic;
    ba : in std_logic;

    h_blank : in std_logic;

    attract : in std_logic;
    serve : in std_logic;

    h_ball_video : out std_logic
  );
end entity;

architecture rtl of ball_horizontal_position is
  signal g7_out : unsigned (3 downto 0);
  signal g7_ripple_carry : std_logic;

  signal h7_ripple_carry : std_logic;

  signal reset_e1b_out : std_logic;

  signal load_g5c_out : std_logic;

  signal g6b_out : std_logic;
begin
  G7 : entity work.ic9316 port map (
    clk => clk_7_159,
    clk_sync => clk_sync,

    clr => reset_e1b_out,

    load => load_g5c_out,
    en_p => '1',
    en_t => not h_blank,

    input => b"10" & ba & aa,

    output => g7_out,
    ripple_carry_output => g7_ripple_carry
    );

  H7 : entity work.ic9316 port map (
    clk => clk_7_159,
    clk_sync => clk_sync,

    clr => reset_e1b_out,

    load => load_g5c_out,
    en_p => g7_ripple_carry,
    en_t => '1',

    input => b"1000",

    output => open,
    ripple_carry_output => h7_ripple_carry
    );

  G6b : entity work.ic74107 port map (
    j => '1',
    k => '1',

    clk => h7_ripple_carry,
    clk_sync => clk_sync,
    reset => reset_e1b_out,
    set => '1',

    output => g6b_out
    );

  reset_e1b_out <= not (not attract and serve);

  load_g5c_out <= not (h7_ripple_carry and g7_ripple_carry and g6b_out);

  h_ball_video <= g7_out(3) and g7_out(2) and h7_ripple_carry and g6b_out;
end architecture;