library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity affmux is
	port (
		data : in std_logic_vector (15 downto 0) ;
		en : in std_logic_vector (3 downto 0) ;
		clk : in std_logic ;
		rst : in std_logic ;
		an : out std_logic_vector (3 downto 0) ;
		segs : out std_logic_vector (6 downto 0)
	);
end affmux;

architecture synthesis of affmux is

	-- submodules declarations
	component count2
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			s : out std_logic_vector (1 downto 0)
		) ;
	end component ;
	component decoder2to4
		port (
			e : in std_logic_vector (1 downto 0) ;
			s : out std_logic_vector (3 downto 0)
		) ;
	end component ;
	component dec7segs
		port (
			x : in std_logic_vector (3 downto 0) ;
			segs : out std_logic_vector (6 downto 0)
		) ;
	end component ;

	-- internal signals declarations
	signal cpt : std_logic_vector (1 downto 0) ;
	signal sel : std_logic_vector (3 downto 0) ;
	signal x : std_logic_vector (3 downto 0) ;

begin

	-- concurrent statements
	x(3 downto 0) <= 
		(data(3 downto 0) and (sel(0)&sel(0)&sel(0)&sel(0))) or
		(data(7 downto 4) and (sel(1)&sel(1)&sel(1)&sel(1))) or
		(data(11 downto 8) and (sel(2)&sel(2)&sel(2)&sel(2))) or
		(data(15 downto 12) and (sel(3)&sel(3)&sel(3)&sel(3))) ;
	an(3 downto 0) <= en(3 downto 0) and sel(3 downto 0) ;

	-- components instanciations
	count2_0 : count2 port map (rst, clk, '1', cpt(1 downto 0)) ;
	decoder2to4_1 : decoder2to4 port map (cpt(1 downto 0), sel(3 downto 0)) ;
	dec7segs_2 : dec7segs port map (x(3 downto 0), segs(6 downto 0)) ;

end synthesis;
