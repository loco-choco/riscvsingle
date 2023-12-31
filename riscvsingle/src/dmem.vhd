library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity dmem is
	generic(width: integer := 32);
	port(clk, we: in STD_LOGIC;
		a, wd: in STD_LOGIC_VECTOR(width - 1 downto 0);
		rd: out STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture behave of dmem is
begin
	process is
		type ramtype is array (width * 2 - 1 downto 0) of
		STD_LOGIC_VECTOR(width - 1 downto 0);
		variable mem: ramtype;
	begin
		-- read or write memory
		loop
		if rising_edge(clk) then
			if (we = '1') then mem(to_integer(a(7 downto 2))) := wd;
			end if;
		end if;
		rd <= mem(to_integer(a(7 downto 2)));
		wait on clk, a;
		end loop;
	end process;
end;
