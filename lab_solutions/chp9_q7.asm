;**************************************************************************************************
;                                         Chapter #9(Q7)
;**************************************************************************************************
; Write a TSR that hooks software interrupt 0x80 and the timer
; interrupt. The software interrupt is called by other programs with the
; address of a far function in ES:DI and the number of timer ticks after
; which to call back that function in CX. The interrupt records this
; information and returns to the caller. The function will actually be
; called by the timer interrupt after the desired number of ticks. The
; maximum number of functions and their ticks can be fixed to 8.




;**************************************************************************************************
;                                         Solution
;**************************************************************************************************

[org 0x0100]
    jmp start


; maximum 8 functions can be scheduled [8*3 words = 24 words]
; initialize with -1 to check indicates it's not scheduled and called
; initialize with -2, if functions is called
; 6 bytes for each function
; 2bytes    +    2bytes     +    2bytes
;    |              |              |
; (offset)      (segment)       (ticks)
; [NOTE: offset address is stored at low significant word]
buffer:             times 24 dw -1          ; to store information of functions to be called
funcNum:            db 0                    ; function number to be scheduled
;********************************************************************************************




; hook INT80 interrupt service handler
; ES --> Segment of function
; DI --> offset of function
; CX --> Number of ticks
my_int80_isr:
push            ax
push            bx
; check either function number is within limit or not
cmp             byte [cs:funcNum], 08
jge             notSchedule

; to calculate buffer's offset
mov             al, [cs: funcNum]
mov             bl, 6            ; each program's information is of 6 bytes
mul             bl
xor             bx, bx
mov             bl, al          ; store starting offset where to store information
; store information in buffer
mov             word [cs:buffer + bx], di           ; offset
mov             word [cs:buffer + bx + 2], es       ; segment
mov             word [cs:buffer + bx + 4], cx       ; ticks
; update function number
inc             byte [cs:funcNum]

notSchedule:
pop             bx
pop             ax
iret
;********************************************************************************************



; hook timer interrupt service routine
timer:
pusha
; to check which functions need to be called
mov             cx, 8                               ; maximum functions
mov             si, 0
callFunctionsLoop:
cmp             word [cs:buffer + si + 4], -1       ; no further function is scheduled
je             exitTimer

cmp             word [cs: buffer + si + 4], -2      ; function is already called
je             continue

; call function if it has no remaining tick i.e ticks = 0
cmp             word [cs:buffer + si + 4], 0
jne             decrementTicks

call            far [cs: buffer + si]               ; call function
;update buffer enteries
mov             word [cs: buffer + si], -2          ; offset
mov             word [cs: buffer + si + 2], -2      ; segment
mov             word [cs: buffer + si + 4], -2      ; ticks
jmp             continue

; decrement remaining ticks
decrementTicks:
dec             word [cs: buffer + si + 4]

continue:
add             si, 6
loop            callFunctionsLoop

exitTimer:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
popa
iret
;********************************************************************************************



; function to call INT 80h
; segment, offset and number of ticks as parameters
int80_caller:
push            bp
mov             bp, sp
pusha
; call interrupt 80
mov             cx, [bp + 4]            ; ticks
mov             di, [bp + 6]            ; offset
mov             ax, [bp + 8]
mov             es, ax                   ; segment
int             80h
popa
pop             bp
ret             6
;********************************************************************************************



start:
xor             ax, ax
mov             es, ax          ; points ES to IVT

; hook timer interrupt
cli
mov             word [es: 8*4], timer
mov             [es: 8*4 + 2], cs
; hook INT 80h interrupt
mov             word [es: 80h*4], my_int80_isr
mov             [es: 80h*4 + 2], cs
sti
; to make it TSR
mov             dx, start
add             dx, 15
mov             cl, 4
shr             dx, cl
mov             ax, 0x3100
int             0x21
;********************************************************************************************