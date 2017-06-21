library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_module is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		pwmclk : in std_logic ;
		en : in std_logic ;
		selec : in std_logic ;
		data : in std_logic_vector (15 downto 0) ;
		pwm_out : out std_logic
	);
end pwm_module;

architecture synthesis of pwm_module is

	-- submodules declarations
	component reg16
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			cs : in std_logic ;
			d : in std_logic_vector (15 downto 0) ;
			q : out std_logic_vector (15 downto 0)
		) ;
	end component ;
	component pwm
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			p : in std_logic_vector (15 downto 0) ;
			n : in std_logic_vector (15 downto 0) ;
			m : out std_logic
		) ;
	end component ;

	-- internal signals declarations
	signal wrpwmp : std_logic ;
	signal pwmp : std_logic_vector (15 downto 0) ;
	signal wrpwmn : std_logic ;
	signal pwmn : std_logic_vector (15 downto 0) ;

begin

	-- concurrent statements
	wrpwmp <= en and (not selec) ;
	wrpwmn <= en and selec ;

	-- components instanciations
	reg16_0 : reg16 port map (rst, clk, wrpwmp, data(15 downto 0), pwmp(15 downto 0)) ;
	reg16_1 : reg16 port map (rst, clk, wrpwmn, data(15 downto 0), pwmn(15 downto 0)) ;
	pwm_2 : pwm port map (rst, pwmclk, '1', pwmp(15 downto 0), pwmn(15 downto 0), pwm_out) ;

end synthesis;
