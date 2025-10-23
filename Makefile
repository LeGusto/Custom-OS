ASM = nasm

SRC_DIR = src
BUILD_DIR = build

.PHONY: floppy_disk bootloader kernel always clean

# floppy disk image
floppy_disk: $(BUILD_DIR)/main_floppy.img bootloader kernel

# put binary file into image, extend image to 1.44MB
$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/bootloader.bin
	cp $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img 



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
	rm -rf $(BUILD_dIR)
