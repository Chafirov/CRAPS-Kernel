library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity count16Z is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		en : in std_logic ;
		sclr : in std_logic ;
		s : out std_logic_vector (15 downto 0) ;
		ripple : out std_logic
	);
end count16Z;

architecture synthesis of count16Z is

	-- submodules declarations
	component count8Z
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			sclr : in std_logic ;
			s : out std_logic_vector (7 downto 0) ;
			ripple : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal s_int : std_logic_vector (15 downto 0) ;

	-- internal signals declarations
	signal rip1 : std_logic ;

begin

	-- buffer signals assignations
	s(15 downto 0) <= s_int(15 downto 0) ;

	-- components instanciations
	count8Z_0 : count8Z port map (rst, clk, en, sclr, s_int(7 downto 0), rip1) ;
	count8Z_1 : count8Z port map (rst, clk, rip1, sclr, s_int(15 downto 8), ripple) ;

end synthesis;
