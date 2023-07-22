library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
	generic(width : integer := 32);
	port(a, b: in STD_LOGIC_VECTOR(width - 1 downto 0);
			ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
			ALUResult: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
			--Overflow: out STD_LOGIC;
			Zero: out STD_LOGIC);
end;

architecture synth of alu is
	signal S, Bout: STD_LOGIC_VECTOR(width - 1 downto 0);
	constant AllZeros: STD_LOGIC_VECTOR(width - 1 downto 0) := (others => '0');
begin
	Bout <= (not b) when (ALUControl(2) = '1') else b;
	S <= a + Bout + ALUControl(2);

	-- alu function
	process(ALUControl, a, b, S) begin
		case ALUControl(2 downto 0) is
			when "000" => ALUResult <= a + b;
			when "001" => ALUResult <= a - b;
			when "010" => ALUResult <= a and b;
			when "011" => ALUResult <= a or b;
			when "101" => ALUResult <= (0 => S(width - 1),others => '0');
			when others => ALUResult <= (others => '0');
		end case;
	end process;
	Zero <= '1' when (ALUResult = AllZeros) else '0';
	-- overflow circuit
	--process(all) begin
	--	case ALUControl(2 downto 1) is
	--		when "01" => Overflow <=
	--					(a(31) and b(31) and (not (S(31)))) or
	--					((not a(31)) and (not b(31)) and S(31));
	--		when "11" => Overflow <=
	--					((not a(31)) and b(31) and S(31)) or
	--					(a(31) and (not b(31)) and (not S(31)));
	--		when others => Overflow <= '0';
	--	end case;
	--end process;
end;