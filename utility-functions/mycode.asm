
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data

num dw 8
arr dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
count dw 10
first_text db "Amin$"
second_text db "Amin$"

.code

;mov ax, num
;call get_len_num

;mov ax, num
;call reverse_num

;mov cx, num
;call sum_of_odds

;mov cx, num
;call get_fact

;mov ax, num
;call check_prime

;mov cx, count
;lea bx, arr
;call reverse_array

;show the reversed array
;inc cx
;lea bx, arr
;t_label:
;mov ax, [bx]
;add bx, 2
;loop t_label

;lea si, first_text
;lea di, second_text
;mov cx, 5
;call compare_texts


;lea si, arr
;mov cx, 10
;call find_max_array

mov ax, 5
call get_fibonacci

ret

get_len_num proc ; number must be in ax
    mov cx, 0
    mov bx, 10
    
    gln_label1:
    cmp ax, 0
    je gln_done
    inc cx
    mov dx, 0
    div bx
    jmp gln_label1
    
    gln_done:
    ret
get_len_num endp

reverse_num proc ; number must be in ax
    mov bx, 10
    r_label1:
    cmp ax, 0
    je r_done
    mov dx, 0
    div bx
    push ax
    push dx
    mov ax, reversed_num
    mov dx, 0
    mul bx
    pop dx
    add ax, dx
    mov reversed_num, ax
    pop ax
    jmp r_label1
    
    r_done:
    mov ax, reversed_num  
    ret
    reversed_num dw 0
reverse_num endp


sum_of_odds proc ; number must be in cx
    mov bx, 2
    
    so_label1:
    mov ax, cx
    mov dx, 0
    div bx
    cmp dx, 0
    je skip
    add sum_odds, cx
    skip:
    loop so_label1
    
    mov ax, sum_odds
    ret
    sum_odds dw 0
sum_of_odds endp


get_fact proc ; num must be in cx
    
    gf_label1:
    mov ax, fact
    mov dx, 0
    mul cx
    mov fact, ax
    dec cx
    cmp cx, 1
    jne gf_label1
    
    mov ax, fact
    ret
    fact dw 1    
get_fact endp


check_prime proc ; num must be in ax
    mov bx, ax ; store number
    mov cx, ax
    
    cp_label1:
    cmp cx, ax
    je cp_skip
    
    mov dx, 0
    div cx
    cmp dx, 0
    jne cp_skip
    mov is_prime, 0
    jmp cp_done
    
    cp_skip:
    mov ax, bx
    dec cx
    cmp cx, 1
    jne cp_label1
    
    cp_done:
    mov ax, is_prime
    ret
    is_prime dw 1
check_prime endp


reverse_array proc ; count must be in cx, offset of arr must be in bx
    mov si, bx ; starting address
    
    mov dx, 0
    mov ax, 2 ; because dw is used
    mul cx
    mov di, bx
    add di, ax ; ending address
    
    ra_label1:
    cmp si, di
    jge ra_done
    mov ax, [si]
    mov bx, [di]
    mov [si], bx
    mov [di], ax
    add si, 2
    sub di, 2
    jmp ra_label1
    
    ra_done:
    
    ret
reverse_array endp


compare_texts proc ; offset of first text must be in SI and offset of second text must be in DI, and CX must be the count to check
    cld
    repe cmpsb
    
    mov ax, 0
    jne ct_end
    mov ax, 1
    
    ct_end:
    ret
compare_texts endp


find_max_array proc ; offset of arr must be in SI, count of numbers must be in CX
    mov ax, [si]
    mov fma_max, ax
    dec cx
    add si, 2
    
    fma_label1:
    mov ax, [si]
    cmp fma_max, ax
    jge fma_skip
    mov fma_max, ax
    fma_skip:
    add si, 2
    loop fma_label1
    
    mov ax, fma_max
    ret
    fma_max dw 0
find_max_array endp


get_fibonacci proc ; n must be in AX, result would be in BX
    cmp ax, 1
    jne check_second
    mov bx, 0
    ret
    
    check_second:
    cmp ax, 2
    jne calc_fib
    mov bx, 1
    ret
    
    calc_fib:
    mov cx, 0      ; first case, previous
    mov bx, 1      ; second case, current
    mov dx, 3      ; counter
    
    fib_loop:
    cmp dx, ax
    jg fib_end
    
    push bx        ; save current number
    add bx, cx     ; new_number = current + previous
    pop cx         ; previous = old current
    
    inc dx         ; counter++
    jmp fib_loop
    
    fib_end:
    ret
get_fibonacci endp