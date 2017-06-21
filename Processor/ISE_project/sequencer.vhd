library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sequencer is
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
	);
end sequencer;

architecture synthesis of sequencer is

	-- submodules declarations
	component eq4
		port (
			a : in std_logic_vector (3 downto 0) ;
			b : in std_logic_vector (3 downto 0) ;
			equal : out std_logic
		) ;
	end component ;
	component ucmp4
		port (
			a : in std_logic_vector (3 downto 0) ;
			b : in std_logic_vector (3 downto 0) ;
			sup : out std_logic ;
			equal : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal state_int : std_logic_vector (5 downto 0) ;

	-- internal signals declarations
	signal stated : std_logic_vector (5 downto 0) ;
	signal is_fetch : std_logic ;
	signal is_memw1st : std_logic ;
	signal is_memw2st : std_logic ;
	signal is_memr1st : std_logic ;
	signal is_regr1st : std_logic ;
	signal is_regw1st : std_logic ;
	signal is_step : std_logic ;
	signal is_waitreadstep : std_logic ;
	signal is_decode : std_logic ;
	signal is_waitreadfetch : std_logic ;
	signal is_pcplus1 : std_logic ;
	signal is_calc_imm : std_logic ;
	signal is_addr : std_logic ;
	signal is_addr_imm : std_logic ;
	signal is_waitreadaddr : std_logic ;
	signal is_waitwriteaddr : std_logic ;
	signal is_waitreadtestandset : std_logic ;
	signal is_testandsetread : std_logic ;
	signal is_testandsetflag : std_logic ;
	signal is_waitwritetestandsetflag : std_logic ;
	signal is_branch : std_logic ;
	signal is_it1 : std_logic ;
	signal is_waitwriteit2 : std_logic ;
	signal is_it2 : std_logic ;
	signal is_it3 : std_logic ;
	signal is_waitwriteit4 : std_logic ;
	signal is_it4 : std_logic ;
	signal is_it5 : std_logic ;
	signal is_it6 : std_logic ;
	signal is_waitreadhandler : std_logic ;
	signal is_waitreadreti : std_logic ;
	signal is_reti1 : std_logic ;
	signal is_reti2 : std_logic ;
	signal is_waitreadreti2 : std_logic ;
	signal is_reti3 : std_logic ;
	signal memwritecmd : std_logic ;
	signal memreadcmd : std_logic ;
	signal regreadcmd : std_logic ;
	signal regwritecmd : std_logic ;
	signal it : std_logic ;
	signal stepcmd : std_logic ;
	signal brok : std_logic ;
	signal wdreg : std_logic_vector (4 downto 0) ;
	signal wdregwr : std_logic ;
	signal it_eq : std_logic ;
	signal ba : std_logic ;
	signal be : std_logic ;
	signal bne : std_logic ;
	signal bcs : std_logic ;
	signal bcc : std_logic ;
	signal bneg : std_logic ;
	signal bpos : std_logic ;
	signal bvc : std_logic ;
	signal bvs : std_logic ;
	signal bg : std_logic ;
	signal bge : std_logic ;
	signal bl : std_logic ;
	signal ble : std_logic ;
	signal bgu : std_logic ;
	signal bleu : std_logic ;

begin

	-- buffer signals assignations
	state(5 downto 0) <= state_int(5 downto 0) ;

	-- concurrent statements
	is_fetch <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and (not state_int(0)) ;
	is_memw1st <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and state_int(0) ;
	is_memw2st <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and state_int(1) and (not state_int(0)) ;
	is_memr1st <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and state_int(1) and state_int(0) ;
	is_regr1st <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and state_int(2) and (not state_int(1)) and (not state_int(0)) ;
	is_regw1st <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and state_int(2) and (not state_int(1)) and state_int(0) ;
	is_step <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and state_int(2) and state_int(1) and (not state_int(0)) ;
	is_waitreadstep <= (not state_int(5)) and (not state_int(4)) and (not state_int(3)) and state_int(2) and state_int(1) and state_int(0) ;
	is_decode <= (not state_int(5)) and (not state_int(4)) and state_int(3) and (not state_int(2)) and (not state_int(1)) and (not state_int(0)) ;
	is_waitreadfetch <= (not state_int(5)) and (not state_int(4)) and state_int(3) and (not state_int(2)) and (not state_int(1)) and state_int(0) ;
	is_pcplus1 <= (not state_int(5)) and (not state_int(4)) and state_int(3) and (not state_int(2)) and state_int(1) and (not state_int(0)) ;
	is_calc_imm <= (not state_int(5)) and (not state_int(4)) and state_int(3) and (not state_int(2)) and state_int(1) and state_int(0) ;
	is_addr <= (not state_int(5)) and (not state_int(4)) and state_int(3) and state_int(2) and (not state_int(1)) and (not state_int(0)) ;
	is_addr_imm <= (not state_int(5)) and (not state_int(4)) and state_int(3) and state_int(2) and (not state_int(1)) and state_int(0) ;
	is_waitreadaddr <= (not state_int(5)) and (not state_int(4)) and state_int(3) and state_int(2) and state_int(1) and (not state_int(0)) ;
	is_waitwriteaddr <= (not state_int(5)) and (not state_int(4)) and state_int(3) and state_int(2) and state_int(1) and state_int(0) ;
	is_waitreadtestandset <= (not state_int(5)) and state_int(4) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and (not state_int(0)) ;
	is_testandsetread <= (not state_int(5)) and state_int(4) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and state_int(0) ;
	is_testandsetflag <= (not state_int(5)) and state_int(4) and (not state_int(3)) and (not state_int(2)) and state_int(1) and (not state_int(0)) ;
	is_waitwritetestandsetflag <= (not state_int(5)) and state_int(4) and (not state_int(3)) and (not state_int(2)) and state_int(1) and state_int(0) ;
	is_branch <= (not state_int(5)) and state_int(4) and (not state_int(3)) and state_int(2) and (not state_int(1)) and (not state_int(0)) ;
	is_it1 <= (not state_int(5)) and state_int(4) and (not state_int(3)) and state_int(2) and (not state_int(1)) and state_int(0) ;
	is_waitwriteit2 <= (not state_int(5)) and state_int(4) and (not state_int(3)) and state_int(2) and state_int(1) and (not state_int(0)) ;
	is_it2 <= (not state_int(5)) and state_int(4) and (not state_int(3)) and state_int(2) and state_int(1) and state_int(0) ;
	is_it3 <= (not state_int(5)) and state_int(4) and state_int(3) and (not state_int(2)) and (not state_int(1)) and (not state_int(0)) ;
	is_waitwriteit4 <= (not state_int(5)) and state_int(4) and state_int(3) and (not state_int(2)) and (not state_int(1)) and state_int(0) ;
	is_it4 <= (not state_int(5)) and state_int(4) and state_int(3) and (not state_int(2)) and state_int(1) and (not state_int(0)) ;
	is_it5 <= (not state_int(5)) and state_int(4) and state_int(3) and (not state_int(2)) and state_int(1) and state_int(0) ;
	is_it6 <= (not state_int(5)) and state_int(4) and state_int(3) and state_int(2) and (not state_int(1)) and (not state_int(0)) ;
	is_waitreadhandler <= (not state_int(5)) and state_int(4) and state_int(3) and state_int(2) and (not state_int(1)) and state_int(0) ;
	is_waitreadreti <= (not state_int(5)) and state_int(4) and state_int(3) and state_int(2) and state_int(1) and (not state_int(0)) ;
	is_reti1 <= (not state_int(5)) and state_int(4) and state_int(3) and state_int(2) and state_int(1) and state_int(0) ;
	is_reti2 <= state_int(5) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and (not state_int(0)) ;
	is_waitreadreti2 <= state_int(5) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and (not state_int(1)) and state_int(0) ;
	is_reti3 <= state_int(5) and (not state_int(4)) and (not state_int(3)) and (not state_int(2)) and state_int(1) and (not state_int(0)) ;
	stated(5 downto 0) <= 
		("000001" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (memwritecmd&memwritecmd&memwritecmd&memwritecmd&memwritecmd&memwritecmd)) or
		("000001" and (is_memw1st&is_memw1st&is_memw1st&is_memw1st&is_memw1st&is_memw1st) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("000010" and (is_memw1st&is_memw1st&is_memw1st&is_memw1st&is_memw1st&is_memw1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("000000" and (is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st)) or
		("000011" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (memreadcmd&memreadcmd&memreadcmd&memreadcmd&memreadcmd&memreadcmd)) or
		("000011" and (is_memr1st&is_memr1st&is_memr1st&is_memr1st&is_memr1st&is_memr1st) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("000000" and (is_memr1st&is_memr1st&is_memr1st&is_memr1st&is_memr1st&is_memr1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("000100" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (regreadcmd&regreadcmd&regreadcmd&regreadcmd&regreadcmd&regreadcmd)) or
		("000100" and (is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("000000" and (is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("000101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (regwritecmd&regwritecmd&regwritecmd&regwritecmd&regwritecmd&regwritecmd)) or
		("000101" and (is_regw1st&is_regw1st&is_regw1st&is_regw1st&is_regw1st&is_regw1st) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("000000" and (is_regw1st&is_regw1st&is_regw1st&is_regw1st&is_regw1st&is_regw1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("000000" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not it)&(not it)&(not it)&(not it)&(not it)&(not it)) and ((not run)&(not run)&(not run)&(not run)&(not run)&(not run))) or
		("000000" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not it)&(not it)&(not it)&(not it)&(not it)&(not it)) and (break&break&break&break&break&break)) or
		("000110" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (stepcmd&stepcmd&stepcmd&stepcmd&stepcmd&stepcmd)) or
		("000110" and (is_step&is_step&is_step&is_step&is_step&is_step) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("000111" and (is_step&is_step&is_step&is_step&is_step&is_step) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("000111" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("001000" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("001001" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)&(not break)) and ((not it)&(not it)&(not it)&(not it)&(not it)&(not it))) or
		("001001" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("001000" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("001010" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("000000" and (is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1)) or
		("001011" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		("001010" and (is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm)) or
		("001100" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("001101" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		("001100" and (is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm)) or
		("001110" and (is_addr&is_addr&is_addr&is_addr&is_addr&is_addr) and ((not ir(21))&(not ir(21))&(not ir(21))&(not ir(21))&(not ir(21))&(not ir(21)))) or
		("001110" and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("001010" and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("001111" and (is_addr&is_addr&is_addr&is_addr&is_addr&is_addr) and (ir(21)&ir(21)&ir(21)&ir(21)&ir(21)&ir(21))) or
		("001111" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("001010" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("010000" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))) and ((not ir(23))&(not ir(23))&(not ir(23))&(not ir(23))&(not ir(23))&(not ir(23)))) or
		("010000" and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("010001" and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("010010" and (is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread)) or
		("010011" and (is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag)) or
		("010011" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("001010" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("001010" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))) and (ir(23)&ir(23)&ir(23)&ir(23)&ir(23)&ir(23))) or
		("000000" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not brok)&(not brok)&(not brok)&(not brok)&(not brok)&(not brok))) or
		("010100" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and (brok&brok&brok&brok&brok&brok)) or
		("000000" and (is_branch&is_branch&is_branch&is_branch&is_branch&is_branch)) or
		("001010" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("010101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)&(not break)) and (it&it&it&it&it&it)) or
		("010110" and (is_it1&is_it1&is_it1&is_it1&is_it1&is_it1)) or
		("010110" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("010111" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("011000" and (is_it2&is_it2&is_it2&is_it2&is_it2&is_it2)) or
		("011001" and (is_it3&is_it3&is_it3&is_it3&is_it3&is_it3)) or
		("011001" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("011010" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("011011" and (is_it4&is_it4&is_it4&is_it4&is_it4&is_it4)) or
		("011100" and (is_it5&is_it5&is_it5&is_it5&is_it5&is_it5)) or
		("011101" and (is_it6&is_it6&is_it6&is_it6&is_it6&is_it6)) or
		("011101" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("000000" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("011110" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("011110" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("011111" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("100000" and (is_reti1&is_reti1&is_reti1&is_reti1&is_reti1&is_reti1)) or
		("100001" and (is_reti2&is_reti2&is_reti2&is_reti2&is_reti2&is_reti2)) or
		("100001" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("100010" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("000000" and (is_reti3&is_reti3&is_reti3&is_reti3&is_reti3&is_reti3)) ;
	write <= (is_memw2st and '1') or (is_addr and ir(21) and '1') or (is_waitwriteaddr and (not global_write_done) and '1') or (is_waitwriteaddr and global_write_done and '1') or (is_testandsetflag and '1') or (is_waitwritetestandsetflag and (not global_write_done) and '1') or (is_waitwritetestandsetflag and global_write_done and '1') or (is_it1 and '1') or (is_waitwriteit2 and (not global_write_done) and '1') or (is_waitwriteit2 and global_write_done and '1') or (is_it3 and '1') or (is_waitwriteit4 and (not global_write_done) and '1') or (is_waitwriteit4 and global_write_done and '1') ;
	oe_num(1 downto 0) <= 
		("11" and (is_fetch&is_fetch) and (mon_req&mon_req) and (memwritecmd&memwritecmd)) or
		("11" and (is_memw1st&is_memw1st) and ((not mon_req)&(not mon_req))) or
		("01" and (is_memw2st&is_memw2st)) or
		("11" and (is_fetch&is_fetch) and (mon_req&mon_req) and (memreadcmd&memreadcmd)) or
		("10" and (is_memr1st&is_memr1st) and (mon_req&mon_req)) or
		("01" and (is_fetch&is_fetch) and (mon_req&mon_req) and (regreadcmd&regreadcmd)) or
		("01" and (is_regr1st&is_regr1st) and (mon_req&mon_req)) or
		("11" and (is_regw1st&is_regw1st) and ((not mon_req)&(not mon_req))) or
		("10" and (is_step&is_step) and ((not mon_req)&(not mon_req))) or
		("10" and (is_waitreadstep&is_waitreadstep) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadstep&is_waitreadstep) and (global_read_done&global_read_done)) or
		("10" and (is_fetch&is_fetch) and (run&run) and ((not mon_req)&(not mon_req)) and ((not break)&(not break)) and ((not it)&(not it))) or
		("10" and (is_waitreadfetch&is_waitreadfetch) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadfetch&is_waitreadfetch) and (global_read_done&global_read_done)) or
		("01" and (is_decode&is_decode) and (ir(31)&ir(31)) and ((not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13)))) or
		("01" and (is_pcplus1&is_pcplus1)) or
		("01" and (is_decode&is_decode) and (ir(31)&ir(31)) and ((not ir(30))&(not ir(30))) and (ir(13)&ir(13))) or
		("01" and (is_calc_imm&is_calc_imm)) or
		("01" and (is_decode&is_decode) and (ir(31)&ir(31)) and (ir(30)&ir(30)) and ((not ir(13))&(not ir(13)))) or
		("01" and (is_decode&is_decode) and (ir(31)&ir(31)) and (ir(30)&ir(30)) and (ir(13)&ir(13))) or
		("01" and (is_addr_imm&is_addr_imm)) or
		("10" and (is_addr&is_addr) and ((not ir(21))&(not ir(21)))) or
		("10" and (is_waitreadaddr&is_waitreadaddr) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadaddr&is_waitreadaddr) and (global_read_done&global_read_done)) or
		("01" and (is_addr&is_addr) and (ir(21)&ir(21))) or
		("01" and (is_waitwriteaddr&is_waitwriteaddr) and ((not global_write_done)&(not global_write_done))) or
		("01" and (is_waitwriteaddr&is_waitwriteaddr) and (global_write_done&global_write_done)) or
		("10" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and (ir(30)&ir(30)) and (ir(29)&ir(29)) and ((not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))) and ((not ir(23))&(not ir(23)))) or
		("10" and (is_waitreadtestandset&is_waitreadtestandset) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadtestandset&is_waitreadtestandset) and (global_read_done&global_read_done)) or
		("01" and (is_testandsetread&is_testandsetread)) or
		("01" and (is_testandsetflag&is_testandsetflag)) or
		("01" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag) and ((not global_write_done)&(not global_write_done))) or
		("01" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag) and (global_write_done&global_write_done)) or
		("01" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and (ir(30)&ir(30)) and (ir(29)&ir(29)) and ((not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))) and (ir(23)&ir(23))) or
		("01" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))) and (ir(29)&ir(29)) and ((not brok)&(not brok))) or
		("01" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))) and (ir(29)&ir(29)) and (brok&brok)) or
		("01" and (is_branch&is_branch)) or
		("01" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))) and ((not ir(29))&(not ir(29)))) or
		("01" and (is_fetch&is_fetch) and (run&run) and ((not mon_req)&(not mon_req)) and ((not break)&(not break)) and (it&it)) or
		("01" and (is_it1&is_it1)) or
		("01" and (is_waitwriteit2&is_waitwriteit2) and ((not global_write_done)&(not global_write_done))) or
		("01" and (is_waitwriteit2&is_waitwriteit2) and (global_write_done&global_write_done)) or
		("01" and (is_it2&is_it2)) or
		("01" and (is_it3&is_it3)) or
		("01" and (is_waitwriteit4&is_waitwriteit4) and ((not global_write_done)&(not global_write_done))) or
		("01" and (is_waitwriteit4&is_waitwriteit4) and (global_write_done&global_write_done)) or
		("01" and (is_it4&is_it4)) or
		("01" and (is_it5&is_it5)) or
		("10" and (is_it6&is_it6)) or
		("10" and (is_waitreadhandler&is_waitreadhandler) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadhandler&is_waitreadhandler) and (global_read_done&global_read_done)) or
		("10" and (is_decode&is_decode) and ((not ir(31))&(not ir(31))) and (ir(30)&ir(30)) and ((not ir(29))&(not ir(29)))) or
		("10" and (is_waitreadreti&is_waitreadreti) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadreti&is_waitreadreti) and (global_read_done&global_read_done)) or
		("01" and (is_reti1&is_reti1)) or
		("10" and (is_reti2&is_reti2)) or
		("10" and (is_waitreadreti2&is_waitreadreti2) and ((not global_read_done)&(not global_read_done))) or
		("10" and (is_waitreadreti2&is_waitreadreti2) and (global_read_done&global_read_done)) or
		("01" and (is_reti3&is_reti3)) ;
	areg(4 downto 0) <= 
		("10101" and (is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st)) or
		("10101" and (is_memr1st&is_memr1st&is_memr1st&is_memr1st&is_memr1st) and (mon_req&mon_req&mon_req&mon_req&mon_req)) or
		("11110" and (is_step&is_step&is_step&is_step&is_step) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("11110" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11110" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11110" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)) and ((not it)&(not it)&(not it)&(not it)&(not it))) or
		("11110" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11110" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		(ir(18 downto 14) and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("11110" and (is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1)) or
		("11111" and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		(ir(18 downto 14) and (is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm)) or
		(ir(18 downto 14) and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("11111" and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		(ir(18 downto 14) and (is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm)) or
		("10101" and (is_addr&is_addr&is_addr&is_addr&is_addr) and ((not ir(21))&(not ir(21))&(not ir(21))&(not ir(21))&(not ir(21)))) or
		("10101" and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("10101" and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("10101" and (is_addr&is_addr&is_addr&is_addr&is_addr) and (ir(21)&ir(21)&ir(21)&ir(21)&ir(21))) or
		("10101" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("10101" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		(ir(4 downto 0) and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))) and ((not ir(23))&(not ir(23))&(not ir(23))&(not ir(23))&(not ir(23)))) or
		(ir(4 downto 0) and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		(ir(4 downto 0) and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("10101" and (is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread)) or
		(ir(4 downto 0) and (is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag)) or
		(ir(4 downto 0) and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		(ir(4 downto 0) and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("11110" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not brok)&(not brok)&(not brok)&(not brok)&(not brok))) or
		("11111" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and (brok&brok&brok&brok&brok)) or
		("11110" and (is_branch&is_branch&is_branch&is_branch&is_branch)) or
		("11111" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("11101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)) and (it&it&it&it&it)) or
		("11101" and (is_it1&is_it1&is_it1&is_it1&is_it1)) or
		("11101" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("11101" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("11101" and (is_it2&is_it2&is_it2&is_it2&is_it2)) or
		("11101" and (is_it3&is_it3&is_it3&is_it3&is_it3)) or
		("11101" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("11101" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("11001" and (is_it5&is_it5&is_it5&is_it5&is_it5)) or
		("10101" and (is_it6&is_it6&is_it6&is_it6&is_it6)) or
		("10101" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("10101" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("11101" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11101" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11101" and (is_reti1&is_reti1&is_reti1&is_reti1&is_reti1)) or
		("11101" and (is_reti2&is_reti2&is_reti2&is_reti2&is_reti2)) or
		("11101" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11101" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11101" and (is_reti3&is_reti3&is_reti3&is_reti3&is_reti3)) ;
	breg(4 downto 0) <= 
		("10110" and (is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st)) or
		(monitor(4 downto 0) and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req) and (regreadcmd&regreadcmd&regreadcmd&regreadcmd&regreadcmd)) or
		(monitor(4 downto 0) and (is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st) and (mon_req&mon_req&mon_req&mon_req&mon_req)) or
		(ir(4 downto 0) and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("10100" and (is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1)) or
		("10101" and (is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm)) or
		(ir(4 downto 0) and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("10101" and (is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm)) or
		(ir(29 downto 25) and (is_addr&is_addr&is_addr&is_addr&is_addr) and (ir(21)&ir(21)&ir(21)&ir(21)&ir(21))) or
		(ir(29 downto 25) and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		(ir(29 downto 25) and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("10100" and (is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread)) or
		("10100" and (is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag)) or
		("10100" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("10100" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("10100" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not brok)&(not brok)&(not brok)&(not brok)&(not brok))) or
		("10101" and (is_branch&is_branch&is_branch&is_branch&is_branch)) or
		("10100" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)) and (it&it&it&it&it)) or
		("11110" and (is_it1&is_it1&is_it1&is_it1&is_it1)) or
		("11110" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("11110" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("10100" and (is_it2&is_it2&is_it2&is_it2&is_it2)) or
		("11001" and (is_it3&is_it3&is_it3&is_it3&is_it3)) or
		("11001" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("11001" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("10100" and (is_reti1&is_reti1&is_reti1&is_reti1&is_reti1)) or
		("10100" and (is_reti3&is_reti3&is_reti3&is_reti3&is_reti3)) ;
	dreg(4 downto 0) <= 
		("10101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req) and (memwritecmd&memwritecmd&memwritecmd&memwritecmd&memwritecmd)) or
		("10110" and (is_memw1st&is_memw1st&is_memw1st&is_memw1st&is_memw1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("10101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req) and (memreadcmd&memreadcmd&memreadcmd&memreadcmd&memreadcmd)) or
		(wdreg(4 downto 0) and (is_regw1st&is_regw1st&is_regw1st&is_regw1st&is_regw1st) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("11111" and (is_step&is_step&is_step&is_step&is_step) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req))) or
		("11111" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11111" and (is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep&is_waitreadstep) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11111" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)) and ((not it)&(not it)&(not it)&(not it)&(not it))) or
		("11111" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11111" and (is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch&is_waitreadfetch) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		(ir(29 downto 25) and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("11110" and (is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1&is_pcplus1)) or
		("10101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		(ir(29 downto 25) and (is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm)) or
		("10101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("10101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		("10101" and (is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm&is_addr_imm)) or
		(ir(29 downto 25) and (is_addr&is_addr&is_addr&is_addr&is_addr) and ((not ir(21))&(not ir(21))&(not ir(21))&(not ir(21))&(not ir(21)))) or
		(ir(29 downto 25) and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		(ir(29 downto 25) and (is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr&is_waitreadaddr) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("10101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))&(not ir(28))) and ((not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))&(not ir(27))) and ((not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))&(not ir(26))) and ((not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))&(not ir(25))) and ((not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))&(not ir(24))) and ((not ir(23))&(not ir(23))&(not ir(23))&(not ir(23))&(not ir(23)))) or
		("10101" and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("10101" and (is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset&is_waitreadtestandset) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11110" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and ((not brok)&(not brok)&(not brok)&(not brok)&(not brok))) or
		("10101" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and (brok&brok&brok&brok&brok)) or
		("11110" and (is_branch&is_branch&is_branch&is_branch&is_branch)) or
		(ir(28 downto 24) and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("11101" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)) and (it&it&it&it&it)) or
		("11101" and (is_it2&is_it2&is_it2&is_it2&is_it2)) or
		("10101" and (is_it5&is_it5&is_it5&is_it5&is_it5)) or
		("11110" and (is_it6&is_it6&is_it6&is_it6&is_it6)) or
		("11110" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11110" and (is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler&is_waitreadhandler) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11001" and (is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("11001" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11001" and (is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti&is_waitreadreti) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11101" and (is_reti1&is_reti1&is_reti1&is_reti1&is_reti1)) or
		("11110" and (is_reti2&is_reti2&is_reti2&is_reti2&is_reti2)) or
		("11110" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and ((not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done)&(not global_read_done))) or
		("11110" and (is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2&is_waitreadreti2) and (global_read_done&global_read_done&global_read_done&global_read_done&global_read_done)) or
		("11101" and (is_reti3&is_reti3&is_reti3&is_reti3&is_reti3)) ;
	cmd_ual(5 downto 0) <= 
		("101000" and (is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st&is_memw2st)) or
		("101000" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req) and (regreadcmd&regreadcmd&regreadcmd&regreadcmd&regreadcmd&regreadcmd)) or
		("101000" and (is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st&is_regr1st) and (mon_req&mon_req&mon_req&mon_req&mon_req&mon_req)) or
		(ir(24 downto 19) and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13))&(not ir(13)))) or
		("100000" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		(ir(24 downto 19) and (is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm&is_calc_imm)) or
		("100000" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and (ir(31)&ir(31)&ir(31)&ir(31)&ir(31)&ir(31)) and (ir(30)&ir(30)&ir(30)&ir(30)&ir(30)&ir(30)) and (ir(13)&ir(13)&ir(13)&ir(13)&ir(13)&ir(13))) or
		("101000" and (is_addr&is_addr&is_addr&is_addr&is_addr&is_addr) and (ir(21)&ir(21)&ir(21)&ir(21)&ir(21)&ir(21))) or
		("101000" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("101000" and (is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr&is_waitwriteaddr) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("010100" and (is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread&is_testandsetread)) or
		("101000" and (is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag&is_testandsetflag)) or
		("101000" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("101000" and (is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag&is_waitwritetestandsetflag) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("100001" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and (ir(29)&ir(29)&ir(29)&ir(29)&ir(29)&ir(29)) and (brok&brok&brok&brok&brok&brok)) or
		("100011" and (is_decode&is_decode&is_decode&is_decode&is_decode&is_decode) and ((not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))&(not ir(31))) and ((not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))&(not ir(30))) and ((not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29))&(not ir(29)))) or
		("000100" and (is_fetch&is_fetch&is_fetch&is_fetch&is_fetch&is_fetch) and (run&run&run&run&run&run) and ((not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)&(not mon_req)) and ((not break)&(not break)&(not break)&(not break)&(not break)&(not break)) and (it&it&it&it&it&it)) or
		("101000" and (is_it1&is_it1&is_it1&is_it1&is_it1&is_it1)) or
		("101000" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("101000" and (is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2&is_waitwriteit2) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("000100" and (is_it2&is_it2&is_it2&is_it2&is_it2&is_it2)) or
		("101000" and (is_it3&is_it3&is_it3&is_it3&is_it3&is_it3)) or
		("101000" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and ((not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done)&(not global_write_done))) or
		("101000" and (is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4&is_waitwriteit4) and (global_write_done&global_write_done&global_write_done&global_write_done&global_write_done&global_write_done)) or
		("100100" and (is_it5&is_it5&is_it5&is_it5&is_it5&is_it5)) ;
	soft_int <= is_decode and (not ir(31)) and ir(30) and ir(29) and (not ir(28)) and (not ir(27)) and (not ir(26)) and (not ir(25)) and (not ir(24)) and ir(23) and '1' ;
	handle_int <= is_it4 and '1' ;
	wdregwr <= is_fetch and mon_req and regwritecmd ;
	mon_ack <= (is_memw1st) or (is_memr1st and mon_req) or (is_regr1st and mon_req) or (is_regw1st and mon_req) ;
	brok <= (ba) or (be and z) or (bne and (not z)) or (bcs and c) or (bcc and (not c)) or (bneg and n) or (bpos and (not n)) or (bvc and (not v)) or (bvs and v) or (bg and (not z) and n and v) or (bg and (not z) and (not n) and (not v)) or (bge and n and v) or (bge and (not n) and (not v)) or (bl and n and (not v)) or (bl and (not n) and v) or (ble and z) or (ble and n and (not v)) or (ble and (not n) and v) or (bgu and (not z) and (not c)) or (bleu and z) or (bleu and c) ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			state_int(5 downto 0) <= "000000" ;
		elsif clk'event and clk = '1' then
			state_int(5 downto 0) <= stated(5 downto 0) ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			wdreg(4 downto 0) <= "00000" ;
		elsif wdregwr = '1' and clk'event and clk = '1' then
			wdreg(4 downto 0) <= monitor(36 downto 32) ;
		end if ;
	end process ;

	-- components instanciations
	eq4_0 : eq4 port map (mon_cmd(3 downto 0), "0000", memreadcmd) ;
	eq4_1 : eq4 port map (mon_cmd(3 downto 0), "0001", regreadcmd) ;
	eq4_2 : eq4 port map (mon_cmd(3 downto 0), "0010", memwritecmd) ;
	eq4_3 : eq4 port map (mon_cmd(3 downto 0), "0011", regwritecmd) ;
	eq4_4 : eq4 port map (mon_cmd(3 downto 0), "0100", stepcmd) ;
	ucmp4_5 : ucmp4 port map (waiting_int(3 downto 0), curr_int(3 downto 0), it, it_eq) ;
	eq4_6 : eq4 port map (ir(28 downto 25), "1000", ba) ;
	eq4_7 : eq4 port map (ir(28 downto 25), "0001", be) ;
	eq4_8 : eq4 port map (ir(28 downto 25), "1001", bne) ;
	eq4_9 : eq4 port map (ir(28 downto 25), "0101", bcs) ;
	eq4_10 : eq4 port map (ir(28 downto 25), "1101", bcc) ;
	eq4_11 : eq4 port map (ir(28 downto 25), "0110", bneg) ;
	eq4_12 : eq4 port map (ir(28 downto 25), "1110", bpos) ;
	eq4_13 : eq4 port map (ir(28 downto 25), "1111", bvc) ;
	eq4_14 : eq4 port map (ir(28 downto 25), "0111", bvs) ;
	eq4_15 : eq4 port map (ir(28 downto 25), "1010", bg) ;
	eq4_16 : eq4 port map (ir(28 downto 25), "1011", bge) ;
	eq4_17 : eq4 port map (ir(28 downto 25), "0011", bl) ;
	eq4_18 : eq4 port map (ir(28 downto 25), "0010", ble) ;
	eq4_19 : eq4 port map (ir(28 downto 25), "1100", bgu) ;
	eq4_20 : eq4 port map (ir(28 downto 25), "0100", bleu) ;

end synthesis;
