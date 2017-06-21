library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity count24 is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		en : in std_logic ;
		s : out std_logic_vector (23 downto 0) ;
		ripple : out std_logic
	);
end count24;

architecture synthesis of count24 is

	-- submodules declarations
	component count4
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			s : out std_logic_vector (3 downto 0) ;
			ripple : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal s_int : std_logic_vector (23 downto 0) ;

	-- internal signals declarations
	signal rip1 : std_logic ;
	signal rip2 : std_logic ;
	signal rip3 : std_logic ;
	signal rip4 : std_logic ;
	signal rip5 : std_logic ;

begin

	-- buffer signals assignations
	s(23 downto 0) <= s_int(23 downto 0) ;

	-- components instanciations
	count4_0 : count4 port map (rst, clk, en, s_int(3 downto 0), rip1) ;
	count4_1 : count4 port map (rst, clk, rip1, s_int(7 downto 4), rip2) ;
	count4_2 : count4 port map (rst, clk, rip2, s_int(11 downto 8), rip3) ;
	count4_3 : count4 port map (rst, clk, rip3, s_int(15 downto 12), rip4) ;
	count4_4 : count4 port map (rst, clk, rip4, s_int(19 downto 16), rip5) ;
	count4_5 : count4 port map (rst, clk, rip5, s_int(23 downto 20), ripple) ;

end synthesis;
