library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dec7segs is
	port (
		x : in std_logic_vector (3 downto 0) ;
		segs : out std_logic_vector (6 downto 0)
	);
end dec7segs;

architecture synthesis of dec7segs is

	-- submodules declarations
	component eq4
		port (
			a : in std_logic_vector (3 downto 0) ;
			b : in std_logic_vector (3 downto 0) ;
			equal : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal v0 : std_logic ;
	signal v1 : std_logic ;
	signal v2 : std_logic ;
	signal v3 : std_logic ;
	signal v4 : std_logic ;
	signal v5 : std_logic ;
	signal v6 : std_logic ;
	signal v7 : std_logic ;
	signal v8 : std_logic ;
	signal v9 : std_logic ;
	signal v10 : std_logic ;
	signal v11 : std_logic ;
	signal v12 : std_logic ;
	signal v13 : std_logic ;
	signal v14 : std_logic ;
	signal v15 : std_logic ;

begin

	-- concurrent statements
	segs(6 downto 0) <= 
		("0111111" and (v0&v0&v0&v0&v0&v0&v0)) or
		("0000110" and (v1&v1&v1&v1&v1&v1&v1)) or
		("1011011" and (v2&v2&v2&v2&v2&v2&v2)) or
		("1001111" and (v3&v3&v3&v3&v3&v3&v3)) or
		("1100110" and (v4&v4&v4&v4&v4&v4&v4)) or
		("1101101" and (v5&v5&v5&v5&v5&v5&v5)) or
		("1111101" and (v6&v6&v6&v6&v6&v6&v6)) or
		("0000111" and (v7&v7&v7&v7&v7&v7&v7)) or
		("1111111" and (v8&v8&v8&v8&v8&v8&v8)) or
		("1101111" and (v9&v9&v9&v9&v9&v9&v9)) or
		("1110111" and (v10&v10&v10&v10&v10&v10&v10)) or
		("1111100" and (v11&v11&v11&v11&v11&v11&v11)) or
		("0111001" and (v12&v12&v12&v12&v12&v12&v12)) or
		("1011110" and (v13&v13&v13&v13&v13&v13&v13)) or
		("1111001" and (v14&v14&v14&v14&v14&v14&v14)) or
		("1110001" and (v15&v15&v15&v15&v15&v15&v15)) ;

	-- components instanciations
	eq4_0 : eq4 port map (x(3 downto 0), "0000", v0) ;
	eq4_1 : eq4 port map (x(3 downto 0), "0001", v1) ;
	eq4_2 : eq4 port map (x(3 downto 0), "0010", v2) ;
	eq4_3 : eq4 port map (x(3 downto 0), "0011", v3) ;
	eq4_4 : eq4 port map (x(3 downto 0), "0100", v4) ;
	eq4_5 : eq4 port map (x(3 downto 0), "0101", v5) ;
	eq4_6 : eq4 port map (x(3 downto 0), "0110", v6) ;
	eq4_7 : eq4 port map (x(3 downto 0), "0111", v7) ;
	eq4_8 : eq4 port map (x(3 downto 0), "1000", v8) ;
	eq4_9 : eq4 port map (x(3 downto 0), "1001", v9) ;
	eq4_10 : eq4 port map (x(3 downto 0), "1010", v10) ;
	eq4_11 : eq4 port map (x(3 downto 0), "1011", v11) ;
	eq4_12 : eq4 port map (x(3 downto 0), "1100", v12) ;
	eq4_13 : eq4 port map (x(3 downto 0), "1101", v13) ;
	eq4_14 : eq4 port map (x(3 downto 0), "1110", v14) ;
	eq4_15 : eq4 port map (x(3 downto 0), "1111", v15) ;

end synthesis;
