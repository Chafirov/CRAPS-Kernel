library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift4 is
	port (
		r : in std_logic ;
		cs : in std_logic ;
		e : in std_logic_vector (31 downto 0) ;
		s : out std_logic_vector (31 downto 0)
	);
end shift4;

architecture synthesis of shift4 is

begin

	-- concurrent statements
	s(31 downto 28) <= 
		(e(31 downto 28) and ((not cs)&(not cs)&(not cs)&(not cs))) or
		(e(27 downto 24) and (cs&cs&cs&cs) and ((not r)&(not r)&(not r)&(not r))) ;
	s(27 downto 4) <= 
		(e(27 downto 4) and ((not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs))) or
		(e(23 downto 0) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and ((not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r))) or
		(e(31 downto 8) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and (r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r)) ;
	s(3 downto 0) <= 
		(e(3 downto 0) and ((not cs)&(not cs)&(not cs)&(not cs))) or
		(e(7 downto 4) and (cs&cs&cs&cs) and (r&r&r&r)) ;

end synthesis;
