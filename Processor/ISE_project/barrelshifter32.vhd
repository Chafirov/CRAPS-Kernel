library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity barrelshifter32 is
	port (
		r : in std_logic ;
		nb : in std_logic_vector (4 downto 0) ;
		e : in std_logic_vector (31 downto 0) ;
		s : out std_logic_vector (31 downto 0)
	);
end barrelshifter32;

architecture synthesis of barrelshifter32 is

	-- submodules declarations
	component shift16
		port (
			r : in std_logic ;
			cs : in std_logic ;
			e : in std_logic_vector (31 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component shift8
		port (
			r : in std_logic ;
			cs : in std_logic ;
			e : in std_logic_vector (31 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component shift4
		port (
			r : in std_logic ;
			cs : in std_logic ;
			e : in std_logic_vector (31 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component shift2
		port (
			r : in std_logic ;
			cs : in std_logic ;
			e : in std_logic_vector (31 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component shift1
		port (
			r : in std_logic ;
			cs : in std_logic ;
			e : in std_logic_vector (31 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;

	-- internal signals declarations
	signal s16 : std_logic_vector (31 downto 0) ;
	signal s8 : std_logic_vector (31 downto 0) ;
	signal s4 : std_logic_vector (31 downto 0) ;
	signal s2 : std_logic_vector (31 downto 0) ;

begin

	-- components instanciations
	shift16_0 : shift16 port map (r, nb(4), e(31 downto 0), s16(31 downto 0)) ;
	shift8_1 : shift8 port map (r, nb(3), s16(31 downto 0), s8(31 downto 0)) ;
	shift4_2 : shift4 port map (r, nb(2), s8(31 downto 0), s4(31 downto 0)) ;
	shift2_3 : shift2 port map (r, nb(1), s4(31 downto 0), s2(31 downto 0)) ;
	shift1_4 : shift1 port map (r, nb(0), s2(31 downto 0), s(31 downto 0)) ;

end synthesis;
