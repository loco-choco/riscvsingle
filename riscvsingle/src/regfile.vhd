library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.riscv_pkg.all;

entity regfile is
	generic(width : integer := 32);
	port(clk: in STD_LOGIC;
		we3: in STD_LOGIC;
		a1, a2, a3: in STD_LOGIC_VECTOR(4 downto 0);
		wd3: in STD_LOGIC_VECTOR(width - 1 downto 0);
		rd1, rd2: out STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture behave of regfile is
	type ramtype is array (width - 1 downto 0) of STD_LOGIC_VECTOR
											(width - 1 downto 0);
	signal mem: ramtype;
begin
	-- three ported register file
	-- read two ports combinationally (A1/RD1, A2/RD2)
	-- write third port on rising edge of clock (A3/WD3/WE3)
	-- register 0 hardwired to 0
	process(clk) begin
		if rising_edge(clk) then
			if we3 = '1' then mem(to_integer(a3)) <= wd3;
			end if;
		end if;
	end process;
	process(a1, a2) begin
		if (to_integer(a1) = 0) then rd1 <= (others => '0');
		else rd1 <= mem(to_integer(a1));
		end if;
		if (to_integer(a2) = 0) then rd2 <= (others => '0');
		else rd2 <= mem(to_integer(a2));
		end if;
	end process;
end;
