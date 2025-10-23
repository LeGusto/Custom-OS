ASM = nasm

SRC_DIR = src
BUILD_DIR = build

.PHONY: all floppy_disk bootloader kernel always clean

all: floppy_disk

# floppy disk image
floppy_disk: $(BUILD_DIR)/main_floppy.img

# put binary file into image, extend image to 1.44MB
$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/bootloader.bin bootloader kernel
# create a virtual floppy disk image with 2880 sectors containing 512 bytes
# /dev/zero is an input file with many zeroes, fills the image with 0s
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
# create a fat (file allocation table) filesystem where each 
# -F 12 means that each fat entry has 12 bits available, so it store every sector as an entry
# -n is just a volume name
	mkfs.fat -F 12 -n "CustomOS" $(BUILD_DIR)/main_floppy.img
# copies over bootloader to the floppy image, prevents trunctation (removing suffix of unused space after dd)
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
# mcopy is used to copy to unmounted systems while respecting the filesystem, so it automatically
# copies over kernel to fat
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "kernel.bin"



bootloader: $(BUILD_DIR)/bootloader.bin

# compile assembly in binary
$(BUILD_DIR)/bootloader.bin: $(SRC_DIR)/bootloader/boot.asm always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin


kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: $(SRC_DIR)/kernel/kernel.asm always
	$(ASM) $(SRC_DIR)/kernel/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin

always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
