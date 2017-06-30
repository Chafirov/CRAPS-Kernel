# Run crapsdb and load the kernel

## About
Here are many tools to interact with the CRAPS (ones it is load on the Nexys 4) :

- crapsdb  : allows you to load an OS on the CRAPS an to debug your programs
- serialsh : to communicate with the shell ones the OS is loaded and to run programs on it
- crapsc   : To compile your assembly code to bytecode
- commUSB  : ...
- CrapsMon : ...
- graph    : ...

## Compilation
In order to compile all these tools, check the Makefiles to be sure that the Java path is well configured.
Next run: make clean && make 

## How to load the kernel
Let's assume that you have [generated the kernel.asm file](../Kernel/README.md) and the [the CRAPS is configured on the board](../Processor/README.md)
- First you need to generate the .obj file :
```
./crapsc ../Kernel/kernel.asm
```

- Next load the kernel with :
```
./crapsdb ../Kernel/kernel.obj
```
