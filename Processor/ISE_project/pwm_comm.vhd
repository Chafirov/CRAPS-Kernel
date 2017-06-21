library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end pwm_comm ;

architecture synthesis of pwm_comm is

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
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal en : std_logic ;
    signal p : std_logic_vector (15 downto 0) ;
    signal n : std_logic_vector (15 downto 0) ;
    signal m : std_logic ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    en <= pc2board(2) ;
    p(15 downto 0) <= pc2board(18 downto 3) ;
    n(15 downto 0) <= pc2board(34 downto 19) ;
    board2pc(0) <= m ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    pwm_0 : pwm port map (rst, clk, en, p(15 downto 0), n(15 downto 0), m) ;


end synthesis;
