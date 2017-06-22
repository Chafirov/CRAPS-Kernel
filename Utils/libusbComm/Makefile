all: libcrapsusb.so

SERIAL_LIB_DIR = $(PWD) 
JAVA_INCLUDE_DIR = /usr/lib/jvm/java-7-openjdk-amd64/include

libcrapsusb.so: crapsusb.o 
	g++ -shared -o libcrapsusb.so crapsusb.o

crapsusb.o: crapsusb.cpp 
	g++ -c -fPIC -Wall -I$(JAVA_INCLUDE_DIR) -I$(JAVA_INCLUDE_DIR)/linux crapsusb.cpp

clean:
	rm -f *.o *.so
