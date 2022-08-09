library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic7483_no_carry is
  port (
    a : in unsigned (3 downto 0);
    b : in unsigned (3 downto 0);

    sum : out unsigned (3 downto 0)
  );
end entity;

architecture rtl of ic7483_no_carry is
begin
  sum <= a + b;
end architecture;