library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity segs7 is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		ssgclk : in std_logic ;
		en : in std_logic ;
		selec : in std_logic ;
		data : in std_logic_vector (15 downto 0) ;
		anodes : out std_logic_vector (3 downto 0) ;
		ssegs : out std_logic_vector (6 downto 0)
	);
end segs7;

architecture synthesis of segs7 is

	-- submodules declarations
	component reg16
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			cs : in std_logic ;
			d : in std_logic_vector (15 downto 0) ;
			q : out std_logic_vector (15 downto 0)
		) ;
	end component ;
	component reg4
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			cs : in std_logic ;
			d : in std_logic_vector (3 downto 0) ;
			q : out std_logic_vector (3 downto 0)
		) ;
	end component ;
	component affmux
		port (
			data : in std_logic_vector (15 downto 0) ;
			en : in std_logic_vector (3 downto 0) ;
			clk : in std_logic ;
			rst : in std_logic ;
			an : out std_logic_vector (3 downto 0) ;
			segs : out std_logic_vector (6 downto 0)
		) ;
	end component ;

	-- internal signals declarations
	signal wrssgdata : std_logic ;
	signal ssgdata : std_logic_vector (15 downto 0) ;
	signal wrssgctrl : std_logic ;
	signal enssg : std_logic_vector (3 downto 0) ;
	signal nan : std_logic_vector (3 downto 0) ;
	signal nssg : std_logic_vector (6 downto 0) ;

begin

	-- concurrent statements
	wrssgdata <= en and (not selec) ;
	wrssgctrl <= en and selec ;
	anodes(3 downto 0) <= not nan(3 downto 0) ;
	ssegs(6 downto 0) <= not nssg(6 downto 0) ;
--	ssegs(7) <= '1' ; -- Why an 8th segment ??? (gjolly)

	-- components instanciations
	reg16_0 : reg16 port map (rst, clk, wrssgdata, data(15 downto 0), ssgdata(15 downto 0)) ;
	reg4_1 : reg4 port map (rst, clk, wrssgctrl, data(3 downto 0), enssg(3 downto 0)) ;
	affmux_2 : affmux port map (ssgdata(15 downto 0), enssg(3 downto 0), ssgclk, rst, nan(3 downto 0), nssg(6 downto 0)) ;

end synthesis;
