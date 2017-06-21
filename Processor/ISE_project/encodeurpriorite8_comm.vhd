library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity encodeurpriorite8_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end encodeurpriorite8_comm ;

architecture synthesis of encodeurpriorite8_comm is

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
	component encodeurpriorite8
		port (
			e : in std_logic_vector (7 downto 0) ;
			num : out std_logic_vector (2 downto 0) ;
			act : out std_logic
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal e : std_logic_vector (7 downto 0) ;
    signal num : std_logic_vector (2 downto 0) ;
    signal act : std_logic ;

begin

    -- combinatorial statements
    e(7 downto 0) <= pc2board(7 downto 0) ;
    board2pc(2 downto 0) <= num(2 downto 0) ;
    board2pc(3) <= act ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    encodeurpriorite8_0 : encodeurpriorite8 port map (e(7 downto 0), num(2 downto 0), act) ;


end synthesis;
