library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.riscv_pkg.all;

entity adder is
	generic(width: integer := 32);
	port(a, b: in STD_LOGIC_VECTOR(width - 1 downto 0);
		y: out STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture behave of adder is
begin
	y <= a + b;
end;
