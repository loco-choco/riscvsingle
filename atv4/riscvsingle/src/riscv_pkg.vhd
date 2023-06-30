library IEEE;
use IEEE.STD_LOGIC_1164.all;
package riscv_pkg is
  constant RISCV_Data_Width: integer := 32;
  component alu 
    generic(width: integer := RISCV_Data_Width);
    port(a, b: in STD_LOGIC_VECTOR(width - 1 downto 0);
			ALUControl: in STD_LOGIC_VECTOR(2 downto 0);
			ALUResult: buffer STD_LOGIC_VECTOR(width - 1 downto 0);
			Zero: out STD_LOGIC);
  end component;
  component extend port(instr: in STD_LOGIC_VECTOR(31 downto 7);
		immsrc: in STD_LOGIC_VECTOR(1 downto 0);
		immext: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  function to_integer (constant vec: STD_LOGIC_VECTOR) return integer;
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
end riscv_pkg;

