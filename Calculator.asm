org 100h

#start=Emulation_Kit.exe#  
main:
    call printMsg1
    
    mov dx, 2040h     
    mov cx, 0
    takeFirst:
        mov ah, 1     
        int 21h 
        
        cmp al, 0Dh   
        je skipFirst
        
        out dx, al        
        inc dx            
        
        sub al, 30h       
        mov ah, 0         
        push ax           
        
        inc cx            
        jmp takeFirst
        
    skipFirst:
        mov dx, 0h        
        pop ax            
        add dx, ax        
        cmp cx, 1         
        je saveFirst
        
        pop ax            
        mov bx, ax        
        mov ax, 10
        push dx
        mul bx
        pop dx
        add dx, ax            
        cmp cx, 2             
        je saveFirst
        
        pop ax
        mov bx, ax
        mov ax, 100           
        push dx
        mul bx 
        pop dx
        add dx, ax
         
        saveFirst:
            push dx           
    
        call setNewline
    
        call printMsg2
        
        mov cx, 0
        mov dx, 2044h
    takeSecond:
        mov ah, 1
        int 21h
        
        cmp al, 0Dh
        je skipSecond
        
        out dx, al
        inc dx
        
        sub al, 30h
        mov ah, 0
        push ax
        
        inc cx
        
        jmp takeSecond
        
    skipSecond:
        mov dx, 0
        pop ax
        add dx, ax
        cmp cx, 1
        je saveSecond
        
        pop ax
        mov bx, ax
        mov ax, 10
        push dx
        mul bx
        pop dx
        add dx, ax
        cmp cx, 2
        je saveSecond
        
        pop ax
        mov bx, ax
        mov ax, 100
        push dx
        mul bx 
        pop dx
        add dx, ax
         
        saveSecond:
            push dx
    
        mov al, 3dh     
        mov dx, 2047h   
        out dx, al
        
        call setNewline
        call printMsg3
   
    
    takeOperators:
        mov dx, 2043h 
        mov ah, 1     
        int 21h
        
        cmp al, 2bh
        je goPlus
        
        cmp al, 2dh
        je goMinus 
        
        cmp al, 2ah
        je goMulti
        
        cmp al, 2fh
        je goDiv
                   
        call setNewline
    
        call printMsg3
    jmp takeOperators       
        
        
goMulti:
    out dx, al      
    pop ax          
    pop bx          
    
    mul bx          
    
    push ax
    jmp convert

goPlus:
    out dx, al      
    pop ax          
    pop bx          
    
    add ax, bx      
    
    push ax
    jmp convert
    
goMinus:
    out dx, al      
    pop ax          
    pop bx          
    
    sub bx, ax      
    
    push bx
    jmp convert

goDiv:
    out dx, al      
    pop bx          
    pop ax          
    
    div bl          
    
    push ax
    jmp convert
        
convert:
    
    pop ax             
    mov bx, 0
    mov cx, 0
    mov dx, 0
    
    cmp ax, 9
    jb writeResultLCD 
    
    onesDigit:
    
        sub ax, 10        
        inc bx            
        cmp ax, 9
        jb tensDigit
        jmp onesDigit
    
    tensDigit:
    
        cmp bx, 10            
        jb hundrendsDigit     
        sub bx, 10
        inc cx
        jmp tensDigit
        
    hundrendsDigit:
    
        cmp cx, 10            
        jb writeResultLCD     
        sub cx, 10
        inc dx
        jmp hundrendsDigit
    
writeResultLCD:

    push ax
    mov ax, dx
    mov dx, 2048h
    add al, 30h
    out dx, al
    
    inc dx
    mov ax, cx                       
    add al, 30h                      
    out dx, al
    
    inc dx
    mov ax, bx
    add al, 30h
    out dx, al
    
    inc dx
    pop ax
    add al, 30h
    out dx, al         

ret

msg1 DB 'Enter first operand: '   ;21
msg2 DB 'Enter second operand: '  ;22
msg3 DB 'Enter operator: '        ;16
invalid DB 'Unknown operator.'    ;17
linefeed DB 13, 10 


proc setNewline 
    mov ah, 0eh
    lea si, linefeed
    mov cx,2
    printNewLine:
    lodsb
    int 10h
    loop printNewLine:
    ret
setNewline endp


proc printMsg1
    lea si,msg1
    mov ah,0eh
    mov cx,21
    print1:
        lodsb
        int 10h
    loop print1            
              
ret
printMsg1 endp

proc printMsg2
    lea si,msg2
    mov ah,0eh
    mov cx,22
    print2:
        lodsb
        int 10h
    loop print2            
              
ret
printMsg2 endp

proc printMsg3
    lea si,msg3
    mov ah,0eh
    mov cx,16
    print3:
        lodsb
        int 10h
    loop print3            
              
ret
printMsg3 endp