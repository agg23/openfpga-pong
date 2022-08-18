library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic9316 is
  port (
    clk : in std_logic;
    clk_sync : in std_logic;
    clr : in std_logic;

    load : in std_logic;
    en_p : in std_logic;
    en_t : in std_logic;

    input : in unsigned (3 downto 0);

    output : out unsigned (3 downto 0);
    ripple_carry_output : out std_logic
  );
end entity;

architecture rtl of ic9316 is
begin
  A_FF : entity work.ic9316_flipflop generic map(width => 1) port map (
    clk => not clk,
    clk_sync => clk_sync,

    data => input(0),
    q_prev => "",

    clr => clr,

    load => load,
    en_p => en_p,
    en_t => en_t,

    output => output(0)
    );

  B_FF : entity work.ic9316_flipflop generic map(width => 2) port map(
    clk => not clk,
    clk_sync => clk_sync,

    data => input(1),
    q_prev => "" & output(0),

    clr => clr,

    load => load,
    en_p => en_p,
    en_t => en_t,

    output => output(1)
    );

  C_FF : entity work.ic9316_flipflop generic map(width => 3) port map(
    clk => not clk,
    clk_sync => clk_sync,

    data => input(2),
    q_prev => output(1) & output(0),

    clr => clr,

    load => load,
    en_p => en_p,
    en_t => en_t,

    output => output(2)
    );

  D_FF : entity work.ic9316_flipflop generic map(width => 4) port map(
    clk => not clk,
    clk_sync => clk_sync,

    data => input(3),
    q_prev => output(2) & output(1) & output(0),

    clr => clr,

    load => load,
    en_p => en_p,
    en_t => en_t,

    output => output(3)
    );

  -- NOR to AND
  ripple_carry_output <= en_t and output(0) and output(1) and output(2) and output(3);
end architecture;