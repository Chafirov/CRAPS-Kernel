library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ucmp4 is
	port (
		a : in std_logic_vector (3 downto 0) ;
		b : in std_logic_vector (3 downto 0) ;
		sup : out std_logic ;
		equal : out std_logic
	);
end ucmp4;

architecture synthesis of ucmp4 is

	-- internal signals declarations
	signal eq : std_logic_vector (3 downto 0) ;
	signal sup2 : std_logic ;
	signal sup1 : std_logic ;

begin

	-- concurrent statements
	sup <= (a(3) and (not b(3))) or (eq(3) and sup2) ;
	sup2 <= (a(2) and (not b(2))) or (eq(2) and sup1) ;
	sup1 <= (a(1) and (not b(1))) or (eq(1) and a(0) and (not b(0))) ;
	eq(3 downto 0) <= (a(3 downto 0) and b(3 downto 0)) or ((not a(3 downto 0)) and (not b(3 downto 0))) ;
	equal <= eq(0) and eq(1) and eq(2) and eq(3) ;

end synthesis;
