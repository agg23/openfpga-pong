library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vcounter is
  port (
    clk_sync : in std_logic;
    h_reset : in std_logic;

    v_reset : out std_logic := '0';
    v_count : out unsigned (8 downto 0)
  );
end entity;

architecture rtl of vcounter is
  -- signal count : unsigned (8 downto 0) := 9b"0";
  signal e8_count : unsigned (3 downto 0);
  signal e9_count : unsigned (3 downto 0);

  signal v256 : std_logic;

  signal not_v_reset : std_logic;
  signal v_reset_int : std_logic;
begin
  E8 : entity work.ic7493 port map (
    clk_sync => clk_sync,

    in_1bit => h_reset,
    in_3bit => e8_count(0),

    r_1 => v_reset_int,
    r_2 => v_reset_int,

    count => e8_count
    );

  E9 : entity work.ic7493 port map (
    clk_sync => clk_sync,

    in_1bit => e8_count(3),
    in_3bit => e9_count(0),

    r_1 => v_reset_int,
    r_2 => v_reset_int,

    count => e9_count
    );

  D9b : entity work.ic74107 port map (
    clk_sync => clk_sync,
    clk => e9_count(3),

    j => '1',
    k => '1',

    reset => not_v_reset,
    set => '1',

    output => v256
    );

  E7a : entity work.ic7474 port map (
    clk_sync => clk_sync,
    clk => h_reset,

    data => not (v256 and e8_count(0) and e8_count(2)),

    reset => '1',
    clr => '1',

    output => not_v_reset
    );

  v_count <= v256 & e9_count & e8_count;
  v_reset_int <= not not_v_reset;
  v_reset <= v_reset_int;

  -- v_count <= count;

  -- process (h_reset_clk)
  -- begin
  --   if v_reset then
  --     count <= 9b"0";
  --   elsif falling_edge(h_reset_clk) then
  --     count <= count + 1;
  --   end if;
  -- end process;

  -- process (h_reset_clk)
  -- begin
  --   if rising_edge(h_reset_clk) then
  --     if count = 261 then
  --       v_reset <= '1';
  --     else
  --       v_reset <= '0';
  --     end if;
  --   end if;
  -- end process;
end architecture;