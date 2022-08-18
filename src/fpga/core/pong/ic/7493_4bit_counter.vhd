library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic7493 is
  port (
    clk_sync : in std_logic;

    in_1bit : in std_logic;
    in_3bit : in std_logic;

    r_1 : in std_logic;
    r_2 : in std_logic;

    count : out unsigned (3 downto 0) := x"0"
  );
end entity;

architecture rtl of ic7493 is
  signal reset : std_logic;

  signal q0 : std_logic;
  signal q1 : std_logic;
  signal q2 : std_logic;
  signal q3 : std_logic;
begin
  reset <= not (r_1 and r_2);

  Q0_FF : entity work.ic74107 port map (
    clk_sync => clk_sync,
    clk => in_1bit,
    reset => reset,
    set => '1',
    j => '1',
    k => '1',
    output => q0
    );

  Q1_FF : entity work.ic74107 port map (
    clk_sync => clk_sync,
    clk => in_3bit,
    reset => reset,
    set => '1',
    j => '1',
    k => '1',
    output => q1
    );

  Q2_FF : entity work.ic74107 port map (
    clk_sync => clk_sync,
    clk => q1,
    reset => reset,
    set => '1',
    j => '1',
    k => '1',
    output => q2
    );

  Q3_FF : entity work.ic74107 port map (
    clk_sync => clk_sync,
    clk => q2,
    reset => reset,
    set => '1',
    j => '1',
    k => '1',
    output => q3
    );

  count <= q3 & q2 & q1 & q0;
end architecture;

-- architecture rtl of ic7493 is
--   signal reset : std_logic := '0';

--   signal q0 : std_logic := '0';
--   signal q1 : std_logic := '0';
--   signal q2 : std_logic := '0';
--   signal q3 : std_logic := '0';
-- begin
--   reset <= r_1 and r_2;

--   process (in_1bit, reset)
--   begin
--     if reset = '1' then
--       q0 <= '0';
--     elsif falling_edge(in_1bit) then
--       q0 <= not q0;
--     end if;
--   end process;

--   process (in_3bit, reset)
--   begin
--     if reset = '1' then
--       q1 <= '0';
--     elsif falling_edge(in_3bit) then
--       q1 <= not q1;
--     end if;
--   end process;

--   process (q1, reset)
--   begin
--     if reset = '1' then
--       q2 <= '0';
--     elsif falling_edge(q1) then
--       q2 <= not q2;
--     end if;
--   end process;

--   process (q2, reset)
--   begin
--     if reset = '1' then
--       q3 <= '0';
--     elsif falling_edge(q2) then
--       q3 <= not q3;
--     end if;
--   end process;

--   count <= q3 & q2 & q1 & q0;
-- end architecture;