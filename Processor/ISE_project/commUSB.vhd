library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all;

-- commUSB module

entity commUSB is
        port (
            mclk, reset     : in std_logic;
				rxd 		: in std_logic;
				txd		: out std_logic;
            pc2board : out std_logic_vector(127 downto 0); -- data to send (CPU -> CommUSB)
            board2pc : in std_logic_vector(127 downto 0)		-- data received (CommUSB -> CPU)
        ) ;
end commUSB ;

architecture synthesis of commUSB is

	component diviseurClk_UART port (
		 clk, reset : in  std_logic;
		 nclk       : out std_logic);
	end component;

	component UART port (
		 clk, reset : in std_logic;
		 cs, rd, wr : in std_logic;
		 RxD        : in std_logic;
		 TxD        : out std_logic;
		 IntR       : out std_logic;        
		 IntT       : out std_logic;         
		 addr       : in std_logic_vector(1 downto 0);
		 data_in    : out std_logic_vector(7 downto 0);
		 data_out   : in std_logic_vector(7 downto 0));
	end component;

	component dec7seg port (
		value : in std_logic_vector(3 downto 0);
		seg : out std_logic_vector (6 downto 0)
	);
	end component;

	type t_etat is (Idle, receiveByte, sendByte, endSending, receiveCtrl, readByte, send_ack);
	signal state : t_etat;

	signal regAddr : std_logic_vector(4 downto 0) := "00000";
	signal cs, rd, wr : std_logic;
	signal IntR, IntT : std_logic;
	signal addr : std_logic_vector(1 downto 0) := (others => '0');
	signal UARTClk : std_logic;
	signal db_in : std_logic_vector(7 downto 0);
	signal db_out : std_logic_vector(7 downto 0);
	signal pollingBit : std_logic;
	signal value : std_logic_vector(3 downto 0);
	signal ctrl : std_logic_vector(7 downto 0);
	
begin
	
	divClk : diviseurClk_UART port map (mclk, reset, UARTClk);
	uart_unit : UART port map (UARTClk, reset, cs, rd, wr, rxd, txd, IntR, IntT, addr, db_in, db_out);

	-- Decode the address register and select the appropriate data register
	db_out <=
	-------------- Use for data ----------------------------
		board2pc(7 downto 0) when regAddr = "00000" else
		board2pc(15 downto 8) when regAddr = "00001" else
		board2pc(23 downto 16) when regAddr = "00010" else
		board2pc(31 downto 24) when regAddr = "00011" else
		board2pc(39 downto 32) when regAddr = "00100" else
		board2pc(47 downto 40) when regAddr = "00101" else
		board2pc(55 downto 48) when regAddr = "00110" else
		board2pc(63 downto 56) when regAddr = "00111" else
	---------- Others are used for control ------------------------------
		board2pc(7 downto 0) when regAddr = "01000" else
		board2pc(15 downto 8) when regAddr = "01001" else
		board2pc(23 downto 16) when regAddr = "01010" else
		board2pc(31 downto 24) when regAddr = "01011" else
		board2pc(39 downto 32) when regAddr = "01100" else
		board2pc(47 downto 40) when regAddr = "01101" else
		board2pc(55 downto 48) when regAddr = "01110" else
		board2pc(63 downto 56) when regAddr = "01111" else
		ctrl;

	process (UARTClk, reset) --Receive (control and data)
		variable polling : std_logic;
		variable cmpt_frame : natural range 0 to 7 := 0;
	begin
	
		if reset = '0' then
			state <= idle;
			cs <= '1'; rd <= '1'; wr <= '1'; -- data read 
			addr <= (others => '0');
			regAddr <= "00000";
			cmpt_frame := 0;
			
		elsif rising_edge(UARTClk) then
			case state is
			
				when Idle =>
					cs <= '0'; rd <= '0'; wr <= '1'; -- UART's registers set to read data ...
					addr <= "01"; -- ...on the control register
					
					if (IntR = '0') then -- New data received by UART
						cs <= '0'; rd <= '0'; wr <= '1'; -- UART's registers set to read data ...
						addr <= "00"; -- ...on the data bus
						-- first data received = always regAddr
						state <= receiveCtrl;
						
					end if;
					
				when receiveCtrl =>
					regAddr(4) <= '0';
					regAddr(3 downto 0) <= db_in(3 downto 0);
					polling := db_in(4); -- Should I send or receive
					if (IntR = '1') then
						cs <= '1'; rd <= '1'; wr <= '1'; -- data read
						if polling = '1' then
							state <= sendByte;
						else
							state <= receiveByte;
						end if;
					end if;
					
				when receiveByte =>					
					cs <= '0'; rd <= '0'; wr <= '1'; -- UART's registers set to read data ...
					addr <= "01"; -- ...on the control register
					
					if IntR = '0' then
						cs <= '0'; rd <= '0'; wr <= '1'; -- UART's registers set to read data...
						addr <= "00"; -- ...on the data bus
						state <= readByte;
						
					end if;
				
				when readByte =>
					
					case regAddr(3 downto 0) is
							when "0000" => pc2board(7 downto 0) <= db_in;
							when "0001" => pc2board(15 downto 8) <= db_in;
							when "0010" => pc2board(23 downto 16) <= db_in;
							when "0011" => pc2board(31 downto 24) <= db_in;
							when "0100" => pc2board(39 downto 32) <= db_in;
							when "0101" => pc2board(47 downto 40) <= db_in;
							when "0110" => pc2board(55 downto 48) <= db_in;
							when "0111" => pc2board(63 downto 56) <= db_in;
							when "1000" => pc2board(71 downto 64) <= db_in;
							when "1001" => pc2board(79 downto 72) <= db_in;
							when "1010" => pc2board(87 downto 80) <= db_in;
							when "1011" => pc2board(95 downto 88) <= db_in;
							when "1100" => pc2board(103 downto 96) <= db_in;
							when "1101" => pc2board(111 downto 104) <= db_in;
							when "1110" => pc2board(119 downto 112) <= db_in;
							when "1111" => pc2board(127 downto 120) <= db_in;
							when others => pc2board(7 downto 0) <= db_in;
						end case;
					if (IntR = '1') then
						cs <= '1'; rd <= '1'; wr <= '1'; -- data read
						cmpt_frame := cmpt_frame + 1;
						if cmpt_frame < 6 then
							state <= idle;
						else
							cmpt_frame := 0;
							state <= send_ack;
						end if;
					end if;
					
				when send_ack =>
					regAddr <= "11111"; -- Actualy the exchanges only used the 64 first bits
					ctrl <= "11111111"; -- everything is good
					state <= sendByte;
				
				when sendByte =>
					-- to know if the UART is ready to send
					-- the control register is tested
					cs <= '0'; rd <= '0'; wr <= '1'; -- UART's registers set to read data...
					addr <= "01"; -- ...on the control register
					if db_in(3) = '1' then -- ready to send
						cs <= '0'; rd <= '1'; wr <= '0'; -- UART read input (ie db_out)
						addr <= "00";
						state <= endSending;
					end if;
				
				when endSending =>
					cs <= '1'; rd <= '1'; wr <= '1'; -- UART return to idle
					state <= idle;

				end case;
			end if;
	end process;

end synthesis ;