library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity micromachine_comm is
    port (
        mclk : in std_logic ;
        pdb : inout std_logic_vector (7 downto 0) ;
        astb : in std_logic ;
        dstb : in std_logic ;
        pwr : in std_logic ;
        pwait : out std_logic;
        rxd : in std_logic ;

        txd : out std_logic

) ;
end micromachine_comm ;

architecture synthesis of micromachine_comm is

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
	component micromachine
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			mclk : in std_logic ;
			areg : in std_logic_vector (4 downto 0) ;
			breg : in std_logic_vector (4 downto 0) ;
			dreg : in std_logic_vector (4 downto 0) ;
			cmd_ual : in std_logic_vector (5 downto 0) ;
			oe_num : in std_logic_vector (1 downto 0) ;
			write : in std_logic ;
			soft_int : in std_logic ;
			handle_int : in std_logic ;
			monitor : in std_logic_vector (31 downto 0) ;
			button : in std_logic_vector (2 downto 0) ;
			switch : in std_logic_vector (7 downto 0) ;
			swclk : in std_logic ;
			ssgclk : in std_logic ;
			pwmclk : in std_logic ;
			rxd : in std_logic ;
			ram_read_data : in std_logic_vector (31 downto 0) ;
			ram_read_done : in std_logic ;
			ram_write_done : in std_logic ;
			dbus : inout std_logic_vector (31 downto 0) ;
			n : out std_logic ;
			z : out std_logic ;
			v : out std_logic ;
			c : out std_logic ;
			ir : out std_logic_vector (31 downto 0) ;
			break : out std_logic ;
			curr_int : out std_logic_vector (3 downto 0) ;
			waiting_int : out std_logic_vector (3 downto 0) ;
			leds : out std_logic_vector (7 downto 0) ;
			ssegs : out std_logic_vector (7 downto 0) ;
			anodes : out std_logic_vector (3 downto 0) ;
			pwm_out : out std_logic ;
			txd : out std_logic ;
			ram_addr : out std_logic_vector (21 downto 0) ;
			ram_read : out std_logic ;
			ram_write : out std_logic ;
			ram_write_data : out std_logic_vector (31 downto 0) ;
			global_read_done : out std_logic ;
			global_write_done : out std_logic
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
    signal cmd_ual : std_logic_vector (5 downto 0) ;
    signal oe_num : std_logic_vector (1 downto 0) ;
    signal write : std_logic ;
    signal soft_int : std_logic ;
    signal handle_int : std_logic ;
    signal monitor : std_logic_vector (31 downto 0) ;
    signal button : std_logic_vector (2 downto 0) ;
    signal switch : std_logic_vector (7 downto 0) ;
    signal swclk : std_logic ;
    signal ssgclk : std_logic ;
    signal pwmclk : std_logic ;
    signal ram_read_data : std_logic_vector (31 downto 0) ;
    signal ram_read_done : std_logic ;
    signal ram_write_done : std_logic ;
    signal dbus : std_logic_vector (31 downto 0) ;
    signal n : std_logic ;
    signal z : std_logic ;
    signal v : std_logic ;
    signal c : std_logic ;
    signal ir : std_logic_vector (31 downto 0) ;
    signal break : std_logic ;
    signal curr_int : std_logic_vector (3 downto 0) ;
    signal waiting_int : std_logic_vector (3 downto 0) ;
    signal leds : std_logic_vector (7 downto 0) ;
    signal ssegs : std_logic_vector (7 downto 0) ;
    signal anodes : std_logic_vector (3 downto 0) ;
    signal pwm_out : std_logic ;
    signal ram_addr : std_logic_vector (21 downto 0) ;
    signal ram_read : std_logic ;
    signal ram_write : std_logic ;
    signal ram_write_data : std_logic_vector (31 downto 0) ;
    signal global_read_done : std_logic ;
    signal global_write_done : std_logic ;

begin

    -- combinatorial statements
    rst <= pc2board(0) ;
    clk <= pc2board(1) ;
    areg(4 downto 0) <= pc2board(6 downto 2) ;
    breg(4 downto 0) <= pc2board(11 downto 7) ;
    dreg(4 downto 0) <= pc2board(16 downto 12) ;
    cmd_ual(5 downto 0) <= pc2board(22 downto 17) ;
    oe_num(1 downto 0) <= pc2board(24 downto 23) ;
    write <= pc2board(25) ;
    soft_int <= pc2board(26) ;
    handle_int <= pc2board(27) ;
    monitor(31 downto 0) <= pc2board(59 downto 28) ;
    button(2 downto 0) <= pc2board(62 downto 60) ;
    switch(7 downto 0) <= pc2board(70 downto 63) ;
    swclk <= pc2board(71) ;
    ssgclk <= pc2board(72) ;
    pwmclk <= pc2board(73) ;
    ram_read_data(31 downto 0) <= pc2board(105 downto 74) ;
    ram_read_done <= pc2board(106) ;
    ram_write_done <= pc2board(107) ;
    board2pc(31 downto 0) <= dbus(31 downto 0) ;
    board2pc(32) <= n ;
    board2pc(33) <= z ;
    board2pc(34) <= v ;
    board2pc(35) <= c ;
    board2pc(67 downto 36) <= ir(31 downto 0) ;
    board2pc(68) <= break ;
    board2pc(72 downto 69) <= curr_int(3 downto 0) ;
    board2pc(76 downto 73) <= waiting_int(3 downto 0) ;
    board2pc(84 downto 77) <= leds(7 downto 0) ;
    board2pc(92 downto 85) <= ssegs(7 downto 0) ;
    board2pc(96 downto 93) <= anodes(3 downto 0) ;
    board2pc(97) <= pwm_out ;
    board2pc(119 downto 98) <= ram_addr(21 downto 0) ;
    board2pc(120) <= ram_read ;
    board2pc(121) <= ram_write ;
    board2pc(153 downto 122) <= ram_write_data(31 downto 0) ;
    board2pc(154) <= global_read_done ;
    board2pc(155) <= global_write_done ;

    -- components instanciations
    commUSB_0 : commUSB port map (mclk, pdb(7 downto 0), astb, dstb, pwr, pwait, pc2board(127 downto 0), board2pc(127 downto 0)) ;
    micromachine_0 : micromachine port map (rst, clk, mclk, areg(4 downto 0), breg(4 downto 0), dreg(4 downto 0), cmd_ual(5 downto 0), oe_num(1 downto 0), write, soft_int, handle_int, monitor(31 downto 0), button(2 downto 0), switch(7 downto 0), swclk, ssgclk, pwmclk, rxd, ram_read_data(31 downto 0), ram_read_done, ram_write_done, dbus(31 downto 0), n, z, v, c, ir(31 downto 0), break, curr_int(3 downto 0), waiting_int(3 downto 0), leds(7 downto 0), ssegs(7 downto 0), anodes(3 downto 0), pwm_out, txd, ram_addr(21 downto 0), ram_read, ram_write, ram_write_data(31 downto 0), global_read_done, global_write_done) ;


end synthesis;
