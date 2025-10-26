# Custom OS

A custom x86 OS from scratch.

# Start instructions

## Build the OS
```bash
make clean
make
```

## Start the OS

qemu example:
```bash
qemu-system-i386 -fda build/main_floppy.img
```
