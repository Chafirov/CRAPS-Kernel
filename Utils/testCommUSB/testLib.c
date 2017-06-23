#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>

#include "serialComm.h"

#define ONE_MS 1000 
#define NB_LOOPS 10*1000

void* writing(void*  arg){
	int fd = *((int*)arg);
	int i = 0;
	while(1){
		writeByte(i, i*10, fd);
		usleep(2*ONE_MS);
		i = (i + 1) % 16;
	}	
}

void* reading(void* arg){
	int fd = *((int*)arg);
	int i = 0;
	unsigned char readData;
	while (1){
		readData = readByte(i, fd);
		if (readData != i*10){
			printf("Addr %i : lu %i\n", i, readData);
		}
		usleep(2*ONE_MS);
		i = (i + 1) % 16;
	}
}

int main(int argc, char ** argv){	
	int fd = initSerialComm("/dev/ttyUSB1");

	pthread_t threadReading;
	pthread_t threadWriting;

	pthread_create(&threadReading, NULL, reading, &fd);
	pthread_create(&threadWriting, NULL, writing, &fd);

	pthread_join(threadReading, NULL);
	
	return 0;
}
