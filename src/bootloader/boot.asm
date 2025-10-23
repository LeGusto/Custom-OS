ORG 0x7C00 ; offsets to OS memory location
BITS 16 ; register width

; CR + LF, moves cursor to beginning + moves cursor down one line
%define endl 0x0D, 0x0A

start:
    jmp main

puts:
    ; save values to stack
    PUSH si
    PUSH ax 

.loop:
    LODSB ; sets al = [DS:SI], then increments SI. LODSB loads a singly byte to al, which is the lower half of ax, and each character is 1 byte
    OR al, al ; checks if the current byte is a terminate char (null), because it sets the Z flag to 1 when the result is 0
    JZ .done ; jumps to .done when Z flag is 1

    MOV bh, 0x0 ; set page number
    MOV ah, 0x0E ; write in TTY mode service from the video interrupt (essentially prints al at cursor, moves cursor)
    INT 10h ; trigger video interrupt

    JMP .loop


.done:
    ; return the values from the stack
    POP ax
    POP si
    ret

main:

    ; set data segments to beginning
    MOV ax, 0 ; cannot write 0 directly to ds, es
    MOV ds, ax
    MOV es, ax

    ; set stack to beginning (grows downwards + PUSH first decrements, so won't overwrite)
    MOV ss, ax
    MOV sp, 0x7C00

    MOV si, msg
    CALL puts

    ; immediatelly stop the CPU
    HLT

; failsafe in case HLT doesn't work to prevent reading random memory
.halt:
    JMP .halt


msg db 'LESS GOOOOOOOO!', endl, 0

; pads OS program with 0s
TIMES 510-($-$$) DB 0

; insert 2 byte code
DW 0xAA55
