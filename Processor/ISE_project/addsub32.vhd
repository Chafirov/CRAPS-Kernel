library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity addsub32 is
	port (
		a : in std_logic_vector (31 downto 0) ;
		b : in std_logic_vector (31 downto 0) ;
		addsub : in std_logic ;
		s : out std_logic_vector (31 downto 0) ;
		v : out std_logic ;
		c : out std_logic
	);
end addsub32;

architecture synthesis of addsub32 is

	-- submodules declarations
	component adder32
		port (
			a : in std_logic_vector (31 downto 0) ;
			b : in std_logic_vector (31 downto 0) ;
			cin : in std_logic ;
			s : out std_logic_vector (31 downto 0) ;
			cout : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal s_int : std_logic_vector (31 downto 0) ;

	-- internal signals declarations
	signal bb : std_logic_vector (31 downto 0) ;
	signal co : std_logic ;

begin

	-- buffer signals assignations
	s(31 downto 0) <= s_int(31 downto 0) ;

	-- concurrent statements
	bb(31 downto 0) <= 
		(b(31 downto 0) and ((not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub)&(not addsub))) or
		(not b(31 downto 0) and (addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub&addsub)) ;
	v <= ((not addsub) and a(31) and b(31) and (not s_int(31))) or ((not addsub) and (not a(31)) and (not b(31)) and s_int(31)) or (addsub and a(31) and (not b(31)) and (not s_int(31))) or (addsub and (not a(31)) and b(31) and s_int(31)) ;
	c <= ((not addsub) and co) or (addsub and (not co)) ;

	-- components instanciations
	adder32_0 : adder32 port map (a(31 downto 0), bb(31 downto 0), addsub, s_int(31 downto 0), co) ;

end synthesis;
