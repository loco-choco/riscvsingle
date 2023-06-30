library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity extend is
	port(instr: in STD_LOGIC_VECTOR(31 downto 7);
		immsrc: in STD_LOGIC_VECTOR(1 downto 0);
		immext: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of extend is

	alias instrStart: STD_LOGIC is instr(31);
	alias IinstrEnd: STD_LOGIC_VECTOR(31 downto 20) is instr(31 downto 20);

	alias SinstrMiddle: STD_LOGIC_VECTOR(31 downto 25) is instr(31 downto 25);
	alias SinstrEnd: STD_LOGIC_VECTOR(11 downto 7) is instr(11 downto 7);

	alias BinstrMiddle1: STD_LOGIC is instr(7);
	alias BinstrMiddle2: STD_LOGIC_VECTOR(30 downto 25) is instr(30 downto 25);
	alias BinstrMiddle3: STD_LOGIC_VECTOR(11 downto 8) is instr(11 downto 8);

	alias JinstrMiddle1: STD_LOGIC_VECTOR(19 downto 12) is instr(19 downto 12);
	alias JinstrMiddle2: STD_LOGIC is instr(20);
	alias JinstrMiddle3: STD_LOGIC_VECTOR(30 downto 21) is instr(30 downto 21);
begin
	process(instr, immsrc) begin
		case immsrc is
			-- I-type
			when "00" =>
				immext <= (31 downto 12 => instrStart) & IinstrEnd;
			-- S-types (stores)
			when "01" =>
				immext <= (31 downto 12 => instrStart) & SinstrMiddle & SinstrEnd;
			-- B-type (branches)
			when "10" =>
				immext <= (31 downto 12 => instrStart) & BinstrMiddle1 & BinstrMiddle2 & BinstrMiddle3 & '0';
			-- J-type (jal)
			when "11" =>
				immext <= (31 downto 20 => instrStart) & JinstrMiddle1 & JinstrMiddle2 & JinstrMiddle3 & '0';
			when others =>
				immext <= (31 downto 0 => '-');
		end case;
	end process;
end;
