library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

-- single-port RAM with synchronous read (read through)

entity rams_read_through4096x32 is
	port (
		clk  : in std_logic ;
		we  : in std_logic ;
		addr  : in std_logic_vector(11 downto 0) ;
		di  : in std_logic_vector(31 downto 0) ;
		do  : out std_logic_vector(31 downto 0)
	) ;
end rams_read_through4096x32 ;

architecture synthesis of rams_read_through4096x32 is
	type ram_type is array (4095 downto 0) of std_logic_vector (31 downto 0) ;
	signal RAM: ram_type ;
	signal read_addr: std_logic_vector(11 downto 0) ;

begin
	process (clk) begin
		if clk'event and clk='1' then
			if we='1' then
				RAM(conv_integer(addr)) <= di ;
			end if ;
			read_addr <= addr ;
		end if ;
	end process ;
	do <= RAM(conv_integer(read_addr)) ;

end synthesis ;
