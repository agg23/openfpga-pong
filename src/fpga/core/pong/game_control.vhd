library ieee;
use ieee.std_logic_1164.all;

entity game_control is
  port (
    clk_7_159 : in std_logic;
    clk_sync : in std_logic;

    pad_1 : in std_logic;

    miss : in std_logic;
    coin_insert : in std_logic;
    stop_game : in std_logic;

    -- Added for prevent_coin_reset setting
    running : out std_logic;

    attract : out std_logic;
    serve : out std_logic;

    reset_speed : out std_logic
  );
end entity;

architecture rtl of game_control is
  signal e6b_out : std_logic;
  signal timer_f4_out : std_logic;

  signal e5a_out : std_logic;
  signal b5b_out : std_logic;

  signal running_int : std_logic := '0';
  signal coin_insert_prev : std_logic;
  signal stop_game_prev : std_logic;
begin
  F4 : entity work.ic555 generic map (duration_ms => 1700) port map (
    clk_7_159 => clk_7_159,

    not_trigger => not e6b_out,

    output => timer_f4_out
    );

  B5b : entity work.ic7474 port map (
    data => e5a_out,

    clk_sync => clk_sync,
    clk => pad_1,

    reset => '1',
    clr => e5a_out,

    output => b5b_out
    );

  e6b_out <= coin_insert or miss;

  e5a_out <= running_int and not stop_game and not timer_f4_out;

  attract <= stop_game or not running_int;
  serve <= not b5b_out;
  reset_speed <= e6b_out;

  running <= running_int;

  -- Logic taken from https://github.com/MiSTer-devel/Arcade-Pong_MiSTer/blob/master/rtl/game_control.v
  process (clk_7_159)
  begin
    if rising_edge(clk_7_159) then
      if coin_insert_prev = '0' and coin_insert = '1' then
        -- New coin inserted
        running_int <= '1';
      elsif stop_game_prev = '0' and stop_game = '1' then
        -- Game ending
        running_int <= '0';
      end if;

      coin_insert_prev <= coin_insert;
      stop_game_prev <= stop_game;
    end if;
  end process;
end architecture;