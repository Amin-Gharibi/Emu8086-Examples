
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data

arr   dw 10 dup(10) ; array you want to sum up
count dw 10         ; count of numbers in array

.code

mov cx, count       ; move the count to cx so the loop would run count times

mov ax, 0           ; store the sum in ax so init ax with 0
lea bx, arr         ; store the address of starting point of arr in bx

next:
    add ax, [bx]    ; add the value that bx is pointing to to the current value of ax
    add bx, 2       ; add the bx by 2 bytes so it would point to the next index of the array
loop next           ; loop next label until cx is 0

ret




