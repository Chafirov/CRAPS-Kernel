library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg16 is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		cs : in std_logic ;
		d : in std_logic_vector (15 downto 0) ;
		q : out std_logic_vector (15 downto 0)
	);
end reg16;

architecture synthesis of reg16 is

begin

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			q(15 downto 0) <= "0000000000000000" ;
		elsif cs = '1' and clk'event and clk = '1' then
			q(15 downto 0) <= d(15 downto 0) ;
		end if ;
	end process ;

end synthesis;
