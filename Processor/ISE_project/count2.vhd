library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity count2 is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		en : in std_logic ;
		s : out std_logic_vector (1 downto 0)
	);
end count2;

architecture synthesis of count2 is

	-- buffer signals declarations
	signal s_int : std_logic_vector (1 downto 0) ;

	-- internal signals declarations
	signal ts : std_logic_vector (1 downto 0) ;

begin

	-- buffer signals assignations
	s(1 downto 0) <= s_int(1 downto 0) ;

	-- concurrent statements
	ts(0) <= '1' ;
	ts(1) <= s_int(0) ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			s_int(1 downto 0) <= "00" ;
		elsif en = '1' and clk'event and clk = '1' then
			s_int(1 downto 0) <= ((not ts(1 downto 0)) and s_int(1 downto 0)) or (ts(1 downto 0) and (not s_int(1 downto 0))) ;
		end if ;
	end process ;

end synthesis;
