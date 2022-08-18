library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
  generic (
    input_count : natural;
    rising : boolean := true);
  port (
    clk_sync : in std_logic;
    clk_orig : in std_logic;

    -- The original inputs from the synced component
    input : in std_logic_vector(input_count - 1 downto 0);
    -- The original output from the synced component
    output : in std_logic;

    -- All possible async reset signals combined, neg triggered
    comb_reset_n : in std_logic;

    clk_out : out std_logic;
    buffered_input : out std_logic_vector(input_count - 1 downto 0);
    prev_output : out std_logic := '0'
  );
end entity;

architecture rtl of synchronizer is
  signal prev_clk : std_logic;
begin
  process (clk_orig, prev_clk)
  begin
    if rising then
      clk_out <= clk_orig and not prev_clk;
    else
      clk_out <= not clk_orig and prev_clk;
    end if;
  end process;

  clk_buffer : process (clk_sync)
  begin
    if rising_edge(clk_sync) then
      buffered_input <= input;

      prev_output <= output;

      if comb_reset_n = '0' then
        if rising then
          -- Force prev_clock high so internal_clk is low
          prev_clk <= '1';
        else
          prev_clk <= '0';
        end if;
      else
        prev_clk <= clk_orig;
      end if;
    end if;
  end process;
end architecture;