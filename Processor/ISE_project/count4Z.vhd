library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity count4Z is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		en : in std_logic ;
		sclr : in std_logic ;
		s : out std_logic_vector (3 downto 0) ;
		ripple : out std_logic
	);
end count4Z;

architecture synthesis of count4Z is

	-- buffer signals declarations
	signal s_int : std_logic_vector (3 downto 0) ;

	-- internal signals declarations
	signal ts : std_logic_vector (3 downto 0) ;

begin

	-- buffer signals assignations
	s(3 downto 0) <= s_int(3 downto 0) ;

	-- concurrent statements
	ts(0) <= (en and (not sclr)) or (sclr and s_int(0)) ;
	ts(1) <= (en and (not sclr) and s_int(0)) or (sclr and s_int(1)) ;
	ts(2) <= (en and (not sclr) and s_int(0) and s_int(1)) or (sclr and s_int(2)) ;
	ts(3) <= (en and (not sclr) and s_int(0) and s_int(1) and s_int(2)) or (sclr and s_int(3)) ;
	ripple <= en and (not sclr) and s_int(0) and s_int(1) and s_int(2) and s_int(3) ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			s_int(3 downto 0) <= "0000" ;
		elsif clk'event and clk = '1' then
			s_int(3 downto 0) <= ((not ts(3 downto 0)) and s_int(3 downto 0)) or (ts(3 downto 0) and (not s_int(3 downto 0))) ;
		end if ;
	end process ;

end synthesis;
