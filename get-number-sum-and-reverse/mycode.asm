org 100h

.data
    number dw 1564   ; target number
    sum dw 0         ; variable to store sum of digits
    reversed dw 0    ; variable to store reversed number
    divisor dw 10    ; helper variable to store number 10 so i could divide ax by 10

.code
    mov ax, number   ; store default value of number in ax

label1:
    cmp ax, 0        ; check if ax is less than or equal to zero
    jle label2       ; if less or equal then jump to label2

    mov dx, 0        ; empty the dx so there won't be any problem for dividing
    div divisor      ; divide the number in ax and store the remainder in dx and the zarib part in ax

    add sum, dx      ; add the remainder which is the last digit in number to sum
    
    ; below lines would multiply reversed by 10 using left shifting
    mov cx, reversed ; store a copy of reversed number in cx
    shl reversed, 3  ; left shift the number in reversed variable
    add reversed, cx ; add the prev stored reversed number to reversed number
    add reversed, cx ; add the prev stored reversed number to reversed number
    add reversed, dx ; add the remainder of division to reversed number
    
    jmp label1

label2:
    ; show stored variables in registers
    mov cx, reversed
    mov dx, sum

ret