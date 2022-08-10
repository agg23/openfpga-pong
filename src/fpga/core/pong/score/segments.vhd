library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_segments is
  port (
    segments : in unsigned (6 downto 0);

    h16 : in std_logic;
    h8 : in std_logic;
    h4 : in std_logic;

    v16 : in std_logic;
    v8 : in std_logic;
    v4 : in std_logic;

    score_video : out std_logic
  );
end entity;

architecture rtl of score_segments is
  signal c3d_out : std_logic;
  signal e5c_out : std_logic;
  signal d2b_out : std_logic;
  signal e5b_out : std_logic;
  signal not_e2a_out : std_logic;

  signal d4a_out : std_logic;
  signal d5c_out : std_logic;
  signal c4c_out : std_logic;
  signal d5a_out : std_logic;
  signal d4c_out : std_logic;
  signal d4b_out : std_logic;
  signal d5b_out : std_logic;
begin
  c3d_out <= not (h4 and h8);

  e5c_out <= h16 and not h4 and not h8;

  d2b_out <= not c3d_out and h16;

  e5b_out <= not v8 and not v4 and h16;

  not_e2a_out <= v4 and v8 and h16;

  --
  d4a_out <= not (not v16 and segments(5) and e5c_out);

  d5c_out <= not (segments(4) and v16 and e5c_out);

  c4c_out <= not (d2b_out and not v16 and segments(1));

  d5a_out <= not (d2b_out and segments(2) and v16);

  d4c_out <= not (segments(0) and not v16 and e5b_out);

  d4b_out <= not (segments(6) and not_e2a_out and not v16);

  d5b_out <= not (not_e2a_out and v16 and segments(3));

  --
  score_video <= not (d4a_out and d5c_out and c4c_out and d5a_out and d4c_out and d4b_out and d5b_out);
end architecture;