
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here

.data

arr dw -10,8,5,6
count dw 4
n_sum dw ?
p_sum dw ?
sum dw ?

.code

main proc
    lea bx, arr ; mov bx, offset arr
    mov cx, count
    mov ax, 0
    call negative_sum
    mov n_sum, ax
    mov ax, 0
    call positive_sum
    mov p_sum, ax
    add ax, n_sum
    mov sum, ax
    
    ; show variables
    mov ax, n_sum
    mov bx, p_sum
    mov cx, sum
    ret
main endp

negative_sum proc
    push bx
    push cx
    next1:
        mov dx, [bx]
        cmp dx, 0
        jge next2
        add ax, dx
    next2:
        add bx, 2
    loop next1
    pop cx
    pop bx
    ret
negative_sum endp

positive_sum proc
    push bx
    push cx
    next3:
        mov dx, [bx]
        cmp dx, 0
        jle next4
        add ax, dx
    next4:
        add bx, 2
    loop next3
    pop cx
    pop bx
    ret
positive_sum endp

ret