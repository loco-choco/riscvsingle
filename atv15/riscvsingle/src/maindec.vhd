library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity maindec is
	port(op: in STD_LOGIC_VECTOR(6 downto 0);
		ResultSrc: out STD_LOGIC_VECTOR(1 downto 0);
		MemWrite: out STD_LOGIC;
		Branch, BNE, ALUSrc: out STD_LOGIC;
		RegWrite, Jump: out STD_LOGIC;
		ImmSrc: out STD_LOGIC_VECTOR(1 downto 0);
		ALUOp: out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(11 downto 0);
begin
	process(op) begin
		case op is
			when "0000011" => controls <= "100100100000"; -- lw
			when "0100011" => controls <= "001110000000"; -- sw
			when "0110011" => controls <= "1--000000100"; -- R-type
			when "1100011" => controls <= "010000010010"; -- beq
			when "1100001" => controls <= "010000011010"; -- bne
			-- Para implementarmos essa instrucao, iremos adicionar
			-- mais uma porta de controle, o qual ira negar a saida 
			-- Zero da alu se ativada, ou seja, ira fazer: BNE xor Zero
			when "0010011" => controls <= "100100000100"; -- I-type ALU
			when "1101111" => controls <= "111001000001"; -- jal
			when others    => controls <= "------------"; -- not valid
		end case;
	end process;
	
	(RegWrite, ImmSrc(1), ImmSrc(0), ALUSrc, MemWrite,
	ResultSrc(1), ResultSrc(0), Branch, BNE, ALUOp(1), ALUOp(0),
	Jump) <= controls;
end;