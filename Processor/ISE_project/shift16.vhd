library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift16 is
	port (
		r : in std_logic ;
		cs : in std_logic ;
		e : in std_logic_vector (31 downto 0) ;
		s : out std_logic_vector (31 downto 0)
	);
end shift16;

architecture synthesis of shift16 is

begin

	-- concurrent statements
	s(31 downto 16) <= 
		(e(31 downto 16) and ((not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs))) or
		(e(15 downto 0) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and ((not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r)&(not r))) ;
	s(15 downto 0) <= 
		(e(15 downto 0) and ((not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs)&(not cs))) or
		(e(31 downto 16) and (cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs&cs) and (r&r&r&r&r&r&r&r&r&r&r&r&r&r&r&r)) ;

end synthesis;
