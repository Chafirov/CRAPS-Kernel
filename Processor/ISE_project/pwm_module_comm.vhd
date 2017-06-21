library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_module_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end pwm_module_comm ;

architecture synthesis of pwm_module_comm is

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
	component pwm_module
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			pwmclk : in std_logic ;
			en : in std_logic ;
			selec : in std_logic ;
			data : in std_logic_vector (15 downto 0) ;
			pwm_out : out std_logic
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal pwmclk : std_logic ;
    signal en : std_logic ;
    signal selec : std_logic ;
    signal data : std_logic_vector (15 downto 0) ;
    signal pwm_out : std_logic ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    pwmclk <= pc2board(2) ;
    en <= pc2board(3) ;
    selec <= pc2board(4) ;
    data(15 downto 0) <= pc2board(20 downto 5) ;
    board2pc(0) <= pwm_out ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    pwm_module_0 : pwm_module port map (rst, clk, pwmclk, en, selec, data(15 downto 0), pwm_out) ;


end synthesis;
