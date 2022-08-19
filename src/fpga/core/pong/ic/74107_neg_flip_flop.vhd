library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic74107 is
  port (
    j : in std_logic;
    k : in std_logic;

    clk_sync : in std_logic;
    clk : in std_logic;
    reset : in std_logic;
    set : in std_logic;

    output : out std_logic := '0'
  );
end entity;

architecture rtl of ic74107 is
  signal clk_int : std_logic;
  signal j_buf : std_logic;
  signal k_buf : std_logic;
  signal output_int : std_logic;
  signal prev_output : std_logic;
begin
  sync : entity work.synchronizer generic map (input_count => 2, rising => false) port map (
    clk_sync => clk_sync,
    clk_orig => clk,

    input => (0 => j, 1 => k),
    output => output_int,

    comb_reset_n => reset and set,

    clk_out => clk_int,
    buffered_input(0) => j_buf,
    buffered_input(1) => k_buf,
    prev_output => prev_output
    );

  process (all)
  begin
    output_int <= prev_output;

    if reset = '0' then
      output_int <= '0';
    elsif set = '0' then
      output_int <= '1';
    elsif clk_int = '1' then
      if j_buf = '1' and k_buf = '0' then
        output_int <= '1';
      elsif j_buf = '0' and k_buf = '1' then
        output_int <= '0';
      elsif j_buf = '1' and k_buf = '1' then
        output_int <= not prev_output;
      end if;
    end if;
  end process;

  output <= output_int;
end architecture;