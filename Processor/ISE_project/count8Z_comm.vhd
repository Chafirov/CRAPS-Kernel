library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity count8Z_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end count8Z_comm ;

architecture synthesis of count8Z_comm is

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
	component count8Z
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			sclr : in std_logic ;
			s : out std_logic_vector (7 downto 0) ;
			ripple : out std_logic
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal en : std_logic ;
    signal sclr : std_logic ;
    signal s : std_logic_vector (7 downto 0) ;
    signal ripple : std_logic ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    en <= pc2board(2) ;
    sclr <= pc2board(3) ;
    board2pc(7 downto 0) <= s(7 downto 0) ;
    board2pc(8) <= ripple ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    count8Z_0 : count8Z port map (rst, clk, en, sclr, s(7 downto 0), ripple) ;


end synthesis;
