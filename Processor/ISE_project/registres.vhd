library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registres is
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
	);
end registres;

architecture synthesis of registres is

	-- submodules declarations
	component decoder5to32
		port (
			e : in std_logic_vector (4 downto 0) ;
			s : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component reg32
		port (
			rst : in std_logic ;
			clk : in std_logic ;
			ena : in std_logic ;
			d : in std_logic_vector (31 downto 0) ;
			q : out std_logic_vector (31 downto 0)
		) ;
	end component ;
	component eq32
		port (
			a : in std_logic_vector (31 downto 0) ;
			b : in std_logic_vector (31 downto 0) ;
			equal : out std_logic
		) ;
	end component ;

	-- buffer signals declarations
	signal ir_int : std_logic_vector (31 downto 0) ;
	signal n_int : std_logic ;
	signal z_int : std_logic ;
	signal v_int : std_logic ;
	signal c_int : std_logic ;
	signal it_int : std_logic_vector (3 downto 0) ;

	-- internal signals declarations
	signal asel : std_logic_vector (31 downto 0) ;
	signal bsel : std_logic_vector (31 downto 0) ;
	signal dsel : std_logic_vector (31 downto 0) ;
	signal r1 : std_logic_vector (31 downto 0) ;
	signal r2 : std_logic_vector (31 downto 0) ;
	signal r3 : std_logic_vector (31 downto 0) ;
	signal r4 : std_logic_vector (31 downto 0) ;
	signal r5 : std_logic_vector (31 downto 0) ;
	signal r6 : std_logic_vector (31 downto 0) ;
	signal r7 : std_logic_vector (31 downto 0) ;
	signal r8 : std_logic_vector (31 downto 0) ;
	signal r9 : std_logic_vector (31 downto 0) ;
	signal r10 : std_logic_vector (31 downto 0) ;
	signal r11 : std_logic_vector (31 downto 0) ;
	signal r12 : std_logic_vector (31 downto 0) ;
	signal r13 : std_logic_vector (31 downto 0) ;
	signal r14 : std_logic_vector (31 downto 0) ;
	signal r15 : std_logic_vector (31 downto 0) ;
	signal r16 : std_logic_vector (31 downto 0) ;
	signal r17 : std_logic_vector (31 downto 0) ;
	signal r18 : std_logic_vector (31 downto 0) ;
	signal r19 : std_logic_vector (31 downto 0) ;
	signal tmp1 : std_logic_vector (31 downto 0) ;
	signal tmp2 : std_logic_vector (31 downto 0) ;
	signal r23 : std_logic_vector (31 downto 0) ;
	signal r24 : std_logic_vector (31 downto 0) ;
	signal dit : std_logic_vector (3 downto 0) ;
	signal dn : std_logic ;
	signal dz : std_logic ;
	signal dv : std_logic ;
	signal dc : std_logic ;
	signal brk : std_logic_vector (31 downto 0) ;
	signal pc : std_logic_vector (31 downto 0) ;
	signal fp : std_logic_vector (31 downto 0) ;
	signal aret : std_logic_vector (31 downto 0) ;
	signal sp : std_logic_vector (31 downto 0) ;

begin

	-- buffer signals assignations
	ir(31 downto 0) <= ir_int(31 downto 0) ;
	n <= n_int ;
	z <= z_int ;
	v <= v_int ;
	c <= c_int ;
	it(3 downto 0) <= it_int(3 downto 0) ;

	-- concurrent statements
	abus(31 downto 0) <= r1(31 downto 0) when asel(1) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r1(31 downto 0) when bsel(1) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r2(31 downto 0) when asel(2) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r2(31 downto 0) when bsel(2) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r3(31 downto 0) when asel(3) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r3(31 downto 0) when bsel(3) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r4(31 downto 0) when asel(4) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r4(31 downto 0) when bsel(4) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r5(31 downto 0) when asel(5) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r5(31 downto 0) when bsel(5) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r6(31 downto 0) when asel(6) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r6(31 downto 0) when bsel(6) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r7(31 downto 0) when asel(7) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r7(31 downto 0) when bsel(7) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r8(31 downto 0) when asel(8) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r8(31 downto 0) when bsel(8) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r9(31 downto 0) when asel(9) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r9(31 downto 0) when bsel(9) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r10(31 downto 0) when asel(10) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r10(31 downto 0) when bsel(10) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r11(31 downto 0) when asel(11) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r11(31 downto 0) when bsel(11) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r12(31 downto 0) when asel(12) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r12(31 downto 0) when bsel(12) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r13(31 downto 0) when asel(13) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r13(31 downto 0) when bsel(13) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r14(31 downto 0) when asel(14) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r14(31 downto 0) when bsel(14) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r15(31 downto 0) when asel(15) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r15(31 downto 0) when bsel(15) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r16(31 downto 0) when asel(16) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r16(31 downto 0) when bsel(16) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r17(31 downto 0) when asel(17) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r17(31 downto 0) when bsel(17) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r18(31 downto 0) when asel(18) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r18(31 downto 0) when bsel(18) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r19(31 downto 0) when asel(19) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r19(31 downto 0) when bsel(19) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= "00000000000000000000000000000000" when asel(0) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= "00000000000000000000000000000000" when bsel(0) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= "00000000000000000000000000000001" when asel(20) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= "00000000000000000000000000000001" when bsel(20) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= tmp1(31 downto 0) when asel(21) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= tmp1(31 downto 0) when bsel(21) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= tmp2(31 downto 0) when asel(22) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= tmp2(31 downto 0) when bsel(22) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r23(31 downto 0) when asel(23) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r23(31 downto 0) when bsel(23) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= r24(31 downto 0) when asel(24) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= r24(31 downto 0) when bsel(24) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	dit(3 downto 0) <= 
		(waiting_int(3 downto 0) and ((not dsel(25))&(not dsel(25))&(not dsel(25))&(not dsel(25))) and (handle_int&handle_int&handle_int&handle_int)) or
		(it_int(3 downto 0) and ((not dsel(25))&(not dsel(25))&(not dsel(25))&(not dsel(25))) and ((not handle_int)&(not handle_int)&(not handle_int)&(not handle_int))) or
		(dbus(3 downto 0) and (dsel(25)&dsel(25)&dsel(25)&dsel(25)) and ((not handle_int)&(not handle_int)&(not handle_int)&(not handle_int))) ;
	abus(3 downto 0) <= it_int(3 downto 0) when asel(25) = '1' else "ZZZZ" ;
	bbus(3 downto 0) <= it_int(3 downto 0) when bsel(25) = '1' else "ZZZZ" ;
	dn <= ((not setn) and (not dsel(25)) and n_int) or (setn and n_ual) or (dsel(25) and dbus(7)) ;
	abus(7) <= n_int when asel(25) = '1' else 'Z' ;
	bbus(7) <= n_int when bsel(25) = '1' else 'Z' ;
	dz <= ((not setz) and (not dsel(25)) and z_int) or (setz and z_ual) or (dsel(25) and dbus(6)) ;
	abus(6) <= z_int when asel(25) = '1' else 'Z' ;
	bbus(6) <= z_int when bsel(25) = '1' else 'Z' ;
	dv <= ((not setvc) and (not dsel(25)) and v_int) or (setvc and v_ual) or (dsel(25) and dbus(5)) ;
	abus(5) <= v_int when asel(25) = '1' else 'Z' ;
	bbus(5) <= v_int when bsel(25) = '1' else 'Z' ;
	dc <= ((not setvc) and (not dsel(25)) and c_int) or (setvc and c_ual) or (dsel(25) and dbus(4)) ;
	abus(4) <= c_int when asel(25) = '1' else 'Z' ;
	bbus(4) <= c_int when bsel(25) = '1' else 'Z' ;
	abus(31 downto 0) <= brk(31 downto 0) when asel(26) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= brk(31 downto 0) when bsel(26) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= fp(31 downto 0) when asel(27) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= fp(31 downto 0) when bsel(27) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= aret(31 downto 0) when asel(28) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= aret(31 downto 0) when bsel(28) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= sp(31 downto 0) when asel(29) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= sp(31 downto 0) when bsel(29) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= pc(31 downto 0) when asel(30) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= pc(31 downto 0) when bsel(30) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	abus(31 downto 0) <= ir_int(31 downto 0) when asel(31) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
	bbus(31 downto 0) <= ir_int(31 downto 0) when bsel(31) = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;

	-- sequential statements
	process (clk, rst) begin
		if rst = '1' then
			it_int(3 downto 0) <= "0000" ;
		elsif clk'event and clk = '1' then
			it_int(3 downto 0) <= dit(3 downto 0) ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			n_int <= '0' ;
		elsif clk'event and clk = '1' then
			n_int <= dn ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			z_int <= '0' ;
		elsif clk'event and clk = '1' then
			z_int <= dz ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			v_int <= '0' ;
		elsif clk'event and clk = '1' then
			v_int <= dv ;
		end if ;
	end process ;
	process (clk, rst) begin
		if rst = '1' then
			c_int <= '0' ;
		elsif clk'event and clk = '1' then
			c_int <= dc ;
		end if ;
	end process ;

	-- components instanciations
	decoder5to32_0 : decoder5to32 port map (areg(4 downto 0), asel(31 downto 0)) ;
	decoder5to32_1 : decoder5to32 port map (breg(4 downto 0), bsel(31 downto 0)) ;
	decoder5to32_2 : decoder5to32 port map (dreg(4 downto 0), dsel(31 downto 0)) ;
	reg32_3 : reg32 port map (rst, clk, dsel(1), dbus(31 downto 0), r1(31 downto 0)) ;
	reg32_4 : reg32 port map (rst, clk, dsel(2), dbus(31 downto 0), r2(31 downto 0)) ;
	reg32_5 : reg32 port map (rst, clk, dsel(3), dbus(31 downto 0), r3(31 downto 0)) ;
	reg32_6 : reg32 port map (rst, clk, dsel(4), dbus(31 downto 0), r4(31 downto 0)) ;
	reg32_7 : reg32 port map (rst, clk, dsel(5), dbus(31 downto 0), r5(31 downto 0)) ;
	reg32_8 : reg32 port map (rst, clk, dsel(6), dbus(31 downto 0), r6(31 downto 0)) ;
	reg32_9 : reg32 port map (rst, clk, dsel(7), dbus(31 downto 0), r7(31 downto 0)) ;
	reg32_10 : reg32 port map (rst, clk, dsel(8), dbus(31 downto 0), r8(31 downto 0)) ;
	reg32_11 : reg32 port map (rst, clk, dsel(9), dbus(31 downto 0), r9(31 downto 0)) ;
	reg32_12 : reg32 port map (rst, clk, dsel(10), dbus(31 downto 0), r10(31 downto 0)) ;
	reg32_13 : reg32 port map (rst, clk, dsel(11), dbus(31 downto 0), r11(31 downto 0)) ;
	reg32_14 : reg32 port map (rst, clk, dsel(12), dbus(31 downto 0), r12(31 downto 0)) ;
	reg32_15 : reg32 port map (rst, clk, dsel(13), dbus(31 downto 0), r13(31 downto 0)) ;
	reg32_16 : reg32 port map (rst, clk, dsel(14), dbus(31 downto 0), r14(31 downto 0)) ;
	reg32_17 : reg32 port map (rst, clk, dsel(15), dbus(31 downto 0), r15(31 downto 0)) ;
	reg32_18 : reg32 port map (rst, clk, dsel(16), dbus(31 downto 0), r16(31 downto 0)) ;
	reg32_19 : reg32 port map (rst, clk, dsel(17), dbus(31 downto 0), r17(31 downto 0)) ;
	reg32_20 : reg32 port map (rst, clk, dsel(18), dbus(31 downto 0), r18(31 downto 0)) ;
	reg32_21 : reg32 port map (rst, clk, dsel(19), dbus(31 downto 0), r19(31 downto 0)) ;
	reg32_22 : reg32 port map (rst, clk, dsel(21), dbus(31 downto 0), tmp1(31 downto 0)) ;
	reg32_23 : reg32 port map (rst, clk, dsel(22), dbus(31 downto 0), tmp2(31 downto 0)) ;
	reg32_24 : reg32 port map (rst, clk, dsel(23), dbus(31 downto 0), r23(31 downto 0)) ;
	reg32_25 : reg32 port map (rst, clk, dsel(24), dbus(31 downto 0), r24(31 downto 0)) ;
	reg32_26 : reg32 port map (rst, clk, dsel(26), dbus(31 downto 0), brk(31 downto 0)) ;
	eq32_27 : eq32 port map (brk(31 downto 0), pc(31 downto 0), break) ;
	reg32_28 : reg32 port map (rst, clk, dsel(27), dbus(31 downto 0), fp(31 downto 0)) ;
	reg32_29 : reg32 port map (rst, clk, dsel(28), dbus(31 downto 0), aret(31 downto 0)) ;
	reg32_30 : reg32 port map (rst, clk, dsel(29), dbus(31 downto 0), sp(31 downto 0)) ;
	reg32_31 : reg32 port map (rst, clk, dsel(30), dbus(31 downto 0), pc(31 downto 0)) ;
	reg32_32 : reg32 port map (rst, clk, dsel(31), dbus(31 downto 0), ir_int(31 downto 0)) ;

end synthesis;
