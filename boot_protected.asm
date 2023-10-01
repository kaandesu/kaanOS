[org 0x7c00]

mov [BOOT_DISK], dl

; equ is used to set up constants
; defining the offsets
CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start


cli ; disable all interrupt actions (for some 8088 bug)
lgdt[GDT_Descriptor] ; loading the GDT 
; change last of bit of a special 32bit reg cr0 to 1
; to make the actual switch
mov eax, cr0
or eax, 1
mov cr0, eax
; cpu is in 32 bit protected mode

; now, far jump (jump to another segment)

jmp CODE_SEG:start_protected_mode

jmp $

; define protected after real mode

; GDT (Global Descriptor Table)
; Code Segment Descriptor
; Present = 1 for used segments (if segment is being used)
; Privilage = 00 | 01 | 10 | 11 (00 is highest) (segment hierarchy)
; Type = 1 if code OR data seg (0)

; Flags: 0/1 (single bit)
; Sets of flags:
; - Type flags (4 bits)
; - Other flags (4 bits)

; Type flags = 1010
; a) Code? yes, thus: 1
; b) Conforming: can this code, executed from lower priv segs? no=0 
; c) Readable? 1 to read constants
; d) Accessed: is CPU using the segment? 1 : 0 (cpu changes it)
; a2) if NOT code, but Data => 0
; b2) direction = 0 (when 1 segment becomes expend down segment)
; c2) Writable? 1 (0 if read only)

; Other flags  = 1100
; Granulatiy 1 => limit *= 0x1000 (so very high limit)
; 32 bits ? 1 : 0 
; not using the last bits so its set to 00
; ---------------

; These should be defined in certain order for GDT

; db: defines bytes
; dw: defines words
; dd: defines double words

;----------------
; pres, priv type = 1001  [code][not exacutable from low seg][read consts][1]

;-------------------------;
; base: 0 (32 bit) 	  |
; limit: 0xfffff          |
; pres, priv, type = 1001 |
; type flags = 1010	  |
; other flags = 1100	  |
;-------------------------;

GDT_Start:
	null_descriptor:
		dd 0x0 ; four times 00000000
		dd 0x0 ; four times 00000000
	code_descriptor:
		dw 0xffff ; define first 16 bits of limit (first four 'f')
		; then, first 24 bits of the base
		dw 0x0 ; 16 bits +
		db 0x0 ; 8 bits = 24
		; then: pres,priv,type properties
		db 0b10011010
		; other + last four bits of limit (the missing f)
		db 0b11001111
		; and, last 8 bits of the base
		db 0x0
	data_descriptor:
		dw 0xffff
		dw 0x0
		dw 0x0
		db 0b10010010
		db 0b11001111
		db 0x0
GDT_End:

GDT_Descriptor:
	dw GDT_End - GDT_Start - 1 ; size
	dd GDT_Start


[bits 32]
start_protected_mode:
	; protected mode code here
	; how to print a character:
	; videoMemory = 0xb8000
	; first byte = character
	; second byte = color
	mov al, 'A'
	mov ah, 0x0f ; white on black
	mov [0xb8000], ax ; move ax to videoMemory
	jmp $

BOOT_DISK: db 0

times 510-($-$$) db 0
db 0x55, 0xaa

