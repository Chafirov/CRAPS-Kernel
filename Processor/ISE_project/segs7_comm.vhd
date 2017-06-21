library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity segs7_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end segs7_comm ;

architecture synthesis of segs7_comm is

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
	component segs7
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			ssgclk : in std_logic ;
			en : in std_logic ;
			selec : in std_logic ;
			data : in std_logic_vector (15 downto 0) ;
			anodes : out std_logic_vector (3 downto 0) ;
			ssegs : out std_logic_vector (7 downto 0)
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal ssgclk : std_logic ;
    signal en : std_logic ;
    signal selec : std_logic ;
    signal data : std_logic_vector (15 downto 0) ;
    signal anodes : std_logic_vector (3 downto 0) ;
    signal ssegs : std_logic_vector (7 downto 0) ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    ssgclk <= pc2board(2) ;
    en <= pc2board(3) ;
    selec <= pc2board(4) ;
    data(15 downto 0) <= pc2board(20 downto 5) ;
    board2pc(3 downto 0) <= anodes(3 downto 0) ;
    board2pc(11 downto 4) <= ssegs(7 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    segs7_0 : segs7 port map (rst, clk, ssgclk, en, selec, data(15 downto 0), anodes(3 downto 0), ssegs(7 downto 0)) ;


end synthesis;
