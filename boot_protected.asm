[org 0x7c00]
; Code Segment Descriptor
; Present = 1 for used segments
; Privilage = 00 | 01 | 10 | 11 (00 is highest)
; Type = 1 if code OR data seg.

; Flags: 0/1
; Sets of flags:
; - Type flags (4 bits)
; - Other flags (4 bits)

; Type flags = 1010
; a) Code? yes, thus: 1
; b) Conforming: can this code, executed from lower priv segs? no=0 
; c) Readable? 1 to read constants
; d) Accessed: is CPU using the segment? 1 : 0
; a2) if NOT code, but Data => 0
; b2) direction = 0 (when 1 segment becomes expend down segment)
; c2) Writable? 1 (0 if read only)

; Other flags  = 1100
; Granulatiy 1 => limit *= 0x1000 (so very high limit)
; 32 bits ? 1 : 0 

; db: defines bytes
; dw: defines words
; dd: defines double words

GDT_Start:
	null_descriptor:
		dd 0 ; four times 00000000
		dd 0 ; four times 00000000
	code_descriptor:
		; define first 16 bits of limit
		; base: 0 (32 bit)
		; pres, priv, type = 1001
		; type flags = 1010
		; other flags = 1100
		dw 0xffff
		dw 0 ; 16 bits +
		db 0 ; 8 bits = 24
		db 10011010
		; p,p,t, Type flags
		db 11001111
		; other + limit (last four bits)


jmp $
times 510-($-$$) db 0
db 0x55, 0xaa

