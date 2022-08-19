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