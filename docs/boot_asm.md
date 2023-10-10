# Assembly Code Explenation

This assembly code is intended to boot a system, set up a stack, read a disk sector, and transition to 32-bit protected mode. It also defines a Global Descriptor Table (GDT) with code and data segment descriptors.

## Instructions

The assembly code begins by specifying the origin at memory address `0x7c00` and moves the boot drive number into memory at `BOOT_DISK`. It then sets up a stack and reads a disk sector using BIOS interrupt `int 0x13`.

```assembly
[org 0x7c00]
mov [BOOT_DISK], dl ; Save the boot drive number

; setting up the stack
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

; Reading the disk
mov ah, 2
mov al, 1
mov ch, 0
mov dh, 0
mov cl, 2
mov dl, [BOOT_DISK]
int 0x13

; Failure detection
jnc disk_read_success
mov bx, FAIL_MESSAGE_CARRY
call printError
disk_read_success:
cmp al, 1
je correct_sector_success
mov bx, FAIL_MESSAGE_SEC_NUM
call printError
correct_sector_success:
```

## Setting up the constraints

Constants for code and data segment descriptors are set up using the equ directive, calculating the offsets from the GDT_Start label.

```assembly
CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start
```

## Initializing GDT

The GDT is defined with null, code, and data segment descriptors. The lgdt instruction is used to load the GDT, enabling 32-bit protected mode.

```assembly
cli ; Disable all interrupt actions (for some 8088 bug)
lgdt [GDT_Descriptor] ; Loading the GDT
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode
jmp $
%include './utils/print_function.asm'

```

## GDT Sturcture

The GDT consists of null, code, and data segment descriptors. Each descriptor is structured with base, limit, and flag information.

```assembly
GDT_Start:
    null_descriptor:
        ; Null descriptor
        dd 0x0 ; Four times 00000000
        dd 0x0 ; Four times 00000000

    code_descriptor:
        ; Code Segment Descriptor
        dw 0xffff ; Define first 16 bits of limit (first four 'f')
        dw 0x0 ; 16 bits +
        db 0x0 ; 8 bits = 24
        db 0b10011010 ; Pres, priv, type properties
        db 0b11001111 ; Other + last four bits of limit (the missing f)
        db 0x0 ; Last 8 bits of the base

    data_descriptor:
        ; Data Segment Descriptor
        dw 0xffff
        dw 0x0
        dw 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; Size
    dd GDT_Start

```

## Protected Mode Execution

The start_protected_mode label marks the entry point for code execution in protected mode, showcasing how to print a character to the screen by accessing video memory.

```assembly
[bits 32]
start_protected_mode:
    ; Protected mode code here
    ; How to print a character:
    ; videoMemory = 0xb8000
    ; first byte = character
    ; second byte = color
    mov al, 'A'
    mov ah, 0x0f ; White on black
    mov [0xb8000], ax ; Move ax to videoMemory
    jmp $

```

## Booting

The boot code ensures that the last two bytes of the boot sector are set to 0x55 and 0xaa to indicate a valid bootable sector.

```assembly
BOOT_DISK: db 0
FAIL_MESSAGE_CARRY: db "Failure: carry flag (cf) is high!",0
FAIL_MESSAGE_SEC_NUM: db "Failure: wrong number of sectors to read!", 0

times 510-($-$$) db 0
db 0x55, 0xaa

; Filling the second sector (one that will be read) with 'K's
times 512 db 'K'

```

---

# Some Theory

### Overview

This assembly code is written to serve as a bootloader, a program that loads the operating system into memory and transfers control to it. The code initializes necessary data structures, reads a disk sector, and transitions to 32-bit protected mode for further execution.

### Boot Procedure

1. **Origin Address**: The code starts at memory address `0x7c00`, a standard boot sector location.
2. **Boot Disk Information**: The boot drive number is obtained from the BIOS and stored in `dl`. This information is essential for disk access.
3. **Stack Setup**: The stack is set up to facilitate program execution and memory management.
4. **Disk Reading**: A disk sector is read using BIOS interrupt `int 0x13`, ensuring the appropriate sector is loaded into memory.
5. **Error Handling**: Error detection and handling are incorporated to manage failures during the disk reading process.
6. **GDT Initialization**: The Global Descriptor Table (GDT) is defined, loaded, and enables 32-bit protected mode.
7. **Transition to Protected Mode**: The code transitions to protected mode, allowing execution of code beyond the 1 MB memory limit of real mode.
8. **Protected Mode Execution**: Code execution continues in protected mode, demonstrating basic character printing on the screen.

### Global Descriptor Table (GDT)

The GDT is a data structure used by the x86 architecture to define memory segments. It contains entries that describe the attributes and location of memory segments, including code and data segments. Each entry provides information such as base address, limit, access privileges, and segment type.

- **Null Descriptor**: A descriptor with all zero values, typically used for alignment or placeholders.
- **Code Segment Descriptor**: Describes a code segment with specific access privileges and characteristics.
- **Data Segment Descriptor**: Describes a data segment with specific access privileges and characteristics.

### Protected Mode Execution

Once in protected mode, the program has access to the full 32-bit address space and can utilize features like virtual memory, memory protection, and multitasking. The example provided in the code demonstrates how to print a character to the screen by accessing video memory.

### Boot Sector Compliance

The boot sector ends with a standard boot signature `0x55, 0xaa`, indicating that the sector is bootable according to the BIOS boot process.

This README provides an overview of the assembly code, explaining its purpose, key components, and theoretical concepts involved in its operation.
