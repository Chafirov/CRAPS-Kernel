library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity affmux_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic;
        an : out std_logic_vector (3 downto 0)

) ;
end affmux_comm ;

architecture synthesis of affmux_comm is

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
	component affmux
		port (
			data : in std_logic_vector (15 downto 0) ;
			en : in std_logic_vector (3 downto 0) ;
			clk : in std_logic ;
			rst : in std_logic ;
			an : out std_logic_vector (3 downto 0) ;
			segs : out std_logic_vector (6 downto 0)
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal data : std_logic_vector (15 downto 0) ;
    signal en : std_logic_vector (3 downto 0) ;
    signal clk : std_logic ;
    signal rst : std_logic ;
    signal segs : std_logic_vector (6 downto 0) ;

begin

    -- combinatorial statements
    data(15 downto 0) <= pc2board(15 downto 0) ;
    en(3 downto 0) <= pc2board(19 downto 16) ;
    clk <= pc2board(20) ;
    rst <= pc2board(21) ;
    board2pc(6 downto 0) <= segs(6 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    affmux_0 : affmux port map (data(15 downto 0), en(3 downto 0), clk, rst, an(3 downto 0), segs(6 downto 0)) ;


end synthesis;
