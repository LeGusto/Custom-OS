# Endianness
Endianness dicatates the byte order for multi-byte values. (strings don't count) 

## Little-endian
Least significant byte is stored at the smallest memory address and increases:
uint16_t num = 0x1234;
0x0 - 0x34
0x1 - 0x12

## Big-endian
Reverse of little-endian:
uint16_t num = 0x1234;
0x0 - 0x12
0x1 - 0x34

# Disk layout
LBA - logical block address
CHS - Cylinder Head Sector schema

To convert LBA to CHS, we use the following schema:
sector = (LBA % S) + 1 (sectors start from 1)
head = (LBA / S) % H
cylinder = (LBA / S) / H

