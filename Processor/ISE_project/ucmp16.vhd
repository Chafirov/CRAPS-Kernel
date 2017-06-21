library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ucmp16 is
	port (
		a : in std_logic_vector (15 downto 0) ;
		b : in std_logic_vector (15 downto 0) ;
		sup : out std_logic ;
		eq : out std_logic
	);
end ucmp16;

architecture synthesis of ucmp16 is

	-- submodules declarations
	component ucmp8
		port (
			a : in std_logic_vector (7 downto 0) ;
			b : in std_logic_vector (7 downto 0) ;
			sup : out std_logic ;
			eq : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal suph : std_logic ;
	signal eqh : std_logic ;
	signal supl : std_logic ;
	signal eql : std_logic ;

begin

	-- concurrent statements
	sup <= (suph) or (eqh and supl) ;
	eq <= eqh and eql ;

	-- components instanciations
	ucmp8_0 : ucmp8 port map (a(15 downto 8), b(15 downto 8), suph, eqh) ;
	ucmp8_1 : ucmp8 port map (a(7 downto 0), b(7 downto 0), supl, eql) ;

end synthesis;
