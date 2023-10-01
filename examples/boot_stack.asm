[org 0x7c00]
; bp: base pointer, sp: stack pointer

mov bp, 0x8000; example value for a base
mov sp, bp
mov bh, 'A'
push bx

mov bh, 'B'
;print bh
mov ah, 0x0e
mov al, bh
int 0x10




jmp $
times 510-($-$$) db 0
db 0x55, 0xaa

