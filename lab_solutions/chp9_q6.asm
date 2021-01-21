;**************************************************************************************************
;                                         Chapter #9(Q6)
;**************************************************************************************************
; Write a TSR to rotate the screen (scroll up and copy the old top most
; line to the bottom) while F10 is pressed. The screen will keep rotating
; while F10 is pressed at 18.2 rows per second. As soon as F10 is
; released the rotation should stop and the original screen restored. A
; secondary buffer of only 160 bytes (one line of screen) can be used.



;**************************************************************************************************
;                                         Solution
;**************************************************************************************************

[org 0x0100]

    jmp start


oldisr:         dd 0                        ; to save old isr offset and segment
buffer:         times 160 db 0              ; buffer of 160 bytes
isF10Pressed:   db 0                        ; flag to check either F10 key is pressed or not
ticks:          db 0                        ; to keep count number of ticks encountered
;********************************************************************************************



; to scroll up window by one row
scroll_up:
pusha

mov             ah, 06      ; service number
mov             al, 01      ; number of lines/rows to scroll up
mov             bh, 07      ; attribute used to write blank lines at bottom of window
mov             cx, 0000h   ; CH,CL = row,column of window's upper left corner
mov             dx, 184Fh   ; DH,DL = row,column of window's lower right corne
int             10h

popa
ret
;********************************************************************************************



; to scroll down window by one row
scroll_down:
pusha

mov             ah, 07      ; service number
mov             al, 01      ; number of lines/rows to scroll up
mov             bh, 07      ; attribute used to write blank lines at bottom of window
mov             cx, 0000h   ; CH,CL = row,column of window's upper left corner
mov             dx, 184Fh   ; DH,DL = row,column of window's lower right corne
int             10h

popa
ret
;********************************************************************************************



; to store top most row of window in buffer
; source position(SI) as parameter
store_buffer:
push            bp
mov             bp, sp
pusha

mov             ax, 0xb800          ; points to video memory
mov             ds, ax
mov             si, [bp + 4]        ; source starting index
mov             ax, cs
mov             es, ax
mov             di, buffer
mov             cx, 80              ; 60 words = 160 bytes

cld
rep             movsw               ; move data from video memory to buffer

popa
pop             bp
ret             2
;********************************************************************************************



; to load a row from the buffer and place it at the bottom
; destination position (DI) as parameter
load_buffer:
push            bp
mov             bp, sp
pusha

mov             ax, 0xb800              ; points to video memory
mov             es, ax
mov             di, [bp + 4]            ; destination starting index
; points to buffer
mov             ax, cs
mov             ds, ax
mov             si, buffer
mov             cx, 80                  ; 80 words = 160 bytes

cld
rep             movsw                   ; load buffer in video memory

popa
pop             bp
ret             2
;********************************************************************************************



; to move top most row to the bottom of the window
mov_top_row:
push            word 0          ; start of top most row
call            store_buffer
call            scroll_up
push            word 3840       ; start of bottom most row
call            load_buffer
ret
;********************************************************************************************



; to restore original screen
restore_screen:
pusha

xor             ax, ax              
mov             al, [ticks]         ; load ticks in AL
mov             bl, 25              ; total 25 rows
div             bl
; scroll down for AH times to restore orignal screen
xor             cx, cx
mov             cl, ah

cmp             cx, 0
jbe             exitRestoreScreen

while:
push            word 3840           ; start of bottom most row
call            store_buffer
call            scroll_down
push            word 0              ; start of top most row
call            load_buffer         
loop            while

exitRestoreScreen:
popa
ret
;********************************************************************************************




; hook keyboard interrupt service routine
kbisr:
push            ax

in              al, 0x60                        ; read a char from keyboard port
cmp             al, 01000100b                   ; press scan code for F10 = 68 in decimal with MSB = 0(clear)
jne             nextCmp
mov             byte [cs: isF10Pressed], 1      ; set the flag
jmp             exit

nextCmp:
cmp             al, 11000100b                   ; release scan code for F10 = 68 in decimal with MSB = 1(set)
jne             nomatch
mov             byte [cs: isF10Pressed], 0      ; reset the flag
call            restore_screen                  ; to restore original screen
mov             byte [cs: ticks], 0             ; reset ticks
jmp             exit

nomatch:
pop             ax
jmp             far [cs: oldisr]

exit:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
pop             ax
iret
;********************************************************************************************



; hook timer interrupt service routine
timer:
push            ax
cmp             byte [cs: isF10Pressed], 1
jne             exitTimer

inc             byte [cs: ticks]
call            mov_top_row

exitTimer:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
pop             ax
iret
;********************************************************************************************



start:
xor             ax, ax
mov             es, ax          ; points ES to IVT
; save offset and segment of old keyboard ISR
mov             ax, [es: 9*4]
mov             bx, [es: 9*4+2]
mov             [oldisr], ax
mov             [oldisr + 2], bx
; hook interrupts
cli
mov             word [es: 8*4], timer
mov             [es: 8*4 + 2], cs
mov             word [es: 9*4], kbisr
mov             [es: 9*4 + 2], cs
sti
; to make it TSR
mov             dx, start
add             dx, 15
mov             cl, 4
shr             dx, cl
mov             ax, 0x3100
int             0x21
;********************************************************************************************