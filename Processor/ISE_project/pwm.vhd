library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		en : in std_logic ;
		p : in std_logic_vector (15 downto 0) ;
		n : in std_logic_vector (15 downto 0) ;
		m : out std_logic
	);
end pwm;

architecture synthesis of pwm is

	-- submodules declarations
	component count16Z
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			sclr : in std_logic ;
			s : out std_logic_vector (15 downto 0) ;
			ripple : out std_logic
		) ;
	end component ;
	component ucmp16
		port (
			a : in std_logic_vector (15 downto 0) ;
			b : in std_logic_vector (15 downto 0) ;
			sup : out std_logic ;
			eq : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal eqp : std_logic ;
	signal cnt : std_logic_vector (15 downto 0) ;
	signal ripple : std_logic ;
	signal supp : std_logic ;
	signal supn : std_logic ;
	signal eqn : std_logic ;
	signal dm : std_logic ;

begin

	-- concurrent statements
	dm <= supn ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			m <= '0' ;
		elsif en = '1' and clk'event and clk = '1' then
			m <= dm ;
		end if ;
	end process ;

	-- components instanciations
	count16Z_0 : count16Z port map (rst, clk, en, eqp, cnt(15 downto 0), ripple) ;
	ucmp16_1 : ucmp16 port map (cnt(15 downto 0), p(15 downto 0), supp, eqp) ;
	ucmp16_2 : ucmp16 port map (cnt(15 downto 0), n(15 downto 0), supn, eqn) ;

end synthesis;
