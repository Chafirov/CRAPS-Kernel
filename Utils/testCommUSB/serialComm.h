#ifndef SERIALCOMM_H
#define SERIALCOMM_H

    unsigned char reverse(unsigned char byte);
    int initSerialComm(char* portname);
    void writeByte(unsigned char addr, unsigned char byte, int fd);
    unsigned char readByte(unsigned char addr, int fd);

#endif
