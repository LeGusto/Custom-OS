## Endianness
Endianness dicatates the byte order for multi-byte values. (strings don't count) 

# Little-endian
Least significant byte is stored at the smallest memory address and increases:
uint16_t num = 0x1234;
0x0 - 0x34
0x1 - 0x12

# Big-endian
Reverse of little-endian:
uint16_t num = 0x1234;
0x0 - 0x12
0x1 - 0x34

