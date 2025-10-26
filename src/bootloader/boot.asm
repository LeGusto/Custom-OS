ORG 0x7C00 ; offsets to OS memory location
BITS 16 ; register width

#
# FAT12 headers
#

jmp start short
nop ; for alignment, OEM (original equipment manufacturer) and DOS (disk operating system) must be speficied at 0x3

# bpb (BIOS parameter block)
DOS_version:                            DQ 0x73666B6D
version_name:                           DQ 0x7461662E
bytes_per_sector:                       DW 0x0200 ; 512
no_of_sectors_per_cluster:              DB 0x01 ; 1
no_of_reserved_sector:                  DW 0x0001 ; 1 (boot sector)
no_of_FATs_on_storage_media:            DB 0x02 ; 2
no_of_root_directory_entries:           DW 0x00E0 ; 224
total_sectors_in_logical_volume:        DW 0x0B40 ; 2880
media_descriptor_type:                  DB 0xF0 ; 1.44MB floppy 
no_of_sectors_per_FAT:                  DW 0x0009 ; 9, since we need to represent 2880 sectors (2880 entries), and each FAT entry is 1.5 bytes, so (2880 * 1.5) / 512 rounds up to 9
no_of_sectors_per_track:                DW 0x0012 ; 18
no_of_heads_or_sides_on_storage_media:  DW 0x0002 ; 2
no_of_hidden_sectors:                   DW 0000 ; 0
no_of_large_sectors:                    DW 0000 ; 0








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
