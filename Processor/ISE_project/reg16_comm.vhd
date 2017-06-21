library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg16_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end reg16_comm ;

architecture synthesis of reg16_comm is

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
	component reg16
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			cs : in std_logic ;
			d : in std_logic_vector (15 downto 0) ;
			q : out std_logic_vector (15 downto 0)
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal cs : std_logic ;
    signal d : std_logic_vector (15 downto 0) ;
    signal q : std_logic_vector (15 downto 0) ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    cs <= pc2board(2) ;
    d(15 downto 0) <= pc2board(18 downto 3) ;
    board2pc(15 downto 0) <= q(15 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    reg16_0 : reg16 port map (rst, clk, cs, d(15 downto 0), q(15 downto 0)) ;


end synthesis;
