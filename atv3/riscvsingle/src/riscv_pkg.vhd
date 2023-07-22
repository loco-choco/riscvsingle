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
end riscv_pkg;
