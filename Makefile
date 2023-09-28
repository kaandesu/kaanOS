NASM=nasm
QEMU=qemu-system-x86_64
DEFAULT_ASM_FILE=boot_input1.asm
ASM_FILE ?= $(DEFAULT_ASM_FILE)
BIN_FILE=run.bin

all: $(BIN_FILE)

$(BIN_FILE): $(ASM_FILE)
	$(NASM) -f bin $(ASM_FILE) -o $(BIN_FILE)

run: $(BIN_FILE)
	$(QEMU) -curses $(BIN_FILE)

clean:
	rm -f $(BIN_FILE)


