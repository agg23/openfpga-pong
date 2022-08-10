library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ic7448 is
  port (
    input : in unsigned (3 downto 0);

    not_blanking : in std_logic;

    output : out unsigned (6 downto 0)
  );
end entity;

architecture rtl of ic7448 is

begin
  process (input, not_blanking)
  begin
    if not_blanking = '1' then
      case input is
        when x"0" => output <= b"1111110";
        when x"1" => output <= b"0110000";
        when x"2" => output <= b"1101101";
        when x"3" => output <= b"1111001";
        when x"4" => output <= b"0110011";
        when x"5" => output <= b"1011011";
        when x"6" => output <= b"0011111";
        when x"7" => output <= b"1110000";
        when x"8" => output <= b"1111111";
        when x"9" => output <= b"1110011";
          -- This isn't correct, but I want it to properly indicate that something went wrong
          -- so we'll display "C"
        when others => output <= b"1001110";
      end case;
    end if;
  end process;
end architecture;