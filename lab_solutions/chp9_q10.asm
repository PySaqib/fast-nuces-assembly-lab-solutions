;**************************************************************************************************
;                                         Chapter #9(Q10)
;**************************************************************************************************
; Write a keyboard interrupt handler that disables the timer interrupt
; (no timer interrupt should come) while Q is pressed. It should be re-
; enabled as soon as Q is released.




;**************************************************************************************************
;                                         Solution
;**************************************************************************************************

[org 0x0100]
    jmp start
oldkbisr:       dd 0                            ; to store the offset and segment of old keyboard ISR



; hook keyboard interrupt service routine
kbisr:
push            ax
in              al, 0x60                        ; read a char from the keyboard port

cmp             al, 00010000b                   ; press scan code for Q = 16 in decimal, with MSB = 0(clear)
jne             nextCmp
; disable timer interrupt
in              al, 0x21                        ; read INT pin
or              al, 01h                         ; set IRQ0(timer interrupt) to disable it [1-->Disable, 0-->Enable]
out             0x21, al
jmp exit

nextCmp:
cmp             al, 10010000b                   ; release scan code for Q = 16 in decimal, with MSB = 1(set)
jne             nomatch
; enable timer interrupt
in              al, 0x21                        ; read INT pin
and             al, 0xFE                        ; clear IRQ0(timer interrupt) to enable it [1-->Disable, 0-->Enable]
out             0x21, al

nomatch:
pop             ax
jmp             far [cs: oldkbisr]

exit:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
pop             ax
iret
;********************************************************************************************



start:
xor             ax, ax
mov             es, ax                          ; points ES to IVT
; save offset and segment of old keyboard and INT13 ISRs
mov             ax, [es: 9*4]
mov             bx, [es: 9*4+2]
mov             [oldkbisr], ax
mov             [oldkbisr + 2], bx
; hook interrupts
cli
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