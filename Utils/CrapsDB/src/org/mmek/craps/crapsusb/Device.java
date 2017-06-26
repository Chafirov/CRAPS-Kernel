package org.mmek.craps.crapsusb;

public class Device {
    private String alias;
    private int fd;

    public Device(String alias) {
        this.alias = alias;
        fd = -1;
    }

    public String getAlias() {
        return alias;
    }

    public synchronized void open() throws ConnectionFailedException {
        assert fd == -1;
        fd = CommThread.openData(alias);

        if(fd == -1) {
            throw new ConnectionFailedException();
        }
    }

    public synchronized void close() throws ConnectionFailedException {
        assert fd != -1;

        if(CommThread.closeData(fd) == -1) {
            throw new ConnectionFailedException();
        }

        fd = -1;
    }

    public synchronized int writeByte(int num, int data) {
        assert fd != -1;
        return CommThread.writeByte(fd, num, data);
    }

    public synchronized int readByte(int num) {
        assert fd != -1;
        return CommThread.readByte(fd, num);
    }

    public boolean isOpened() {
        return fd != -1;
    }
}
