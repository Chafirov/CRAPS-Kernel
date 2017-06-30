# CRAPS Kernel

This repository holds the code for a CPU and OS kernel for a Nexys4 board.
This project extends a the original one with adding :
- A compatibility to the Nexys4 board
- The possibility to use the rj45 port of the Nexys4 board for Ethernet
communications

## What is it?

This actually is several projects:
- a CPU (called CRAPS), written in VHDL;
- a OS kernel that runs on it, written in a C subset;
- a compiler to compile the C subset to CRAPS assembly;
- a monitor/debugger for the CRAPS processor;
- a shell and several tasks that run in the OS.

The on-board OS can communicate with a computer through a serial port. It can
also use the swiches, buttons and seven-segment display on the board.

## What can it do?

See [this screencast](https://asciinema.org/a/17322) for an example of a shell
session.

## How to
### The processor ([See here for more details](Processor/README.md))
The processor is a CRAPS processor, a RISC processor.

The [processor](Processor/ISE_project/) is written in VHDL.
You can then use Digilent Adept or Xilinx ISE to program the FPGA.

The processor runs CRAPS assembly. You can use [`crapsc`](Utils/crapsc) to
compile CRAPS assembly to CRAPS bytecode.

### The kernel ([See here for more details](Utils/README.md))
The kernel is written in *moc*, a C-like language. We provide a
[compiler](https://github.com/arthaud/moc) to compile it to CRAPS assembly.

The [`compile-craps`](https://github.com/arthaud/moc/blob/craps/compile-craps)
script wraps the compiler with the `cpp` preprocessor.

### The CRAPS debugger
The [`crapsdb`](Utils/crapsdb) program can upload code on the board, start the
operating system  and monitor the CPU state and the memory.
