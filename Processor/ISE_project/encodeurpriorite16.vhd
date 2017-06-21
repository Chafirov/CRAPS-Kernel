library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity encodeurpriorite16 is
	port (
		e : in std_logic_vector (15 downto 0) ;
		num : out std_logic_vector (3 downto 0) ;
		act : out std_logic
	);
end encodeurpriorite16;

architecture synthesis of encodeurpriorite16 is

	-- submodules declarations
	component encodeurpriorite8
		port (
			e : in std_logic_vector (7 downto 0) ;
			num : out std_logic_vector (2 downto 0) ;
			act : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal num_low : std_logic_vector (2 downto 0) ;
	signal act_low : std_logic ;
	signal num_high : std_logic_vector (2 downto 0) ;
	signal act_high : std_logic ;

begin

	-- concurrent statements
	act <= (act_low) or (act_high) ;
	num(0) <= (num_high(0) and act_high) or (num_low(0) and (not act_high) and act_low) ;
	num(1) <= (num_high(1) and act_high) or (num_low(1) and (not act_high) and act_low) ;
	num(2) <= (num_high(2) and act_high) or (num_low(2) and (not act_high) and act_low) ;
	num(3) <= act_high ;

	-- components instanciations
	encodeurpriorite8_0 : encodeurpriorite8 port map (e(7 downto 0), num_low(2 downto 0), act_low) ;
	encodeurpriorite8_1 : encodeurpriorite8 port map (e(15 downto 8), num_high(2 downto 0), act_high) ;

end synthesis;
