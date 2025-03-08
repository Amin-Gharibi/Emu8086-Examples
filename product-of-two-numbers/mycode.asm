
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data

first_number  dw 3       ; the first number
second_number dw 9       ; the second number

.code

mov ax, first_number     ; move first number to ax and store final value in it
mov cx, second_number    ; run the loop cx times
sub cx, 1                ; subtract cx by 1 because the loop runs until 0 not 1


next:
    add ax, first_number ; add the first number to current value of ax
loop next                ; loop until cx value is 0

ret