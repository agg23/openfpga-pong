library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity hcounter is
  port (
    clk_7_159 : in std_logic;

    h_reset : out std_logic := '0';
    h_count : out unsigned (8 downto 0)
  );
end entity;

architecture rtl of hcounter is
  signal count : unsigned (8 downto 0) := 9b"0";
  -- signal f9_clk : std_logic;

  -- signal f8_carry : std_logic;
  -- signal f9_carry : std_logic;

  -- signal f8_count : unsigned (3 downto 0);
  -- signal f9_count : unsigned (3 downto 0);

  -- signal f6_out : std_logic;

  -- signal count_454 : std_logic;
  -- signal not_h_internal_reset : std_logic;
begin
  -- E7b : entity work.ic7474 port map (data => not count_454, clk => clk, reset => '1', output => not_h_internal_reset);

  -- F6b : entity work.ic74107_single port map (j => '1', k => '1', clk => f9_count(3), reset => not h_reset, output => f6_out);

  -- -- F8 4 bit counter feeds into F9 4 bit counter to produce an 8 bit counter. This counts to 454
  -- F8 : entity work.ic7493 port map (in_1bit => clk, in_3bit => f8_carry, r_1 => h_reset, r_2 => h_reset, count => f8_count);
  -- F9 : entity work.ic7493 port map (in_1bit => f9_clk, in_3bit => f9_carry, r_1 => h_reset, r_2 => h_reset, count => f9_count);

  -- f8_carry <= f8_count(0);
  -- f9_clk <= f8_count(3);

  -- f9_carry <= f9_count(0);

  -- -- 2 + 4 + 64 + 128 + 256 = 454 -> 0x6 in F8, 0xC in F9
  -- count_454 <= f8_count(1) and f8_count(2) and f9_count(2) and f9_count(3) and f6_out;

  -- h_reset <= not not_h_internal_reset;

  h_count <= count;

  process (clk_7_159, h_reset)
  begin
    if h_reset then
      count <= 9b"0";
    elsif falling_edge(clk_7_159) then
      count <= count + 1;
    end if;
  end process;

  process (clk_7_159)
  begin
    if rising_edge(clk_7_159) then
      if count = 454 then
        h_reset <= '1';
      else
        h_reset <= '0';
      end if;
    end if;
  end process;
end architecture;