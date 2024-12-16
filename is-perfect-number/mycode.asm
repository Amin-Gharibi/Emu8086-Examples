org 100h

.data
numbers dw 6
results dw 0
count dw 1

.code

lea bx, numbers
lea si, results
mov cx, count
check_numbers:
    mov ax, [bx]
    call isPerfect
    mov [si], ax
    
    add bx, 2
    add si, 2
    loop check_numbers

lea si, results
mov cx, count
show_results:
    mov bx, [si]
    
    add si, 2
    loop show_results
ret


; store the number you want to check in ax register and call this function
isPerfect proc 
    ; save used registers in stack
    push bx
    push cx
    push dx
    
    mov sum_of_divisors, 0  ; reset sum of divisors to avoid conflicts
    mov number, ax          ; store the target number in a temp variable because we would check until number/2 if a number is a divisor of ax
    div divisor             ; divide the number by 2 because all the divisors are less than equal to number / 2
    mov cx, ax              ; check until cx = ax/2
    mov bx, 1               ; start checking from 1 

find_divisor:
    cmp bx, cx
    jg check_sum            ; If bx(checking divisor) > cx(half of the number), stop searching for divisors

    mov ax, number          ; load the number we want to divide to ax
    mov dx, 0               ; empty the dx register
    div bx                  ; divide the target number (cx = ax/2) and store kharej ghesmat in ax and baghimande in dx  
    cmp dx, 0               ; check if baghimande is 0
    jne not_divisor         ; if baghimande is not 0 then bx is not a divisor for cx and skip adding it to sum_of_divisors

    add sum_of_divisors, bx ; add divisor to sum of divisors

not_divisor:
    inc bx                  ; increment divisor
    jmp find_divisor        ; repeat for the next divisor

check_sum:
    mov ax, number
    cmp sum_of_divisors, ax ; compare sum of divisors with the number
    je perfect              ; if equal, it's a perfect number
    mov ax, 0               ; if not equal, set ax to 0 (not perfect)
    jmp done                ; all divisors were checked. finish checking

perfect:
    mov ax, 1               ; set ax to 1 (perfect number)

done:
    ; restore used registers variables to default
    pop dx
    pop cx
    pop bx
    ret   

; needed variables for the procedure
divisor dw 2
sum_of_divisors dw 0
number dw 0

isPerfect endp