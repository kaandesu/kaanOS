NASM=nasm
QEMU=qemu-system-x86_64
DEFAULT_ASM_FILE=boot.asm
ASM_FILE ?= $(DEFAULT_ASM_FILE)
BIN_FILE=run.bin

all: $(BIN_FILE) run

$(BIN_FILE): clean $(ASM_FILE)
	$(NASM) -f bin $(ASM_FILE) -o $(BIN_FILE)

run: $(BIN_FILE)
	$(QEMU) $(BIN_FILE)

clean:
	rm -f $(BIN_FILE)


