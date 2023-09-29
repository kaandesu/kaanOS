[org 0x7c00]
mov ah, 0x0e
mov bx, welcomeString

printWelcomeString:
	mov al, [bx]
	cmp al, 0
	je end
	int 0x10
	inc bx
	jmp printWelcomeString
end:

getInput:
	mov bx, buffer
	inputLoop:
	mov ah, 0
	int 0x16
	cmp al, 0x0D
	je new_line
	mov ah, 0x0e
	int 0x10
	mov [bx], al
	inc bx
	jmp inputLoop

new_line:
	mov ah, 0x0e ; Enter writing mode
	mov al, 13
	int 0x10
	mov al, 10
	int 0x10

printBuffer:
	mov bx, buffer
	bufferLoop:
	mov al, [bx]
	cmp al, 0
	je endPrint
	int 0x10
	inc bx
	jmp bufferLoop
endPrint:



welcomeString:
	db "Welcome to kaanOS!", 0

buffer:
	times 10 db 0

jmp $
times 510-($-$$) db 0
db 0x55, 0xaa

