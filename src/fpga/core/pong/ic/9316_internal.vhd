library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic9316_flipflop is
  generic (
    width : integer
  );

  port (
    clk : in std_logic;
    clk_sync : in std_logic;

    data : in std_logic;
    q_prev : in unsigned (width - 2 downto 0);

    clr : in std_logic;

    load : in std_logic;
    en_p : in std_logic;
    en_t : in std_logic;

    output : out std_logic
  );
end entity;

architecture rtl of ic9316_flipflop is
  -- From https://stackoverflow.com/a/20302635
  function and_reduct(vec : in unsigned) return std_logic is
    variable res_v : std_logic := '1'; -- Null vec vector will also return '1'
  begin
    for i in vec'range loop
      res_v := res_v and vec(i);
    end loop;
    return res_v;
  end function;

  signal lpt : std_logic;

  signal j : std_logic;
  signal k : std_logic;
begin
  FF : entity work.ic74107 port map (
    clk => clk,
    clk_sync => clk_sync,

    j => j,
    k => k,

    reset => clr,
    set => '1',

    output => output
    );

  -- not (not load or not en_p or not en_t)
  lpt <= load and en_p and en_t;

  j <= (data and not load) or (lpt and and_reduct(q_prev) and not output);

  k <= (output and and_reduct(q_prev) and lpt) or (not load and not j);
end architecture;