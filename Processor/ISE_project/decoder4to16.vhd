library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder4to16 is
	port (
		e : in std_logic_vector (3 downto 0) ;
		s : out std_logic_vector (15 downto 0)
	);
end decoder4to16;

architecture synthesis of decoder4to16 is

	-- submodules declarations
	component decoder2to4
		port (
			e : in std_logic_vector (1 downto 0) ;
			s : out std_logic_vector (3 downto 0)
		) ;
	end component ;

	-- internal signals declarations
	signal high : std_logic_vector (3 downto 0) ;
	signal low : std_logic_vector (3 downto 0) ;

begin

	-- concurrent statements
	s(15 downto 12) <= 
		(low(3 downto 0) and (high(3)&high(3)&high(3)&high(3))) ;
	s(11 downto 8) <= 
		(low(3 downto 0) and (high(2)&high(2)&high(2)&high(2))) ;
	s(7 downto 4) <= 
		(low(3 downto 0) and (high(1)&high(1)&high(1)&high(1))) ;
	s(3 downto 0) <= 
		(low(3 downto 0) and (high(0)&high(0)&high(0)&high(0))) ;

	-- components instanciations
	decoder2to4_0 : decoder2to4 port map (e(3 downto 2), high(3 downto 0)) ;
	decoder2to4_1 : decoder2to4 port map (e(1 downto 0), low(3 downto 0)) ;

end synthesis;
