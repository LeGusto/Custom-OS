# Custom OS

A custom 16-b x86 OS.

## Start instructions

# Build the OS
```bash
make clean
make
```

# Start the OS

qemu example:
```bash
qemu-system-i386 -fda build/main_floppy.img
```