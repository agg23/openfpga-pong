library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic7490 is
  port (
    clk_1bit : in std_logic;
    clk_3bit : in std_logic;

    r0_1 : in std_logic;
    r0_2 : in std_logic;
    r9_1 : in std_logic;
    r9_2 : in std_logic;

    output : out unsigned (3 downto 0)
  );
end entity;

architecture rtl of ic7490 is
  signal r0 : std_logic;
  signal r9 : std_logic;
  signal clr : std_logic;

  signal q_a : std_logic;
  signal q_b : std_logic;
  signal q_c : std_logic;
  signal q_d : std_logic;
begin
  A : entity work.jk_clr_flip_flop port map (
    j => '1',
    k => '1',

    clk => clk_1bit,
    set => r9,
    clr => r0,

    output => q_a
    );

  B : entity work.jk_clr_flip_flop port map (
    j => not q_d,
    k => '1',

    clk => clk_3bit,
    set => '1',
    clr => clr,

    output => q_b
    );

  C : entity work.jk_clr_flip_flop port map (
    j => '1',
    k => '1',

    clk => q_b,
    set => '1',
    clr => clr,

    output => q_c
    );

  D : entity work.jk_clr_flip_flop port map (
    j => q_c and q_b,
    k => q_d,

    clk => clk_3bit,
    set => r9,
    clr => r0,

    output => q_d
    );

  r0 <= not (r0_1 and r0_2);
  r9 <= not (r9_1 and r9_2);
  clr <= not ((not r0) or (not r9));

  output <= q_d & q_c & q_b & q_a;
end architecture;