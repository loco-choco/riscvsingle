library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use WORK.riscv_pkg.all;

entity datapath is
	generic(width : integer := 32);
	port(clk, reset: in STD_LOGIC;
		ResultSrc: in STD_LOGIC_VECTOR(1 downto 0);
		PCSrc, ALUSrc: in STD_LOGIC;
		RegWrite: in STD_LOGIC;
		ImmSrc: in STD_LOGIC_VECTOR(1 downto 0);
		ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
		Zero: out STD_LOGIC;
		PC: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
		Instr: in STD_LOGIC_VECTOR(width - 1 downto 0);
		ALUResult, WriteData: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
		ReadData: in STD_LOGIC_VECTOR(width - 1 downto 0));
end;

architecture struct of datapath is
	component flopr generic(width: integer);
		port(clk, reset: in STD_LOGIC;
				d: in STD_LOGIC_VECTOR(width-1 downto 0);
				q: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	component adder generic(width: integer);
		port(a, b: in STD_LOGIC_VECTOR(width - 1 downto 0);
				y: out STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	component mux2 generic(width: integer);
		port(d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
				s: in STD_LOGIC;
				y: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	component mux3 generic(width: integer);
		port(d0, d1, d2: in STD_LOGIC_VECTOR(width-1 downto 0);
				s: in STD_LOGIC_VECTOR(1 downto 0);
				y: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	component regfile generic(width: integer);
		port(clk: in STD_LOGIC;
				we3: in STD_LOGIC;
				a1, a2, a3: in STD_LOGIC_VECTOR(4 downto 0);
				wd3: in STD_LOGIC_VECTOR(width - 1 downto 0);
				rd1, rd2: out STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	component extend
		port(instr: in STD_LOGIC_VECTOR(width - 1 downto 7);
				immsrc: in STD_LOGIC_VECTOR(1 downto 0);
				immext: out STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	component alu generic(width: integer);
		port(a, b: in STD_LOGIC_VECTOR(width - 1 downto 0);
				ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
				ALUResult: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
				Zero: out STD_LOGIC);
	end component;
	
	signal PCNext, PCPlus4, PCTarget: STD_LOGIC_VECTOR(width - 1 downto 0);
	signal ImmExt: STD_LOGIC_VECTOR(width - 1 downto 0);
	signal SrcA, SrcB: STD_LOGIC_VECTOR(width - 1 downto 0);
	signal Result: STD_LOGIC_VECTOR(width - 1 downto 0);
begin
	-- next PC logic
	pcreg: flopr generic map(width) port map(clk, reset, PCNext, PC);
	pcadd4: adder generic map(width) port map(PC, (3 => '1', others => '0'), PCPlus4);
	pcaddbranch: adder generic map(width) port map(PC, ImmExt, PCTarget);
	pcmux: mux2 generic map(width) port map(PCPlus4, PCTarget, PCSrc,
											PCNext);
	-- register file logic
	rf: regfile generic map(width) port map(clk, RegWrite, Instr(19 downto 15),
	Instr(24 downto 20), Instr(11 downto 7),
								Result, SrcA, WriteData);
	ext: extend port map(Instr(width - 1 downto 7), ImmSrc, ImmExt);
	-- ALU logic
	srcbmux: mux2 generic map(width) port map(WriteData, ImmExt,
											ALUSrc, SrcB);
	mainalu: alu generic map(width) port map(SrcA, SrcB, ALUControl, ALUResult, Zero);
	resultmux: mux3 generic map(width) port map(ALUResult, ReadData,
												PCPlus4, ResultSrc,
												Result);
end;
