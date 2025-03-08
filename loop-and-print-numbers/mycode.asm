
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
include emu8086.inc
org 100h

; add your code here

.data

starting_number dw 1    ; the start of the interval to print
ending_number   dw 10   ; the end of the interval to print

.code

mov cx, ending_number   ; move the ending point to cx
sub cx, starting_number ; subtract the ending point by starting point for example 10 - 1 = 9
add cx, 1               ; add one to cx so it would also print the last number

mov ax, starting_number ; the number which is going to be printed is stored in ax

next:
    call print_num      ; print the number that is already in ax
    print 10            ; 10 is ascii code for \n
    print 13            ; 13 is used to move cursor to the first point of line
    add ax, 1           ; add the number in ax by one
loop next               ; loop next until value in cx is 0

ret

define_print_num
define_print_num_uns

end