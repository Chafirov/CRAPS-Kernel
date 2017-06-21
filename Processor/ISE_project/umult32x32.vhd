library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

-- multiplier

entity umult32x32 is
	port (
		arg1  : in std_logic_vector(31 downto 0);
		arg2  : in std_logic_vector(31 downto 0);
		res  : out std_logic_vector(63 downto 0)
	) ;
end umult32x32 ;

architecture synthesis of umult32x32 is

begin
	res <= arg1 * arg2 ;

end synthesis ;
