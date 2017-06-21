library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity interruptions is
	port (
		rst : in std_logic ;
		clk : in std_logic ;
		pwm_out : in std_logic ;
		button : in std_logic_vector (2 downto 0) ;
		rsdataavailable : in std_logic ;
		rstbe : in std_logic ;
		soft_int : in std_logic ;
		handle_int : in std_logic ;
		int_id : out std_logic_vector (3 downto 0)
	);
end interruptions;

architecture synthesis of interruptions is

	-- submodules declarations
	component decoder4to16
		port (
			e : in std_logic_vector (3 downto 0) ;
			s : out std_logic_vector (15 downto 0)
		) ;
	end component ;
	component frontMontant
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			e : in std_logic ;
			strobe : out std_logic
		) ;
	end component ;
	component encodeurpriorite16
		port (
			e : in std_logic_vector (15 downto 0) ;
			num : out std_logic_vector (3 downto 0) ;
			act : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal int_id_int : std_logic_vector (3 downto 0) ;

	-- internal signals declarations
	signal rst_int_id : std_logic_vector (3 downto 0) ;
	signal rst_int : std_logic_vector (15 downto 0) ;
	signal int : std_logic_vector (15 downto 0) ;
	signal int_mem : std_logic_vector (15 downto 0) ;
	signal act : std_logic ;

begin

	-- buffer signals assignations
	int_id(3 downto 0) <= int_id_int(3 downto 0) ;

	-- concurrent statements
	rst_int_id(3 downto 0) <= 
		(int_id_int(3 downto 0) and (handle_int&handle_int&handle_int&handle_int)) ;
	int(7) <= soft_int ;
	int(0) <= '0' ;
	int(15 downto 8) <= "00000000" ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			int_mem(15 downto 0) <= "0000000000000000" ;
		elsif clk'event and clk = '1' then
			int_mem(15 downto 0) <= ((not rst_int(15 downto 0)) and int_mem(15 downto 0)) or (int(15 downto 0) and (not int_mem(15 downto 0))) ;
		end if ;
	end process ;

	-- components instanciations
	decoder4to16_0 : decoder4to16 port map (rst_int_id(3 downto 0), rst_int(15 downto 0)) ;
	frontMontant_1 : frontMontant port map (rst, clk, pwm_out, int(1)) ;
	frontMontant_2 : frontMontant port map (rst, clk, button(0), int(2)) ;
	frontMontant_3 : frontMontant port map (rst, clk, button(1), int(3)) ;
	frontMontant_4 : frontMontant port map (rst, clk, button(2), int(4)) ;
	frontMontant_5 : frontMontant port map (rst, clk, rsdataavailable, int(5)) ;
	frontMontant_6 : frontMontant port map (rst, clk, rstbe, int(6)) ;
	encodeurpriorite16_7 : encodeurpriorite16 port map (int_mem(15 downto 0), int_id_int(3 downto 0), act) ;

end synthesis;
