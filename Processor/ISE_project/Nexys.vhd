library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Nexys is
	port (
------- Clock, buttons, leds, seven segments displayer, anodes ----------
		mclk : in std_logic ;
		btn : in std_logic_vector (3 downto 0) ;
		sw : in std_logic_vector (7 downto 0) ;
		ld : out std_logic_vector (8 downto 0) ;
		ssg : out std_logic_vector (6 downto 0) ;
		an : out std_logic_vector (3 downto 0) ;
--------------------------------------------------------------------------
-------- Pins used for shell communications (=> Pmods) -------------------
		ja1 : inout std_logic ; -- rxd
		ja2 : inout std_logic ; -- txd
---------------------------------------------------------------------------
-------- Pins used for Craps Debuger (=> USB)------------------------------
		rxd : in std_logic;
		txd : out std_logic;
---------------------------------------------------------------------------
-------- Memory pins ------------------------------------------------------
		memdb : inout std_logic_vector (15 downto 0) ; -- Data's bus
		memadr : out std_logic_vector (22 downto 0) ; -- Address' bus
		ramcs : out std_logic ; -- chip select
		memwr : out std_logic ; -- write enable
		memoe : out std_logic ; -- output enable
		ramub : out std_logic ; -- Upper Byte select
		ramlb : out std_logic ; -- Lower Byte select
		ramcre : out std_logic ; -- 
		ramadv : out std_logic ; -- 
		ramclk : out std_logic ; -- Ram clock
		ramwait : in std_logic  -- 
	);
end Nexys;

architecture synthesis of Nexys is

	-- submodules declarations
	component count24
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			en : in std_logic ;
			s : out std_logic_vector (23 downto 0) ;
			ripple : out std_logic
		) ;
	end component ;
	
	-- Communications for the debuger (ex. to receive the OS)
    component commUSB
        port (
			mclk, reset     : in std_logic;
			rxd      : in std_logic; -- rx pin of the board
			txd		: out std_logic; -- tx pin of the board
			pc2board : out std_logic_vector(127 downto 0); -- data to send (CPU -> CommUSB)
			board2pc : in std_logic_vector(127 downto 0)		-- data received (CommUSB -> CPU)
        ) ;
    end component ;
	 
	component sequencer
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			mon_req : in std_logic ;
			mon_cmd : in std_logic_vector (3 downto 0) ;
			monitor : in std_logic_vector (37 downto 0) ;
			break : in std_logic ;
			run : in std_logic ;
			ir : in std_logic_vector (31 downto 0) ;
			n : in std_logic ;
			z : in std_logic ;
			v : in std_logic ;
			c : in std_logic ;
			curr_int : in std_logic_vector (3 downto 0) ;
			waiting_int : in std_logic_vector (3 downto 0) ;
			global_read_done : in std_logic ;
			global_write_done : in std_logic ;
			write : out std_logic ;
			oe_num : out std_logic_vector (1 downto 0) ;
			areg : out std_logic_vector (4 downto 0) ;
			breg : out std_logic_vector (4 downto 0) ;
			dreg : out std_logic_vector (4 downto 0) ;
			cmd_ual : out std_logic_vector (5 downto 0) ;
			soft_int : out std_logic ;
			handle_int : out std_logic ;
			state : out std_logic_vector (5 downto 0) ;
			mon_ack : out std_logic
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
			ssegs : out std_logic_vector (6 downto 0) ;
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
component RamCtrl is
    port(
        rst        : in std_logic; -- active '1'
        clk        : in std_logic;
        address    : in std_logic_vector(21 downto 0);  -- read/write address (word addressed)
        read       : in std_logic;                      -- read mode
        readData   : out std_logic_vector(31 downto 0);
        readDone   : out std_logic;
        write      : in std_logic;                      -- write mode
        writeData  : in std_logic_vector(31 downto 0);  -- write value
        writeDone  : out std_logic;

        -- all pins
        MemDB      : inout std_logic_vector(15 downto 0); -- Memory data bus
        MemAdr     : out std_logic_vector(22 downto 0);   -- Memory Address bus
        RamCS      : out std_logic;  -- RAM CS
        FlashCS    : out std_logic;  -- Flash CS
        MemWR      : out std_logic;  -- memory write
        MemOE      : out std_logic;  -- memory read (Output Enable), also controls the MemDB direction
        RamUB      : out std_logic;  -- RAM Upper byte enable
        RamLB      : out std_logic;  -- RAM Lower byte enable
        RamCRE     : out std_logic;  -- Cfg Register enable
        RamAdv     : out std_logic;  -- RAM Address Valid pin
        RamClk     : out std_logic;  -- RAM Clock
        RamWait    : in std_logic;   -- RAM Wait pin
        FlashRp    : out std_logic;  -- Flash RP pin
        FlashStSts : in std_logic    -- Flash ST-STS pin
    );
end component;


	-- internal signals declarations
	---- to replace the ROM --------
	signal flashcs : std_logic ;
	signal flashrp : std_logic ;
	signal flashststs : std_logic;
	--------------------------------
	signal rst : std_logic ;
	signal irq : std_logic ;
	signal pwm_out : std_logic ;
	signal clock : std_logic_vector (23 downto 0) ;
	signal ripple : std_logic ;
	signal clk : std_logic ;
	signal swclk : std_logic ;
	signal ssgclk : std_logic ;
	signal pwmclk : std_logic ;
	signal xpc2board : std_logic_vector (127 downto 0) ;
	signal board2pc : std_logic_vector (127 downto 0) := (others => '0');
	signal pc2board : std_logic_vector (127 downto 0) ;
	signal mon_cmd : std_logic_vector (3 downto 0) ;
	signal mon_req : std_logic ;
	signal run : std_logic ;
	signal monitor : std_logic_vector (37 downto 0) ;
	signal mon_ack : std_logic ;
	signal break : std_logic ;
	signal n : std_logic ;
	signal z : std_logic ;
	signal v : std_logic ;
	signal c : std_logic ;
	signal dbus : std_logic_vector (31 downto 0) ;
	signal ir : std_logic_vector (31 downto 0) ;
	signal curr_int : std_logic_vector (3 downto 0) ;
	signal waiting_int : std_logic_vector (3 downto 0) ;
	signal global_read_done : std_logic ;
	signal global_write_done : std_logic ;
	signal write : std_logic ;
	signal oe_num : std_logic_vector (1 downto 0) ;
	signal areg : std_logic_vector (4 downto 0) ;
	signal breg : std_logic_vector (4 downto 0) ;
	signal dreg : std_logic_vector (4 downto 0) ;
	signal cmd_ual : std_logic_vector (5 downto 0) ;
	signal soft_int : std_logic ;
	signal handle_int : std_logic ;
	signal state : std_logic_vector (5 downto 0) ;
	signal ram_read_data : std_logic_vector (31 downto 0) ;
	signal ram_read_done : std_logic ;
	signal ram_write_done : std_logic ;
	signal ram_addr : std_logic_vector (21 downto 0) ;
	signal ram_read : std_logic ;
	signal ram_write : std_logic ;
	signal ram_write_data : std_logic_vector (31 downto 0) ;

begin

	-- concurrent statements
	ld(8) <= rst;
	rst <= not btn(0);
	irq <= (pwm_out) or (btn(3)) ;
	clk <= clock(1) ;
	swclk <= clock(19) ;
	ssgclk <= clock(15) ;
	pwmclk <= clock(7) ;
	mon_cmd(3 downto 0) <= pc2board(63 downto 60) ;
	mon_req <= pc2board(59) ;
	run <= pc2board(55) ;
	monitor(37 downto 0) <= pc2board(37 downto 0) ;
	board2pc(63) <= mon_ack ;
	board2pc(62) <= break ;
	board2pc(61) <= rst ;
	board2pc(60) <= n ;
	board2pc(59) <= z ;
	board2pc(58) <= v ;
	board2pc(57) <= c ;
	board2pc(31 downto 0) <= dbus(31 downto 0) ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			pc2board(127 downto 0) <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
		elsif clk'event and clk = '1' then
			pc2board(127 downto 0) <= xpc2board(127 downto 0) ;
		end if ;
	end process ;

	-- components instanciations
	count24_0 : count24 port map (rst, mclk, '1', clock(23 downto 0), ripple) ;
	commUSB_1 : commUSB port map (mclk, not rst, rxd, txd, xpc2board(127 downto 0), board2pc(127 downto 0)) ;
	sequencer_2 : sequencer port map (rst, clk, mon_req, mon_cmd(3 downto 0), monitor(37 downto 0), break, run, ir(31 downto 0), n, z, v, c, curr_int(3 downto 0), waiting_int(3 downto 0), global_read_done, global_write_done, write, oe_num(1 downto 0), areg(4 downto 0), breg(4 downto 0), dreg(4 downto 0), cmd_ual(5 downto 0), soft_int, handle_int, state(5 downto 0), mon_ack) ;
	micromachine_3 : micromachine port map (rst, clk, mclk, areg(4 downto 0), breg(4 downto 0), dreg(4 downto 0), cmd_ual(5 downto 0), oe_num(1 downto 0), write, soft_int, handle_int, monitor(31 downto 0), btn(3 downto 1), sw(7 downto 0), swclk, ssgclk, pwmclk, ja1, ram_read_data(31 downto 0), ram_read_done, ram_write_done, dbus(31 downto 0), n, z, v, c, ir(31 downto 0), break, curr_int(3 downto 0), waiting_int(3 downto 0), ld(7 downto 0), ssg(6 downto 0), an(3 downto 0), pwm_out, ja2, ram_addr(21 downto 0), ram_read, ram_write, ram_write_data(31 downto 0), global_read_done, global_write_done) ;
	RamCtrl_4 : RamCtrl port map (rst, clk, ram_addr(21 downto 0), ram_read, ram_read_data(31 downto 0), ram_read_done, ram_write, ram_write_data(31 downto 0), ram_write_done, memdb(15 downto 0), memadr(22 downto 0), ramcs, flashcs, memwr, memoe, ramub, ramlb, ramcre, ramadv, ramclk, ramwait, flashrp, flashststs) ;

end synthesis;
