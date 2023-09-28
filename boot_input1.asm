[org 0x7c00]
mov ah, 0x0e



char:
	db 0
mov ah, 0
int 0x16

mov al, [char]

int 0x10
jmp $

myString:
	db "But the fool on the hill", 0


times 510-($-$$) db 0
dw 0xaa55

