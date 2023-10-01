[org 0x7c00]
mov ah, 0x0e
mov bx, myString

printMyString:
	mov al, [bx]
	cmp al, 0
	je exit
	int 0x10
	inc bx
	jmp printMyString

exit:


mov al, 0x0A
int 0x10
int 0x10
int 0x10

mov al, 'K'
int 0x10

mov ah, 0
int 0x16


mov ah, 0x0e
int 0x10

jmp $

myString:
	db "Welcome to kaanOS!",0

times 510-($-$$) db 0
dw 0xaa55

