library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity micromachine is
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
	);
end micromachine;

architecture synthesis of micromachine is

	-- submodules declarations
	component decoder2to4
		port (
			e : in std_logic_vector (1 downto 0) ;
			s : out std_logic_vector (3 downto 0)
		) ;
	end component ;
	component ual
		port (
			a : in std_logic_vector (31 downto 0) ;
			b : in std_logic_vector (31 downto 0) ;
			cmd : in std_logic_vector (5 downto 0) ;
			s : inout std_logic_vector (31 downto 0) ;
			setn : out std_logic ;
			setz : out std_logic ;
			setvc : out std_logic ;
			n : out std_logic ;
			z : out std_logic ;
			v : out std_logic ;
			c : out std_logic
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
	component decoder4to16
		port (
			e : in std_logic_vector (3 downto 0) ;
			s : out std_logic_vector (15 downto 0)
		) ;
	end component ;
	component ram48k
		port (
			clk : in std_logic ;
			wrram : in std_logic ;
			abus : in std_logic_vector (13 downto 0) ;
			dbus : in std_logic_vector (31 downto 0) ;
			dbus_ram : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component reg8
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			cs : in std_logic ;
			d : in std_logic_vector (7 downto 0) ;
			q : out std_logic_vector (7 downto 0)
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
			ssegs : out std_logic_vector (6 downto 0)
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
------------------------------------------------------------------------
-- Author:  Dan Pederson
--          Copyright 2004 Digilent, Inc.
------------------------------------------------------------------------
-- Description: This file defines a UART which tranfers data from
--              serial form to parallel form and vice versa.
------------------------------------------------------------------------
-- Revision History:
--  07/15/04 (Created) DanP
--  02/25/08 (Created) ClaudiaG: made use of the baudDivide constant
--                               in the Clock Dividing Processes
------------------------------------------------------------------------

component Rs232RefComp is
    port (
        TXD     : out   std_logic                      := '1';
        RXD     : in    std_logic;
        CLK     : in    std_logic;                             --Master Clock = 50MHz
        DBIN    : in    std_logic_vector (7 downto 0);         --Data Bus in
        DBOUT   : out   std_logic_vector (7 downto 0);         --Data Bus out
        RDA     : out std_logic;                             --Read Data Available
        TBE     : out std_logic                      := '1'; --Transfer Bus Empty
        RD      : in    std_logic;                             --Read Strobe
        WR      : in    std_logic;                             --Write Strobe
        PE      : out   std_logic;                             --Parity Error Flag
        FE      : out   std_logic;                             --Frame Error Flag
        OE      : out   std_logic;                             --Overwrite Error Flag
        RST     : in    std_logic                      := '0'  --Master Reset
    );
end component;


	-- buffer signals declarations
	signal n_int : std_logic ;
	signal z_int : std_logic ;
	signal v_int : std_logic ;
	signal c_int : std_logic ;
	signal ir_int : std_logic_vector (31 downto 0) ;
	signal curr_int_int : std_logic_vector (3 downto 0) ;
	signal waiting_int_int : std_logic_vector (3 downto 0) ;
	signal pwm_out_int : std_logic ;

	-- internal signals declarations
	signal oe : std_logic_vector (3 downto 0) ;
	signal abus : std_logic_vector (31 downto 0) ;
	signal bbus : std_logic_vector (31 downto 0) ;
	signal dbus_ual : std_logic_vector (31 downto 0) ;
	signal setn : std_logic ;
	signal setz : std_logic ;
	signal setvc : std_logic ;
	signal dn : std_logic ;
	signal dz : std_logic ;
	signal dv : std_logic ;
	signal dc : std_logic ;
	signal rsdataavailable : std_logic ;
	signal rstbe : std_logic ;
	signal cs : std_logic_vector (15 downto 0) ;
	signal wrram : std_logic ;
	signal dbus_ram : std_logic_vector (31 downto 0) ;
	signal oe_ram : std_logic ;
	signal swdebounced : std_logic_vector (7 downto 0) ;
	signal oe_sw : std_logic ;
	signal wrssg : std_logic ;
	signal wrld : std_logic ;
	signal wrpwm : std_logic ;
	signal rsread : std_logic ;
	signal rsin : std_logic_vector (7 downto 0) ;
	signal rsout : std_logic_vector (7 downto 0) ;
	signal rswrite : std_logic ;
	signal pef : std_logic ;
	signal fef : std_logic ;
	signal oef : std_logic ;
	signal oe_ram16mo : std_logic ;

begin

	-- buffer signals assignations
	n <= n_int ;
	z <= z_int ;
	v <= v_int ;
	c <= c_int ;
	ir(31 downto 0) <= ir_int(31 downto 0) ;
	curr_int(3 downto 0) <= curr_int_int(3 downto 0) ;
	waiting_int(3 downto 0) <= waiting_int_int(3 downto 0) ;
	pwm_out <= pwm_out_int ;

	-- concurrent statements
	dbus(31 downto 0) <= dbus_ual(31 downto 0) when oe(1) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	wrram <= write and cs(0) ;
	oe_ram <= oe(2) and cs(0) ;
	dbus(31 downto 0) <= dbus_ram(31 downto 0) when oe_ram = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	oe_sw <= oe(2) and cs(9) ;
	dbus(31 downto 8) <= "000000000000000000000000" when oe_sw = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	dbus(7 downto 0) <= swdebounced(7 downto 0) when oe_sw = '1' else "ZZZZZZZZ" ;
	wrssg <= write and cs(10) ;
	wrld <= write and cs(11) ;
	wrpwm <= write and cs(12) ;
	rsread <= oe(2) and cs(13) and (not abus(1)) and (not abus(0)) ;
	dbus(31 downto 8) <= "000000000000000000000000" when rsread = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	dbus(7 downto 0) <= rsout(7 downto 0) when rsread = '1' else "ZZZZZZZZ" ;
	rswrite <= write and cs(13) and (not abus(1)) and abus(0) ;
	oe_ram16mo <= oe(2) and cs(14) ;
	dbus(31 downto 0) <= ram_read_data(31 downto 0) when oe_ram16mo = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	ram_addr(21 downto 0) <= abus(21 downto 0) ;
	ram_write_data(31 downto 0) <= dbus(31 downto 0) ;
	ram_read <= (not write) and oe(2) and cs(14) and (not ram_read_done) and (not ram_write_done) ;
	ram_write <= write and cs(14) and (not ram_read_done) and (not ram_write_done) ;
	global_read_done <= (not cs(14)) or (cs(14) and ram_read_done) ;
	global_write_done <= (not cs(14)) or (cs(14) and ram_write_done) ;
	dbus(31 downto 0) <= monitor(31 downto 0) when oe(3) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;

	-- components instanciations
	decoder2to4_0 : decoder2to4 port map (oe_num(1 downto 0), oe(3 downto 0)) ;
	ual_1 : ual port map (abus(31 downto 0), bbus(31 downto 0), cmd_ual(5 downto 0), dbus_ual(31 downto 0), setn, setz, setvc, dn, dz, dv, dc) ;
	registres_2 : registres port map (rst, clk, areg(4 downto 0), breg(4 downto 0), dreg(4 downto 0), dbus(31 downto 0), dn, dz, dv, dc, setn, setz, setvc, handle_int, waiting_int_int(3 downto 0), abus(31 downto 0), bbus(31 downto 0), ir_int(31 downto 0), break, n_int, z_int, v_int, c_int, curr_int_int(3 downto 0)) ;
	interruptions_3 : interruptions port map (rst, clk, pwm_out_int, button(2 downto 0), rsdataavailable, rstbe, soft_int, handle_int, waiting_int_int(3 downto 0)) ;
	decoder4to16_4 : decoder4to16 port map (abus(31 downto 28), cs(15 downto 0)) ;
	ram48k_5 : ram48k port map (clk, wrram, abus(13 downto 0), dbus(31 downto 0), dbus_ram(31 downto 0)) ;
	reg8_6 : reg8 port map (rst, swclk, '1', switch(7 downto 0), swdebounced(7 downto 0)) ;
	segs7_7 : segs7 port map (rst, clk, ssgclk, wrssg, abus(0), dbus(15 downto 0), anodes(3 downto 0), ssegs(6 downto 0)) ;
	reg8_8 : reg8 port map (rst, clk, wrld, dbus(7 downto 0), leds(7 downto 0)) ;
	pwm_module_9 : pwm_module port map (rst, clk, pwmclk, wrpwm, abus(0), dbus(15 downto 0), pwm_out_int) ;
	Rs232RefComp_10 : Rs232RefComp port map (txd, rxd, mclk, rsin(7 downto 0), rsout(7 downto 0), rsdataavailable, rstbe, rsread, rswrite, pef, fef, oef, rst) ;
	reg8_11 : reg8 port map (rst, clk, rswrite, dbus(7 downto 0), rsin(7 downto 0)) ;

end synthesis;
