library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frontMontant is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		e : in std_logic ;
		strobe : out std_logic
	);
end frontMontant;

architecture synthesis of frontMontant is

	-- internal signals declarations
	signal x : std_logic ;
	signal y : std_logic ;

begin

	-- concurrent statements
	strobe <= x and y ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			x <= '0' ;
		elsif clk'event and clk = '1' then
			x <= e ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			y <= '0' ;
		elsif clk'event and clk = '1' then
			y <= not x ;
		end if ;
	end process ;

end synthesis;
