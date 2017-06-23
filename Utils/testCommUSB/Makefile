CC = gcc
CFLAGS = -Wall -pedantic -std=c11
EXEC = testLib monitor

all: monitor testLib

monitor: monitor.o serialComm.o
	$(CC) $(CFLAGS) -o $@ $^

testLib: testLib.o serialComm.o
	$(CC) -lpthread $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm *.o $(EXEC)
