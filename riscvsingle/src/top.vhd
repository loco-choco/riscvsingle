library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
use WORK.riscv_pkg.all;
entity top is
	generic(width: integer := 32);
	port(clk, reset: in STD_LOGIC;
		WriteData, DataAdr: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
		MemWrite: buffer STD_LOGIC);
end;

architecture test of top is
	component riscvsingle	generic(width: integer);
		port(clk, reset: in STD_LOGIC;
			PC: out STD_LOGIC_VECTOR(width - 1 downto 0);
			Instr: in STD_LOGIC_VECTOR(width - 1 downto 0);
			MemWrite: out STD_LOGIC;
			ALUResult, WriteData: out STD_LOGIC_VECTOR(width - 1 downto 0);
			ReadData: in STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	component imem generic(width: integer);
		port(a: in STD_LOGIC_VECTOR(width - 1 downto 0);
			rd: out STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	component dmem generic(width: integer);
		port(clk, we: in STD_LOGIC;
			a, wd: in STD_LOGIC_VECTOR(width - 1 downto 0);
			rd: out STD_LOGIC_VECTOR(width - 1 downto 0));
	end component;
	
	signal PC, Instr, ReadData: STD_LOGIC_VECTOR(width - 1 downto 0);
begin
	-- instantiate processor and memories
	rvsingle: riscvsingle generic map(width) port map( clk, reset, PC, Instr,
									MemWrite, DataAdr,
									WriteData, ReadData);
	imem1: imem generic map(width) port map(PC, Instr);
	dmem1: dmem generic map(width) port map(clk, MemWrite, DataAdr, WriteData,
	ReadData);
end;
