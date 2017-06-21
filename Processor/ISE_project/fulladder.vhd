library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fulladder is
	port (
		a : in std_logic ;
		b : in std_logic ;
		cin : in std_logic ;
		s : out std_logic ;
		cout : out std_logic
	);
end fulladder;

architecture synthesis of fulladder is

	-- internal signals declarations
	signal x : std_logic ;

begin

	-- concurrent statements
	x <= (a and (not b)) or ((not a) and b) ;
	cout <= ((not x) and a) or (x and cin) ;
	s <= (x and (not cin)) or ((not x) and cin) ;

end synthesis;
