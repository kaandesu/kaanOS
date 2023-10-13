
; setting up the stack
disk_load:    
    push dx                    
    ; mov bx, 0x7e00 ; 
    
    ; reading the disk
    mov ah, 0x02 ; BIOS read sector function 
    mov al, dh ; num of sectors we want to read
    mov ch, 0x00 ; cylinder number
    mov dh, 0x00 ; head number
    mov cl, 0x02 ; sector number    
    ; es:bs = 0x7e00
    ; es: extra segment
    ; es * 16 + bx = 0x7e00
    ; so we did -> mov bx, 0x7e00
    int 0x13

    ; Failure detection
    jnc disk_read_success ; checking if the carry flag is high
    mov bx, FAIL_MESSAGE_CARRY
    call printString
    disk_read_success:
    pop dx 
    cmp dh, al
    je correct_sector_success
    mov bx, FAIL_MESSAGE_SEC_NUM
    call printString
    correct_sector_success:
    
    
    ret
    

