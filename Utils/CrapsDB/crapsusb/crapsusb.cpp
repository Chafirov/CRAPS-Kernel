#include <jni.h>

#include "org_mmek_craps_crapsusb_CommThread.h"
#include <iostream>
#include <cstring>


#include <dirent.h> 
#include <errno.h>
#include <fcntl.h> 
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define ONE_MS 1000 // one milisecond in microsecond
#define DELAY 10*ONE_MS

#ifdef DEBUG
    #include <stdio.h>
#endif

#define MAX_DATA_SIZE 100

int cmpt_frame = 0;
unsigned char sendedBytes[2*6];
pthread_mutex_t mutex; //mutex for read and write
void writeByteC(unsigned char addr, unsigned char byte, int fd);

// transform a byte MSB->LSB in a byte LSB->MSB
unsigned char reverse (unsigned char byte){
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
                perror("error from tcgetattr");
                return -1;
        }

        cfsetospeed (&tty, speed);
        cfsetispeed (&tty, speed);

        tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
        // disable IGNBRK for mismatched speed tests; otherwise receive break
        // as \000 chars
        tty.c_iflag &= ~IGNBRK;         // disable break processing
        tty.c_lflag = 0;                // no signaling chars, no echo,
                                        // no canonical processing
        tty.c_oflag = 0;                // no remapping, no delays
        tty.c_cc[VMIN]  = 0;            // read doesn't block
        tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

        tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

        tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
                                        // enable reading
        tty.c_cflag &= ~(PARENB | PARODD);      // shut off parity
        tty.c_cflag &= ~CSTOPB;

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
        {
                perror("error from tcsetattr");
                return -1;
        }
        return 0;
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    init
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_org_mmek_craps_crapsusb_CommThread_init(JNIEnv *, jclass) {
        return 0; // Useless with nexys4
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    getDeviceAliases
 * Signature: ()Ljava/util/List;
 */
JNIEXPORT jobject JNICALL Java_org_mmek_craps_crapsusb_CommThread_getDeviceAliases(JNIEnv* env, jclass) {
	jclass arrayList = env->FindClass("java/util/ArrayList");
    if(arrayList == NULL) return NULL;

    jmethodID arrayListInit = env->GetMethodID(arrayList, "<init>", "()V");
    if(arrayListInit == NULL) return NULL;

    jobject result = env->NewObject(arrayList, arrayListInit);
    if(result == NULL) return NULL;

    jmethodID arrayListAdd = env->GetMethodID(arrayList, "add", "(Ljava/lang/Object;)Z");
    if(arrayListAdd == NULL) return NULL;


	DIR           *d;
	struct dirent *dir;

	d = opendir("/dev");

	if (d)
	{
	  while ((dir = readdir(d)) != NULL)
	  {
		if(strncmp(dir->d_name, "ttyUSB", 6) == 0){
			char fileName[50] = "/dev/";	
			strncat(fileName, dir->d_name, 20);

			jstring jalias = env->NewStringUTF(fileName);
			if(jalias == NULL) return NULL;
		    
			jboolean jbool = env->CallBooleanMethod(result, arrayListAdd, jalias);
			if(!jbool) return NULL;

		}
	  }

	  closedir(d);
	}


    
    return result;
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    openData
 * Signature: (Ljava/lang/String;)J
 */
JNIEXPORT jint JNICALL Java_org_mmek_craps_crapsusb_CommThread_openData(JNIEnv* env, jclass, jstring jalias) {
    const char *c_alias = env->GetStringUTFChars(jalias, 0);
    char alias[1001];
    strncpy(alias, c_alias, 1000);

    int fd = open (alias, O_RDWR | O_NOCTTY | O_SYNC);
    
    if (fd < 0)
    {
    	perror("Open failed\n");
    	return -1;
    }
    
    set_interface_attribs (fd, B115200);  // set speed to 19,200 bps, 8E1
    return (jint)fd;
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    closeData
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_org_mmek_craps_crapsusb_CommThread_closeData(JNIEnv *, jclass, jint fd) {
    close((int)fd);
    return 0;
}

void secureWrite(int fd, unsigned char byte){

	write(fd, &byte, 1);
}

void resend(int fd){
	#ifdef DEBUG
	printf("------Resend--------\n");
	#endif
	int ack = 0;

	do {
		for (int iByte = 0; iByte < 6; iByte++){
			secureWrite(fd, sendedBytes[2*iByte]);     // the addresse byte
			secureWrite(fd, sendedBytes[2*iByte + 1]); // the data byte
		}
		usleep(ONE_MS); // Waiting for ack
	} while (read(fd, &ack, 1) != 1 && ack != 255); // 6 bytes were emitted, so we are looking at the ack.
	#ifdef DEBUG
	printf("------End Resend----\n");
	#endif 
}

void writeByteC(unsigned char addr, unsigned char byte, int fd){
    pthread_mutex_lock(&mutex);
    addr &= 0x0F;

    secureWrite((int)fd, addr);
    secureWrite((int)fd, byte);

	#ifdef DEBUG
    	printf("%i wrote at addr %i\n", byte, addr);
	#endif
    
//    	sendedBytes[2*cmpt_frame] = addr;
//	sendedBytes[2*cmpt_frame + 1] = byte;
//	cmpt_frame ++;
//
//	if (cmpt_frame == 6){
//		unsigned char ctrl;
//		int rd = 0;
//		int i_ms = 0;
//		while (rd == 0 && i_ms < 100){
//			i_ms ++;
//			rd = read(fd, &ctrl, 1);
//			usleep(ONE_MS);
//		}
//		if (rd == 0 || ctrl != 255)
//			resend(fd);
//		#ifdef DEBUG
//		else {
//			printf("Ack : OK\n");
//		}
//		#endif
//		cmpt_frame = 0;
//	}
	pthread_mutex_unlock(&mutex);
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    writeByte
 * Signature: (JII)I
 */
JNIEXPORT jint JNICALL Java_org_mmek_craps_crapsusb_CommThread_writeByte(JNIEnv *, jclass, jint fd, jint num, jint data) {
	writeByteC((unsigned char) num, (unsigned char) data, (int) fd);
        return 0;
}

/*
 * Class:     org_mmek_craps_crapsusb_CommThread
 * Method:    readByte
 * Signature: (JI)I
 */
JNIEXPORT jint JNICALL Java_org_mmek_craps_crapsusb_CommThread_readByte(JNIEnv *, jclass, jint fd, jint num) {
	pthread_mutex_lock(&mutex);
	unsigned char addr = (unsigned char)num; // because lsb have to be on the left
    unsigned char data;
    int nbRead = 0;

    addr &= 0x0F; // only the 4 LSB are send as addr
    // tell the board witch addr we want to read
    addr |= (1 << 4); // tell the board we want to read

    while (nbRead != 1){
        secureWrite((int)fd, addr);
   
        #ifdef DEBUG
        printf("Trying to read at addr %i\n", (unsigned char)num);
        #endif
 
        //read data from the board
        nbRead = read((int)fd, &data, 1);
    }

#ifdef DEBUG
    printf("Read %i at addr %i\n", data, (unsigned char) num);
#endif
 
	pthread_mutex_unlock(&mutex);
    return ((jint) data);
}
