library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic74153_double is
  port (
    select_a : in std_logic;
    select_b : in std_logic;

    in_a_0 : in std_logic;
    in_a_1 : in std_logic;
    in_a_2 : in std_logic;
    in_a_3 : in std_logic;

    in_b_0 : in std_logic;
    in_b_1 : in std_logic;
    in_b_2 : in std_logic;
    in_b_3 : in std_logic;

    not_enable_a : in std_logic;
    not_enable_b : in std_logic;

    output_a : out std_logic;
    output_b : out std_logic
  );
end entity;

architecture rtl of ic74153_double is

begin
  A : entity work.ic74153 port map (
    select_a => select_a,
    select_b => select_b,

    in_0 => in_a_0,
    in_1 => in_a_1,
    in_2 => in_a_2,
    in_3 => in_a_3,

    not_enable => not_enable_a,

    output => output_a
    );

  B : entity work.ic74153 port map (
    select_a => select_a,
    select_b => select_b,

    in_0 => in_b_0,
    in_1 => in_b_1,
    in_2 => in_b_2,
    in_3 => in_b_3,

    not_enable => not_enable_b,

    output => output_b
    );
end architecture;