library ieee;
use ieee.std_logic_1164.all;

entity ic7474 is
  port (
    data : in std_logic;

    clk_sync : in std_logic;
    clk : in std_logic;

    reset : in std_logic;
    clr : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of ic7474 is
  signal clk_int : std_logic;
  signal data_buf : std_logic;
  signal output_int : std_logic;
  signal prev_output : std_logic;
begin
  sync : entity work.synchronizer generic map (input_count => 1) port map (
    clk_sync => clk_sync,
    clk_orig => clk,

    input => (0 => data),
    output => output_int,

    comb_reset_n => reset and clr,

    clk_out => clk_int,
    buffered_input(0) => data_buf,
    prev_output => prev_output
    );

  comb : process (all)
  begin
    output_int <= prev_output;

    if clr = '0' then
      output_int <= '0';
    elsif reset = '0' then
      output_int <= '1';
    elsif clk_int = '1' then
      output_int <= data_buf;
    end if;
  end process;

  output <= output_int;
end architecture;

-- architecture rtl of ic7474_sync is
--   signal data_sync : std_logic;
--   signal output_prev : std_logic;

--   signal internal_clk : std_logic;
--   signal clk_prev : std_logic;
-- begin
--   internal_clk <= clk and not clk_prev;

--   sync : process (clk_sync)
--   begin
--     if rising_edge(clk_sync) then
--       data_sync <= data;
--       output_prev <= output;

--       if clr = '0' or reset = '0' then
--         clk_prev <= '1';
--       else
--         clk_prev <= clk;
--       end if;
--     end if;
--   end process;

--   comb : process (all)
--   begin
--     if clr = '0' then
--       output <= '0';
--     elsif reset = '0' then
--       output <= '1';
--     elsif internal_clk = '0' then
--       output <= output_prev;
--     else
--       output <= data_sync;
--     end if;
--   end process;
-- end architecture;