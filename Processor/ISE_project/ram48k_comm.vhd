library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram48k_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end ram48k_comm ;

architecture synthesis of ram48k_comm is

    -- submodules declarations
    component commUSB
        port (
            mclk     : in std_logic;
            pdb      : inout std_logic_vector(7 downto 0);
            astb     : in std_logic;
            dstb     : in std_logic;
            pwr      : in std_logic;
            pwait    : out std_logic;
            pc2board : out std_logic_vector(127 downto 0);
            board2pc : in std_logic_vector(127 downto 0)
        ) ;
    end component ;
	component ram48k
		port (
			clk : in std_logic ;
			wrram : in std_logic ;
			abus : in std_logic_vector (13 downto 0) ;
			dbus : in std_logic_vector (31 downto 0) ;
			dbus_ram : out std_logic_vector (31 downto 0)
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal clk : std_logic ;
    signal wrram : std_logic ;
    signal abus : std_logic_vector (13 downto 0) ;
    signal dbus : std_logic_vector (31 downto 0) ;
    signal dbus_ram : std_logic_vector (31 downto 0) ;

begin

    -- combinatorial statements
    clk <= pc2board(0) ;
    wrram <= pc2board(1) ;
    abus(13 downto 0) <= pc2board(15 downto 2) ;
    dbus(31 downto 0) <= pc2board(47 downto 16) ;
    board2pc(31 downto 0) <= dbus_ram(31 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    ram48k_0 : ram48k port map (clk, wrram, abus(13 downto 0), dbus(31 downto 0), dbus_ram(31 downto 0)) ;


end synthesis;
