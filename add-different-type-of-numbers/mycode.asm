
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data

var1 db 10
var2 db 22

var3 dw 128
var4 dw 200

var5 dd 85432h
var6 dd 23123h
helper dd ?

.code

; add two db numbers
mov al, var1
add al, var2

; add two dw numbers
mov bx, var3
add bx, var4

; add two dd numbers
; add lower two bytes
mov cx, [var5]
add cx, [var6]
mov [helper], cx
; add two higher bytes
mov cx, [var5+2]
adc cx, [var6+2]
mov [helper+2], cx
; show result
mov dx, [helper]
mov cx, [helper+2]




; subtract two db numbers
mov al, var2
sub al, var1

; subtact two dw numbers
mov bx, var4
sub bx, var3

; subtract two dd numbers
; subtract lower bytes
mov cx, [var5]
sub cx, [var6]
mov [helper], cx
; subtract higher bytes
mov cx, [var5+2]
sbb cx, [var6+2]
mov [helper+2], cx
; show result
mov dx, [helper]
mov cx, [helper+2]



ret