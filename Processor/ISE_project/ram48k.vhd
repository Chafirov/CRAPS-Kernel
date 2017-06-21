library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram48k is
	port (
		clk : in std_logic ;
		wrram : in std_logic ;
		abus : in std_logic_vector (13 downto 0) ;
		dbus : in std_logic_vector (31 downto 0) ;
		dbus_ram : out std_logic_vector (31 downto 0)
	);
end ram48k;

architecture synthesis of ram48k is

	-- submodules declarations
	component rams_read_through8192x32
		port (
			clk  : in std_logic;
			we  : in std_logic;
			addr  : in std_logic_vector(12 downto 0);
			di  : in std_logic_vector(31 downto 0);
			do  : out std_logic_vector(31 downto 0)
		) ;
	end component ;
	component rams_read_through4096x32
		port (
			clk  : in std_logic;
			we  : in std_logic;
			addr  : in std_logic_vector(11 downto 0);
			di  : in std_logic_vector(31 downto 0);
			do  : out std_logic_vector(31 downto 0)
		) ;
	end component ;

	-- internal signals declarations
	signal wrram1 : std_logic ;
	signal wrram2 : std_logic ;
	signal dbus_ram1 : std_logic_vector (31 downto 0) ;
	signal dbus_ram2 : std_logic_vector (31 downto 0) ;

begin

	-- concurrent statements
	wrram1 <= wrram and (not abus(13)) ;
	wrram2 <= wrram and abus(13) ;
	dbus_ram(31 downto 0) <= 
		(dbus_ram1(31 downto 0) and ((not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13))&(not abus(13)))) or
		(dbus_ram2(31 downto 0) and (abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13)&abus(13))) ;

	-- components instanciations
	rams_read_through8192x32_0 : rams_read_through8192x32 port map (clk, wrram1, abus(12 downto 0), dbus(31 downto 0), dbus_ram1(31 downto 0)) ;
	rams_read_through4096x32_1 : rams_read_through4096x32 port map (clk, wrram2, abus(11 downto 0), dbus(31 downto 0), dbus_ram2(31 downto 0)) ;

end synthesis;
