library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity interruptions_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end interruptions_comm ;

architecture synthesis of interruptions_comm is

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
	component interruptions
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
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal pwm_out : std_logic ;
    signal button : std_logic_vector (2 downto 0) ;
    signal rsdataavailable : std_logic ;
    signal rstbe : std_logic ;
    signal soft_int : std_logic ;
    signal handle_int : std_logic ;
    signal int_id : std_logic_vector (3 downto 0) ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    pwm_out <= pc2board(2) ;
    button(2 downto 0) <= pc2board(5 downto 3) ;
    rsdataavailable <= pc2board(6) ;
    rstbe <= pc2board(7) ;
    soft_int <= pc2board(8) ;
    handle_int <= pc2board(9) ;
    board2pc(3 downto 0) <= int_id(3 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    interruptions_0 : interruptions port map (rst, clk, pwm_out, button(2 downto 0), rsdataavailable, rstbe, soft_int, handle_int, int_id(3 downto 0)) ;


end synthesis;
