ORG 0x7C00 // offsets to OS memory location
BITS 16 // register width

main:
    HLT // immediatelly stop the CPU

.halt // failsafe in case HLT doesn't work to prevent reading random memory
    JMP .halt

TIMES 500-($-$$) DB 0
DW 0AA55h
