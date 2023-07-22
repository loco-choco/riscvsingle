library IEEE;
use IEEE.STD_LOGIC_1164.all;
package riscv_pkg is
  constant RISCV_Data_Width: integer := 32;
--components
  component alu 
    generic(width: integer := RISCV_Data_Width);
    port(a, b: in STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
			ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
			ALUResult: buffer STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
			Zero: out STD_LOGIC);
  end component;
  component extend port(instr: in STD_LOGIC_VECTOR(31 downto 7);
		immsrc: in STD_LOGIC_VECTOR(1 downto 0);
		immext: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component regfile 
	generic(width: integer := RISCV_Data_Width);
	port(clk: in STD_LOGIC;
		we3: in STD_LOGIC;
		a1, a2, a3: in STD_LOGIC_VECTOR(4 downto 0);
		wd3: in STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		rd1, rd2: out STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0));
  end component;
  component mux3 
	generic(width: integer := RISCV_Data_Width);
	port(d0, d1, d2: in STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0);
		s: in STD_LOGIC_VECTOR(1 downto 0);
		y: out STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0));
  end component;
  component mux2 
	generic(width: integer := RISCV_Data_Width);
	port(d0, d1: in STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0);
		s: in STD_LOGIC;
		y: out STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0));
  end component;
  component adder 
	generic(width:integer := RISCV_Data_Width);
	port(a, b: in STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		y: out STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0));
  end component;
  component flopr
	generic(width: integer := RISCV_Data_Width);
	port(clk, reset: in STD_LOGIC;
		d: in STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0);
		q: out STD_LOGIC_VECTOR(RISCV_Data_Width-1 downto 0));
  end component;
  component datapath
	generic(width:integer := RISCV_Data_Width);
	port(clk, reset: in STD_LOGIC;
		ResultSrc: in STD_LOGIC_VECTOR(1 downto 0);
		PCSrc, ALUSrc: in STD_LOGIC;
		RegWrite: in STD_LOGIC;
		ImmSrc: in STD_LOGIC_VECTOR(1 downto 0);
		ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
		Zero: out STD_LOGIC;
		PC: buffer STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		Instr: in STD_LOGIC_VECTOR(31 downto 0);
		ALUResult, WriteData: buffer STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		ReadData: in STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component maindec
	port(op: in STD_LOGIC_VECTOR(6 downto 0);
		ResultSrc: out STD_LOGIC_VECTOR(1 downto 0);
		MemWrite: out STD_LOGIC;
		Branch, ALUSrc: out STD_LOGIC;
		RegWrite, Jump: out STD_LOGIC;
		ImmSrc: out STD_LOGIC_VECTOR(1 downto 0);
		ALUOp: out STD_LOGIC_VECTOR(1 downto 0));
  end component;
  component aludec
	port(opb5: in STD_LOGIC;
		funct3: in STD_LOGIC_VECTOR(2 downto 0);
		funct7b5: in STD_LOGIC;
		ALUOp: in STD_LOGIC_VECTOR(1 downto 0);
		ALUControl: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  component controller
	port(op: in STD_LOGIC_VECTOR(6 downto 0);
		funct3: in STD_LOGIC_VECTOR(2 downto 0);
		funct7b5, Zero: in STD_LOGIC;
		ResultSrc: out STD_LOGIC_VECTOR(1 downto 0);
		MemWrite: out STD_LOGIC;
		PCSrc, ALUSrc: out STD_LOGIC;
		RegWrite: out STD_LOGIC;
		Jump: buffer STD_LOGIC;
		ImmSrc: out STD_LOGIC_VECTOR(1 downto 0);
		ALUControl: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  component riscvsingle
	generic(width:integer := RISCV_Data_Width);
	port(clk, reset: in STD_LOGIC;
		PC: out STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		Instr: in STD_LOGIC_VECTOR(31 downto 0);
		MemWrite: out STD_LOGIC;
		ALUResult, WriteData: out STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0);
		ReadData: in STD_LOGIC_VECTOR(RISCV_Data_Width - 1 downto 0));
  end component;
--functions
  function to_integer (constant vec: STD_LOGIC_VECTOR) return integer;
  function "+" (constant a: STD_LOGIC_VECTOR; constant b: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
end riscv_pkg;
package body riscv_pkg is
  function to_integer(constant vec: STD_LOGIC_VECTOR) return integer is
    alias xvec: STD_LOGIC_VECTOR(vec'LENGTH - 1 downto 0) is vec;
    variable result: integer := 0;
  begin
    for i in xvec'RANGE loop
      result := result + result;
      if xvec(i) = '1' then
        result := result + 1;
      end if;
    end loop;
    return result;
  end to_integer;
  function "+" (constant a: STD_LOGIC_VECTOR; constant b: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
    alias xa: STD_LOGIC_VECTOR(a'LENGTH - 1 downto 0) is a;
    alias xb: STD_LOGIC_VECTOR(b'LENGTH - 1 downto 0) is b;
    variable result: STD_LOGIC_VECTOR(a'LENGTH - 1 downto 0);
    variable carry: STD_LOGIC := '0';
  begin
    for i in 0 to xa'LENGTH - 1 loop
	result(i) := xa(i) XOR xb(i) XOR carry;
 	carry := (xa(i) AND xb(i)) OR (carry AND xa(i)) OR (carry AND xb(i));
    end loop;
    return result;
  end "+";
end riscv_pkg;
