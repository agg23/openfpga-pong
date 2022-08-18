library ieee;
use ieee.std_logic_1164.all;

entity sr_sync is
  port (
    clk : in std_logic;
    clk_sync : in std_logic;

    s : in std_logic;
    r : in std_logic;

    clr : in std_logic;
    set : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of sr_sync is
  signal clk_int : std_logic;
  signal s_buf : std_logic;
  signal r_buf : std_logic;
  signal output_int : std_logic;
  signal prev_output : std_logic;
begin

  SYNC : entity work.synchronizer generic map (input_count => 2, rising => false) port map (
    clk_sync => clk_sync,
    clk_orig => clk,

    input => (0 => s, 1 => r),
    output => output_int,

    comb_reset_n => clr and set,

    clk_out => clk_int,
    buffered_input(0) => s_buf,
    buffered_input(1) => r_buf,
    prev_output => prev_output
    );

  process (clr, set, clk_int, s_buf, r_buf)
  begin
    output_int <= prev_output;

    if clr = '0' then
      output_int <= '0';
    elsif set = '0' then
      output_int <= '1';
    elsif clk_int = '1' then
      if s_buf = '0' and r_buf = '1' then
        output_int <= '0';
      elsif s_buf = '1' and r_buf = '0' then
        output_int <= '1';
      end if;
    end if;
  end process;

  output <= output_int;
end architecture;