printString:
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

    