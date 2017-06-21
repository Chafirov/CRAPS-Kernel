library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift2 is
	port (
		r : in std_logic ;
		cs : in std_logic ;
		e : in std_logic_vector (31 downto 0) ;
		s : out std_logic_vector (31 downto 0)
	);
end shift2;

architecture synthesis of shift2 is

begin

	-- concurrent statements
	s(31 downto 30) <= 
		(e(31 downto 30) and ((not cs)&(not cs))) or
		(e(29 downto 28) and (cs&cs) and ((not r)&(not r))) ;
	s(29 downto 2) <= 
		(e(29 downto 2) and ((not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs))) or
		(e(27 downto 0) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and ((not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r))) or
		(e(31 downto 4) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and (r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r)) ;
	s(1 downto 0) <= 
		(e(1 downto 0) and ((not cs)&(not cs))) or
		(e(3 downto 2) and (cs&cs) and (r&r)) ;

end synthesis;
