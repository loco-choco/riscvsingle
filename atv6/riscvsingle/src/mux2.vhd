library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux2 is
generic(width: integer := 32);
	port(d0, d1: in STD_LOGIC_VECTOR(width - 1 downto 0);
		s: in STD_LOGIC;
		y: out STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture behave of mux2 is
begin
	process(s, d0) begin
		case s is
			when '1' => y <= d1;
			when others => y <= d0;
		end case;
	end process;
end;
