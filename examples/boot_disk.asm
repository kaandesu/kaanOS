[org 0x7c00]
mov [BOOT_DISK], dl ; after boot drive number stored in dl (where booted) 

; setting up the stack
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, 0x7e00

; reading the disk

mov ah, 2 ;  
mov al, 1 ; num of sectors we want to read
mov ch, 0 ; cylinder number
mov dh, 0 ; head number
mov cl, 2 ; sector number
mov dl, [BOOT_DISK] ; drive number that we saved in a var
; es:bs = 0x7e00
; es: extra segment
; es * 16 + bx = 0x7e00
; so we did -> mov bx, 0x7e00
int 0x13

; Failure detection
jnc disk_read_success ; checking if the carry flag is high
mov bx, FAIL_MESSAGE_CARRY
call printError
disk_read_success:
cmp al, 1
je correct_sector_success
mov bx, FAIL_MESSAGE_SEC_NUM
call printError
correct_sector_success:




jmp $  
printError:
	mov ah, 0x0e
	printLoop:
		mov al, [bx]
		cmp al, 0
		je exitPrint
		int 0x10
		inc bx
		jmp printLoop
	exitPrint:
	mov al, 0x0D
	ret
	

BOOT_DISK: db 0
FAIL_MESSAGE_CARRY: db "Failure: carry flag (cf) is high!",0 
FAIL_MESSAGE_SEC_NUM: db "Failure: wrong number of sectors to read!", 0

; padding 

times 510-($-$$) db 0
dw 0xaa55

; filling the second sector (one that will be readed) with 'K's
times 512 db 'K'

