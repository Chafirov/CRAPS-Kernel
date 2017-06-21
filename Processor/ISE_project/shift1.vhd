library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift1 is
	port (
		r : in std_logic ;
		cs : in std_logic ;
		e : in std_logic_vector (31 downto 0) ;
		s : out std_logic_vector (31 downto 0)
	);
end shift1;

architecture synthesis of shift1 is

begin

	-- concurrent statements
	s(31) <= ((not cs) and e(31)) or (cs and (not r) and e(30)) ;
	s(30 downto 1) <= 
		(e(30 downto 1) and ((not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs))) or
		(e(29 downto 0) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and ((not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r))) or
		(e(31 downto 2) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and (r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r)) ;
	s(0) <= ((not cs) and e(0)) or (cs and r and e(1)) ;

end synthesis;
