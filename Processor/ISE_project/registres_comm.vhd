library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registres_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic
) ;
end registres_comm ;

architecture synthesis of registres_comm is

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
	component registres
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			areg : in std_logic_vector (4 downto 0) ;
			breg : in std_logic_vector (4 downto 0) ;
			dreg : in std_logic_vector (4 downto 0) ;
			dbus : in std_logic_vector (31 downto 0) ;
			n_ual : in std_logic ;
			z_ual : in std_logic ;
			v_ual : in std_logic ;
			c_ual : in std_logic ;
			setn : in std_logic ;
			setz : in std_logic ;
			setvc : in std_logic ;
			handle_int : in std_logic ;
			waiting_int : in std_logic_vector (3 downto 0) ;
			abus : inout std_logic_vector (31 downto 0) ;
			bbus : inout std_logic_vector (31 downto 0) ;
			ir : out std_logic_vector (31 downto 0) ;
			break : out std_logic ;
			n : out std_logic ;
			z : out std_logic ;
			v : out std_logic ;
			c : out std_logic ;
			it : out std_logic_vector (3 downto 0)
		) ;
	end component ;

    -- internal signals declarations
    signal pc2board : std_logic_vector (127 downto 0) ;
    signal board2pc : std_logic_vector (127 downto 0) ;
    signal rst : std_logic ;
    signal clk : std_logic ;
    signal areg : std_logic_vector (4 downto 0) ;
    signal breg : std_logic_vector (4 downto 0) ;
    signal dreg : std_logic_vector (4 downto 0) ;
    signal dbus : std_logic_vector (31 downto 0) ;
    signal n_ual : std_logic ;
    signal z_ual : std_logic ;
    signal v_ual : std_logic ;
    signal c_ual : std_logic ;
    signal setn : std_logic ;
    signal setz : std_logic ;
    signal setvc : std_logic ;
    signal handle_int : std_logic ;
    signal waiting_int : std_logic_vector (3 downto 0) ;
    signal abus : std_logic_vector (31 downto 0) ;
    signal bbus : std_logic_vector (31 downto 0) ;
    signal ir : std_logic_vector (31 downto 0) ;
    signal break : std_logic ;
    signal n : std_logic ;
    signal z : std_logic ;
    signal v : std_logic ;
    signal c : std_logic ;
    signal it : std_logic_vector (3 downto 0) ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    areg(4 downto 0) <= pc2board(6 downto 2) ;
    breg(4 downto 0) <= pc2board(11 downto 7) ;
    dreg(4 downto 0) <= pc2board(16 downto 12) ;
    dbus(31 downto 0) <= pc2board(48 downto 17) ;
    n_ual <= pc2board(49) ;
    z_ual <= pc2board(50) ;
    v_ual <= pc2board(51) ;
    c_ual <= pc2board(52) ;
    setn <= pc2board(53) ;
    setz <= pc2board(54) ;
    setvc <= pc2board(55) ;
    handle_int <= pc2board(56) ;
    waiting_int(3 downto 0) <= pc2board(60 downto 57) ;
    board2pc(31 downto 0) <= abus(31 downto 0) ;
    board2pc(63 downto 32) <= bbus(31 downto 0) ;
    board2pc(95 downto 64) <= ir(31 downto 0) ;
    board2pc(96) <= break ;
    board2pc(97) <= n ;
    board2pc(98) <= z ;
    board2pc(99) <= v ;
    board2pc(100) <= c ;
    board2pc(104 downto 101) <= it(3 downto 0) ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    registres_0 : registres port map (rst, clk, areg(4 downto 0), breg(4 downto 0), dreg(4 downto 0), dbus(31 downto 0), n_ual, z_ual, v_ual, c_ual, setn, setz, setvc, handle_int, waiting_int(3 downto 0), abus(31 downto 0), bbus(31 downto 0), ir(31 downto 0), break, n, z, v, c, it(3 downto 0)) ;


end synthesis;
