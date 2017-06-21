library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder32 is
	port (
		a : in std_logic_vector (31 downto 0) ;
		b : in std_logic_vector (31 downto 0) ;
		cin : in std_logic ;
		s : out std_logic_vector (31 downto 0) ;
		cout : out std_logic
	);
end adder32;

architecture synthesis of adder32 is

	-- submodules declarations
	component adder4
		port (
			a : in std_logic_vector (3 downto 0) ;
			b : in std_logic_vector (3 downto 0) ;
			cin : in std_logic ;
			s : out std_logic_vector (3 downto 0) ;
			cout : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal c4 : std_logic ;
	signal c8 : std_logic ;
	signal c12 : std_logic ;
	signal c16 : std_logic ;
	signal c20 : std_logic ;
	signal c24 : std_logic ;
	signal c28 : std_logic ;

begin

	-- components instanciations
	adder4_0 : adder4 port map (a(3 downto 0), b(3 downto 0), cin, s(3 downto 0), c4) ;
	adder4_1 : adder4 port map (a(7 downto 4), b(7 downto 4), c4, s(7 downto 4), c8) ;
	adder4_2 : adder4 port map (a(11 downto 8), b(11 downto 8), c8, s(11 downto 8), c12) ;
	adder4_3 : adder4 port map (a(15 downto 12), b(15 downto 12), c12, s(15 downto 12), c16) ;
	adder4_4 : adder4 port map (a(19 downto 16), b(19 downto 16), c16, s(19 downto 16), c20) ;
	adder4_5 : adder4 port map (a(23 downto 20), b(23 downto 20), c20, s(23 downto 20), c24) ;
	adder4_6 : adder4 port map (a(27 downto 24), b(27 downto 24), c24, s(27 downto 24), c28) ;
	adder4_7 : adder4 port map (a(31 downto 28), b(31 downto 28), c28, s(31 downto 28), cout) ;

end synthesis;
