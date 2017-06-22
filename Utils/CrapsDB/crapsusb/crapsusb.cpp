#include <jni.h>

#include "org_mmek_craps_crapsusb_CommThread.h"
#include <iostream>
#include <cstring>


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
		perror("tcgetattr failed\n");
                return -1;
        }

        cfsetospeed (&tty, speed);
        cfsetispeed (&tty, speed);

        tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
        // disable IGNBRK for mismatched speed tests; otherwise receive break
        // as \000 chars
        tty.c_iflag |= INPCK;           // enable input parity check
        tty.c_iflag |= IGNCR; 
        tty.c_lflag = 0;                // no signaling chars, no echo,
                                        // no canonical processing
        tty.c_oflag = 0;                // no remapping, no delays
        tty.c_cc[VMIN]  = 0;            // read block
        tty.c_cc[VTIME] = 2;            // 0.5 seconds read timeout

        tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
                                        // enable reading
        tty.c_cflag |= PARENB;      // enable parity

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
        {
		perror("tcgetattr failed\n");
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

    jstring jalias = env->NewStringUTF("/dev/ttyUSB1");
    if(jalias == NULL) return NULL;
    
    jboolean jbool = env->CallBooleanMethod(result, arrayListAdd, jalias);
    if(!jbool) return NULL;

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
    
    set_interface_attribs (fd, B19200);  // set speed to 19,200 bps, 8E1
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
	unsigned char reversedByte = reverse(byte);

	write(fd, &reversedByte, 1);
}

void resend(int fd){
	#ifdef DEBUG
	printf("------Resend--------\n");
	#endif
	for (int iByte = 0; iByte < 6; iByte++){
		writeByteC(sendedBytes[2*iByte], sendedBytes[2*iByte+1], fd);
	}
	#ifdef DEBUG
	printf("------End Resend----\n");
	#endif 
}

void writeByteC(unsigned char addr, unsigned char byte, int fd){
    addr &= 0x0F;

    pthread_mutex_lock(&mutex);
    secureWrite((int)fd, addr);
    secureWrite((int)fd, byte);
    pthread_mutex_unlock(&mutex);

	#ifdef DEBUG
    	printf("%i wrote at addr %i\n", byte, addr);
	#endif
    
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
    unsigned char addr = (unsigned char)num; // because lsb have to be on the left
    unsigned char data;
    int nbRead = 0;

    addr &= 0x0F; // only the 4 LSB are send as addr
    // tell the board witch addr we want to read
    addr |= (1 << 4); // tell the board we want to read

    while (nbRead != 1){
        pthread_mutex_lock(&mutex);
        secureWrite((int)fd, addr);
   
        #ifdef DEBUG
        printf("Trying to read at addr %i\n", (unsigned char)num);
        #endif
 
        //read data from the board
        nbRead = read((int)fd, &data, 1); 
        pthread_mutex_unlock(&mutex);
    }
   
    int idata = reverse(data);

#ifdef DEBUG
    printf("Read %i at addr %i\n", idata, (unsigned char) num);
#endif
 
    return ((jint) idata);
}
