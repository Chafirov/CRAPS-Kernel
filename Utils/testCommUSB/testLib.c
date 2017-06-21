#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "serialComm.h"

#define DEBUG 
#define NB_LOOPS 10*1000

int main(int argc, char ** argv){	
	int fd = initSerialComm("/dev/ttyUSB1");
	unsigned char readData;

	for (int j = 0; j < NB_LOOPS; j++){
		#ifdef DEBUG
		printf("%i\n", j);
		#endif
		for (int i = 0; i < 8; i++){
			writeByte(i, i*10, fd);
		}
		
		for (int i = 0; i < 8; i++){
			readData = readByte(i, fd);
			if (readData != i*10){
				printf("erreur loop %i, addr %i : lu %i\n", j, i, readData);
				return 0;
			}
		}
	
	}
	return 0;
}
