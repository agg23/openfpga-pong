library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity paddle is
  port (
    clk_sync : in std_logic;

    paddle_pos : in unsigned (7 downto 0);

    h_sync : in std_logic;

    v256 : in std_logic;
    h256 : in std_logic;
    h128 : in std_logic;
    h4 : in std_logic;

    attract : in std_logic;

    paddle_b : out std_logic;
    paddle_c : out std_logic;
    paddle_d : out std_logic;

    pad : out std_logic
  );
end entity;

architecture rtl of paddle is
  signal trigger_555 : std_logic := '0';
  signal count_555 : unsigned (8 downto 0) := 9b"0";

  signal b8_count : unsigned (3 downto 0);

  signal a7b_out : std_logic;
  signal v_pad : std_logic;

  signal not_h3a_out : std_logic;
  signal not_g3c_out : std_logic;
begin
  -- When reset (by the 555 triggering), count to 15 lines (triggered from h_sync).
  B8 : entity work.ic7493 port map (
    clk_sync => clk_sync,

    in_1bit => not (not h_sync and a7b_out),
    in_3bit => b8_count(0),

    r_1 => trigger_555,
    r_2 => trigger_555,

    count => b8_count
    );

  -- process (a7b_out)
  -- begin
  --   report "a7b changed 0x" & to_hstring(b8_count) & " value " & std_logic'image(not (not h_sync and a7b_out));
  -- end process;

  -- Position the paddle on the left/right of the screen, with a width of 4 pixels
  H3A : entity work.ic7474 port map (data => h128, clk => h4, clk_sync => clk_sync, reset => not attract, clr => '1', output => not_h3a_out);

  -- Synchronous variant of a7b. Without clocking the output, a7b will immediately clock B8 on b8_count reaching 15
  process (clk_sync)
  begin
    if rising_edge(clk_sync) then
      a7b_out <= not (b8_count(0) and b8_count(1) and b8_count(2) and b8_count(3));
    end if;
  end process;

  paddle_b <= b8_count(1);
  paddle_c <= b8_count(2);
  paddle_d <= b8_count(3);

  -- 555 timer uses potentiometer (radial controller) to send trigger pulses at a given rate.
  -- This is combined with a 4 bit counter to count to 15, which is the the height of the paddle.
  -- When 15 lines have been counted, v_pad goes low (~v_pad in the schematics) and PAD1/2 goes low
  v_pad <= not trigger_555 and a7b_out;

  not_g3c_out <= h128 and not not_h3a_out;

  pad <= v_pad and not h256 and not_g3c_out;

  -- Timing logic copied from https://github.com/MiSTer-devel/Arcade-Pong_MiSTer/blob/master/rtl/paddle.v
  process (h_sync)
    variable v : unsigned (8 downto 0);
  begin
    if rising_edge(h_sync) then
      if count_555 > 0 then
        count_555 <= count_555 - 1;

        if count_555 = 1 then
          trigger_555 <= '0';
        end if;
      elsif count_555 = 0 and v256 = '1' then
        -- 261 max timing - 256 = 5
        -- 16 v_blank lines
        -- 5 + 16 = 21 total lines
        v := ('0' & paddle_pos) + 21;

        if v < 38 then
          -- Prevent paddle from going off top of screen
          count_555 <= 9d"38";
        elsif v > 261 then
          -- Prevent paddle from going off bottom of screen
          count_555 <= 9d"261";
        else
          count_555 <= v;
        end if;

        trigger_555 <= '1';
      end if;
    end if;
  end process;
end architecture;