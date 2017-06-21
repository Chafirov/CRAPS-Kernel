#include <errno.h>
#include <fcntl.h> 
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

#define DEBUG

#define MAX_DATA_SIZE 100
#define ONE_MS 1000 // one ms in us
#define DELAY 1*ONE_MS

int cmpt_frame = 0;
unsigned char sendedBytes[2*6];

void writeByte(unsigned char addr, unsigned char byte, int fd);

// transform a byte MSB->LSB in a byte LSB->MSB
unsigned char reverse(unsigned char byte){
	unsigned char r ;
	r = ((1 << 7) & byte) >> 7;
	r |= ((1 << 6) & byte) >> 5;
	r |= ((1 << 5) & byte) >> 3;
	r |= ((1 << 4) & byte) >> 1;
	r |= ((1 << 3) & byte) << 1;
	r |= ((1 << 2) & byte) << 3;
	r |= ((1 << 1) & byte) << 5;
	r |= ((1 << 0) & byte) << 7;
	
	return r;
}

int set_interface_attribs (int fd, int speed)
{
	struct termios tty;
	memset (&tty, 0, sizeof tty);
	if (tcgetattr (fd, &tty) != 0)
	{
	perror("tcgetattr failed\n");
			return -1;
	}

	cfsetospeed (&tty, speed);
	cfsetispeed (&tty, speed);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;	 // 8-bit chars
	// disable IGNBRK for mismatched speed tests; otherwise receive break
	// as \000 chars
	tty.c_iflag |= INPCK;		   // enable input parity check
	tty.c_iflag |= IGNCR; 
	tty.c_lflag = 0;				// no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;				// no remapping, no delays
	tty.c_cc[VMIN]  = 0;			// read block
	tty.c_cc[VTIME] = 10;			// 0.5 seconds read timeout

	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
									// enable reading
	tty.c_cflag |= PARENB;	  // enable parity

	if (tcsetattr (fd, TCSANOW, &tty) != 0)
	{
	perror("tcsetattr failed\n");
			return -1;
	}
	return 0;
}

int initSerialComm(char* portname){
	int fd = open (portname, O_RDWR | O_NOCTTY | O_SYNC);
	
	if (fd < 0)
	{
		perror("Open failed\n");
		return -1;
	}
	
	set_interface_attribs (fd, B19200);  // set speed to 19,200 bps, 8E1
	return fd;
}



void secureWrite(int fd, unsigned char byte){
	unsigned char reversedByte = reverse(byte);

	write(fd, &reversedByte, 1);
}

void resend(int fd){
	#ifdef DEBUG
	printf("------Resend--------\n");
	#endif
	for (int iByte = 0; iByte < 6; iByte++){
		writeByte(sendedBytes[2*iByte + 1], sendedBytes[2*iByte+1], fd);
	}
	#ifdef DEBUG
	printf("------End Resend----\n"); 
	#endif
}
// /!\ LSB ARE AT THE LEFT !

// send a byte to the board
void writeByte(unsigned char addr, unsigned char byte, int fd){

	#ifdef DEBUG
	printf("%i wrote at addr %i\n", byte, addr);
	#endif

	addr &= 0x0F;

	secureWrite(fd, addr);
	usleep(DELAY);
	secureWrite(fd, byte);
	usleep(DELAY);

	sendedBytes[2*cmpt_frame] = addr;
	sendedBytes[2*cmpt_frame + 1] = byte;
	cmpt_frame ++;

	if (cmpt_frame == 6){
		unsigned char ctrl;
		int rd = 0;
		int i_ms = 0;
		while (rd == 0 && i_ms < 100){
			i_ms ++;
			rd = read(fd, &ctrl, 1);
			usleep(ONE_MS);
		}
		if (rd == 0 || ctrl != 255)
			resend(fd);
		#ifdef DEBUG
		else {
			printf("Ack : OK\n");
		}
		#endif
		cmpt_frame = 0;
	}
}

unsigned char readByte(unsigned char addr, int fd){
	unsigned char data;	
	int nbRead = 0;

	addr &= 0x0F; // only the 4 LSB are send as addr

	// tell the board witch addr we want to read
	addr |= (1 << 4); // tell the board we want to read

	while (nbRead != 1){
		secureWrite(fd, addr);

		//read data from the board
		nbRead = read(fd, &data, 1);
		#ifdef DEBUG
		if (nbRead !=1) printf("Addr retransmission\n");
		#endif

	}

	#ifdef DEBUG
	printf("%i read at addr %i\n", reverse(data), addr &= 0x0F);
	#endif

	return reverse(data);
}

