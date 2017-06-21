library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder4 is
	port (
		a : in std_logic_vector (3 downto 0) ;
		b : in std_logic_vector (3 downto 0) ;
		cin : in std_logic ;
		s : out std_logic_vector (3 downto 0) ;
		cout : out std_logic
	);
end adder4;

architecture synthesis of adder4 is

	-- submodules declarations
	component fulladder
		port (
			a : in std_logic ;
			b : in std_logic ;
			cin : in std_logic ;
			s : out std_logic ;
			cout : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal c : std_logic_vector (3 downto 1) ;

begin

	-- components instanciations
	fulladder_0 : fulladder port map (a(0), b(0), cin, s(0), c(1)) ;
	fulladder_1 : fulladder port map (a(1), b(1), c(1), s(1), c(2)) ;
	fulladder_2 : fulladder port map (a(2), b(2), c(2), s(2), c(3)) ;
	fulladder_3 : fulladder port map (a(3), b(3), c(3), s(3), cout) ;

end synthesis;
