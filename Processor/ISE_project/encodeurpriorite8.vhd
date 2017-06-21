library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity encodeurpriorite8 is
	port (
		e : in std_logic_vector (7 downto 0) ;
		num : out std_logic_vector (2 downto 0) ;
		act : out std_logic
	);
end encodeurpriorite8;

architecture synthesis of encodeurpriorite8 is

begin

	-- concurrent statements
	num(2) <= (e(7)) or (e(6)) or (e(5)) or (e(4)) ;
	num(1) <= (e(7)) or (e(6)) or ((not e(5)) and (not e(4)) and e(3)) or ((not e(5)) and (not e(4)) and e(2)) ;
	num(0) <= (e(7)) or ((not e(6)) and e(5)) or ((not e(6)) and (not e(4)) and e(3)) or ((not e(6)) and (not e(4)) and (not e(2)) and e(1)) ;
	act <= (e(7)) or (e(6)) or (e(5)) or (e(4)) or (e(3)) or (e(2)) or (e(1)) or (e(0)) ;

end synthesis;
