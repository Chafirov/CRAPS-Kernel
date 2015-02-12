package org.mmek.craps.crapsdb;

import org.jcb.craps.crapsc.java.ObjModule;

import org.mmek.craps.crapsusb.CommException;
import org.mmek.craps.crapsusb.CrapsApi;

public class StatePrinter {
    private CrapsApi api;
    private ObjModule objModule;

    public StatePrinter(CrapsApi api, ObjModule module) {
        this.api = api;
        this.objModule = objModule;
    }

    public void printRegisters() throws CommException {
        System.out.println(title("registers"));

        // first line : %r1..%r5
        for(int i = 1; i <= 5; i++) {
            System.out.print(formatRegister("%r" + i + ":  ", i));
        }
        System.out.println();

        // second line : %r6..%r9 %psr
        for(int i = 6; i <= 9; i++) {
            System.out.print(formatRegister("%r" + i + ":  ", i));
        }

        int psr = (int) api.readRegister(25);
        System.out.print(" " + Colors.GREEN + "%psr: " + Colors.ALL_OFF);

        // flags
        System.out.print(formatFlag(psr, 'N', 128));
        System.out.print(formatFlag(psr, 'Z',  64));
        System.out.print(formatFlag(psr, 'V',  32));
        System.out.print(formatFlag(psr, 'C',  16));

        // int
        System.out.println(psr & 0xf);

        // last line : %brk %fp %ret %sp %pc
        System.out.print(formatRegister("%brk: ", 26));
        System.out.print(formatRegister("%fp:  ", 27));
        System.out.print(formatRegister("%ret: ", 28));
        System.out.print(formatRegister("%sp:  ", 29));
        System.out.print(formatRegister("%pc:  ", 30));
        System.out.println();
    }

    private String formatRegister(String name, int number) throws CommException {
        return
            ' '
          + Colors.GREEN
          + name
          + Colors.ALL_OFF
          + formatHexString(api.readRegister(number))
        ;
    }

    private String formatFlag(int psr, char name, int number) {
        return
            (psr & number) > 0 ? Colors.GREEN : Colors.RED
          + name + ' '
          + Colors.ALL_OFF;
    }

    public void printAssembly() throws CommException {
        System.out.println(title("code"));

        Disassembler disas = new Disassembler(objModule);
        long pc = api.readRegister(30);

        for(long addr = Math.max(0, pc - 3); addr <= pc + 5; addr++) {
            System.out.print(" 0x" + formatHexString(addr) + " | ");

            if (
                objModule != null
            && objModule.getSym(addr) != null
            && !objModule.getSym(addr).isEmpty()
            ) {
                String label = objModule.getSym(addr) + ":";
                if(label.length() > 15) {
                    label = label.substring(0, 13) + ":";
                }
                System.out.print(padRight(label, 15, ' ') + "    ");
            }
            else {
                System.out.print(padRight("",    19, ' ')         );
            }

            if(addr == pc) {
                System.out.print(Colors.GREEN);
            }
            System.out.print(disas.disassemble(addr, api.readMemory(addr)));
            System.out.println(Colors.ALL_OFF);
        }
    }

    public void printStack() throws CommException {
        System.out.println(title("stack"));

        long sp = api.readRegister(29);

        for(long addr = sp; addr <= Math.min(sp + 6, 8192); addr++) {
            System.out.println(
                Colors.BLUE
              + " 0x" + formatHexString(addr)
              + Colors.ALL_OFF
              + " | 0x"
              + formatHexString(api.readMemory(addr))
            );
        }
    }

    public void printEndLine() {
        System.out.println(title(""));
    }

    private String formatHexString(long val) {
        return padLeft(Long.toHexString(val), 8, '0');
    }

    private String padLeft(String s, int length, char c) {
        StringBuilder sb = new StringBuilder();
        sb.append(s);
        while(sb.length() < length) sb.insert(0, c);
        return sb.toString();
    }

    private String padRight(String s, int length, char c) {
        StringBuilder sb = new StringBuilder();
        sb.append(s);
        while(sb.length() < length) sb.append(c);
        return sb.toString();
    }

    private String title(String header) {
        int left = 40 - 1 + header.length()/2;

        return
            Colors.BLUE
          + '['
          + padRight(
                padLeft(header, left, '-'),
                80-2, '-'
            )
          + ']'
          + Colors.ALL_OFF
        ;
    }
}