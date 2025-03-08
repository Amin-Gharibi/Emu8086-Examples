; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data

initMsg dw 'Enter Numbers Separated By Space (hit Enter when done):$', 0
minMsg dw 'Minimum Number In Entered Array Is: $', 0
maxMsg dw 'Maximum Number In Entered Array Is: $', 0
sortMsg dw 'Sorted Array Is: $', 0
numbers dw 100 dup(?)
count dw 0

.code

; MACROS
showMessage macro message
    push dx
    push ax
    
    mov dx, offset message ; load the address of the message into dx
    mov ah, 09h            ; run function 09h of int 21h to display a string
    int 21h                ; call interrupt
    
    pop ax
    pop dx
endm

showNumber macro num
    local divide, display, positive, end_show
    push ax
    push bx
    push cx
    push dx
    
    mov ax, num     ; number to be displayed
    
    ; check if number is negative
    test ax, 8000h  ; test sign bit (bit 15)
    jz positive
    
    ; if negative, display minus sign and make number positive
    push ax
    mov dl, '-'
    mov ah, 02h
    int 21h
    pop ax
    neg ax          ; make number positive
    
positive:
    mov cx, 0       ; initialize digit counter
    mov bx, 10      ; divisor
    
    ; if number is 0, handle it separately
    cmp ax, 0
    jne divide
    mov dx, 0 
    push dx
    inc cx
    jmp display
    
divide:
    ; exit if number becomes 0
    cmp ax, 0
    je display
    
    mov dx, 0
    div bx          ; divide by 10
    push dx         ; save remainder (digit)
    inc cx          ; count digits
    jmp divide

display:
    ; exit if no more digits
    cmp cx, 0
    je end_show
    
    pop dx          ; get digit
    add dl, 48      ; convert to ASCII
    mov ah, 02h     ; display using INT 21h function 02h
    int 21h
    dec cx
    jmp display

end_show:
    pop dx
    pop cx
    pop bx
    pop ax
endm

                                                     

START:
    showMessage initMsg
    call newLine
    call getNumbers
    call newLine
    showMessage minMsg
    call findMin
    showNumber bx
    call newLine
    showMessage maxMsg
    call findMax
    showNumber bx
    call bubbleSort
    call newLine
    showMessage sortMsg
    call showArray

ret
       
       

; PROCEDURES
newLine proc
    lea dx, new_line
    mov ah, 09h
    int 21h
    
    ret
    new_line db 0Dh, 0Ah, '$'
endp

; this function would get numbers separated by space until user hits enter
getNumbers proc
    push ax
    push bx
    push cx
    push dx
    
    mov si, offset numbers  
      
input_loop:
    ; read a character
    mov ah, 01h
    int 21h
    
    ; check if enter key is pressed
    cmp al, 13
    je store_last_number
    
    ; check if space is entered
    cmp al, 32
    je store_number
    
    ; check if minus sign
    cmp al, '-'
    je set_negative
    
    ; convert ASCII to number
    sub al, 48           ; 48 is the ASCII code of 0 so when we subtract the ASCII code from 48 the result is a number between 0 to 9
    
    ; if number has multiple digits then multiply existing number by 10 and add new digit
    mov cl, al           ; save input digit which is in al to cl
    mov ch, 0            ; empty the higher byte of cx so we make sure there is only al in cx
    
    mov ax, number       ; move current number to ax
    mov dx, 10
    mul dx               ; multiply by 10
    mov number, ax       ; store result back
    
    add number, cx       ; add new digit
    
    jmp input_loop  
    
set_negative:
    mov isNegative, 1    ; set negative flag
    jmp input_loop
    
store_number:
    mov ax, number
    cmp isNegative, 1    ; check if number should be negative
    jne skip_negative
    neg ax               ; make number negative
    
skip_negative:
    mov [si], ax
    add si, 2
    inc count
    mov number, 0        ; reset number
    mov isNegative, 0    ; reset negative flag
    jmp input_loop
    
store_last_number:
    ; store the last number
    mov ax, number
    cmp isNegative, 1      ; check if last number should be negative
    jne skip_last_negative
    neg ax                 ; make last number negative
    
skip_last_negative:
    mov [si], ax
    inc count
    
end_input:
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
    number dw 0
    isNegative dw 0
endp


findMin proc
    push ax
    push cx
    push si
    
    mov si, offset numbers
    mov ax, [si]        ; get first number
    mov min, ax         ; store first number in min variable as initial value
    
    mov cx, count       ; number of elements to check
    dec cx              ; subtract by 1 since we already got first number
    add si, 2           ; move to second number
    
    cmp cx, 0           ; if only one number, skip loop
    je done_finding_min
    
find_min_loop:
    mov ax, [si]        ; get current number
    cmp ax, min         ; compare with current minimum
    jge skip_min        ; if greater or equal, skip
    mov min, ax         ; if less, update minimum
skip_min:
    add si, 2           ; move to next number
    loop find_min_loop
        
done_finding_min:
    mov bx, min         ; put result in bx for return
    
    pop si
    pop cx
    pop ax
    ret
    min dw 0
endp 


findMax proc
    push ax
    push cx
    push si
    
    mov si, offset numbers
    mov ax, [si]        ; get first number
    mov max, ax         ; store first number in min variable as initial value
    
    mov cx, count       ; number of elements to check
    dec cx              ; subtract by 1 since we already got first number
    add si, 2           ; move to second number
    
    cmp cx, 0           ; if only one number, skip loop
    je done_finding_max
    
find_max_loop:
    mov ax, [si]        ; get current number
    cmp ax, max         ; compare with current minimum
    jle skip_max        ; if less or equal, skip
    mov max, ax         ; if greater, update minimum
skip_max:
    add si, 2           ; move to next number
    loop find_max_loop
        
done_finding_max:
    mov bx, max         ; put result in bx for return
    
    pop si
    pop cx
    pop ax
    ret
    max dw 0
endp


bubbleSort proc
    ; bp = first_pointer
    ; si = second_pointer
    ; di = max_pointer
    mov bp, 0
    mov si, 0
    mov di, 0
    
    mov cx, count          ; how many times should the outer loop run
    lea bp, numbers        
    ; find last indexes address
    mov ax, count
    mov dx, 2
    mul dx
    add ax, bp
    mov di, ax             ; store last indexes addres
    
    outer_loop:
        lea bp, numbers    ; store first indexes address
        mov si, bp         
        add si, 2          ; store second indexes address
         
        inner_loop:
        cmp di, si         ; compare address of max pointer with second pointer and if its less then the inner loop is done
        jle inner_done     
                           
        mov ax, [bp]
        cmp ax, [si]       ; compare first and second indexes values
        jl move_pointers   ; if the first one was less than the second one then move pointer one step
        ; otherwise swap values
        mov ax, [bp]
        mov bx, [si]
        mov [bp], bx
        mov [si], ax
        
        move_pointers:
        add bp, 2          ; move pointers one step
        add si, 2          ; move pointers one step
        jmp inner_loop
        
        
        inner_done:        ; when the inner loop is done then the last element is sorted so subtract max pointer by 2
        sub di, 2
        
    
    loop outer_loop        ; loop outer_loop (count) times
    
    ret
endp   

showArray proc
    
    mov cx, count
    lea si, numbers   ; store starting address of numbers
    
    show:
    showNumber [si]   ; show the number
    showMessage space ; show space between numbers
    add si, 2
    loop show
    ret
    space dw ' $', 0
endp