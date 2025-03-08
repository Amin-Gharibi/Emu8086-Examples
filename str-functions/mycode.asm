
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data

src_str dw "Amin Gharibi!$"
dest_str dw "This is Mohamad Amin Gharibi!$"
new_line db 0Dh, 0Ah, '$'
same_msg dw "New Text is the same as Old Text!$"
not_same_msg dw "New Text IS NOT the same as Old Text!$"
found_msg dw "Char was found in the Text!$"
not_found_msg dw "Char was not found in the Text!$"

.code

get_len macro text
    local find_len, done
    
    push si
    push ax
    
    lea si, text
    mov cx, 0
    find_len:
    mov al, [si]
    cmp al, '$'
    je done
    inc cx
    inc si
    jmp find_len
    
    done:
    pop ax
    pop si
get_len endm
    

; copy src to dest
lea si, src_str
lea di, dest_str
get_len src_str

cld
rep movsb

lea dx, dest_str
mov ah, 9
int 21h

lea dx, new_line
int 21h

; compare new text with the old one
lea si, src_str
lea di, dest_str
get_len dest_str

cld
repe cmpsb

lea dx, same_msg
je same
lea dx, not_same_msg
same:
mov ah, 9
int 21h

lea dx, new_line
int 21h


; search a char in dest_text
mov al, "A"
lea di , dest_str
get_len dest_str

cld
repne scasb

lea dx, found_msg
je found
lea dx, not_found_msg
found:
mov ah, 9
int 21h

lea dx, new_line
int 21h

; set 2 first chars of dest_str as whitespace
mov al, " "
lea di, dest_str
mov cx, 2

cld
rep stosb

lea dx, dest_str
mov ah, 9
int 21h


lea dx, new_line
int 21h

; load and show 6 first chars of dest_str
lea di, dest_str
mov ah, 2
mov cx, 6
show:
lodsb
mov dl, al
int 21h
loop show
 

ret