library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
use ieee.std_logic_textio.all;

entity imem is
	generic(width: integer := 32);
	port(a: in STD_LOGIC_VECTOR(width - 1 downto 0);
		rd: out STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture behave of imem is
	type ramtype is array (width * 2 - 1 downto 0) of
				STD_LOGIC_VECTOR(width - 1 downto 0);
	-- initialize memory from file
	impure function init_ram_hex return ramtype is
		file text_file : text open read_mode is "riscvtest.txt";
		variable text_line : line;
		variable ram_content : ramtype;
		variable i : integer := 0;
		begin
		for i in 0 to width * 2 - 1 loop -- set all contents low
			ram_content(i) := (others => '0');
		end loop;
		while not endfile(text_file) loop -- set contents from file
			readline(text_file, text_line);
			hread(text_line, ram_content(i));
			i := i + 1;
		end loop;
		
		return ram_content;
	end function;
	
	signal mem : ramtype := init_ram_hex;
	begin
	-- read memory
	process(a) begin
		rd <= mem(to_integer(a(width - 1 downto 2)));
	end process;
end;
