CC = gcc
CFLAGS = -Wall -pedantic -std=c11
OBJ = monitor.o serialComm.o
EXEC = monitor

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

testLib: testLib.o serialComm.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm *.o $(EXEC)
