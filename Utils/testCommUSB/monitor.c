#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "serialComm.h"

// LSB IN FIRST !

int main(int argc, char ** argv){

	if (argc < 3){
		printf("Usage : %s writeAddr data readAddr\n", argv[0]);
		return -1;
	}

	int fd = initSerialComm("/dev/ttyUSB1");
	if (fd == -1){
		printf("Erreur a l'ouverture du fichier\n");
		return -1;
	}
	
	unsigned char writeAddr = atoi(argv[1]); 
	unsigned char writeData = atoi(argv[2]);
	
	if (writeAddr < 16)
		writeByte(writeAddr, writeData, fd);
      	

	unsigned char readAddr = atoi(argv[3]);
	unsigned char data = readByte(readAddr, fd);
    
	printf("Données reçues : %i\n", data);	

	close(fd);

	return 0;
}
