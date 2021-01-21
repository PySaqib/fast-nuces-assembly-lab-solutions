;**************************************************************************************************
;                                         Chapter #9(Q9)
;**************************************************************************************************
; Write a TSR to disable all writes to the hard disk when F10 is pressed and re-
; enable when pressed again like a toggle.
; HINT: To write to the hard disk programs call the BIOS service INT 0x13 with
; AH=3.


;**************************************************************************************************
;                                         Solution
;**************************************************************************************************


[org 0x0100]
    jmp start

oldkbisr:       dd 0                            ; to save the offset and segment of old keyboard ISR
oldint13isr:    dd 0                            ; to save the offset and segment of old INT13 ISR
isEnableTrue:   db 0                            ; flag to check either enable or disable writes to the hardisk
;********************************************************************************************



; hook keyboard interrupt service routine
kbisr:
push            ax
in              al, 0x60                        ; read a char from the keyboard port

cmp             al, 01000100b                   ; press scan code for F10 = 68 in decimal, with MSB = 0(clear)
jne             nomatch
; toggle the flag
cmp             byte [cs:isEnableTrue], 1
jne             setOne
mov             byte [cs: isEnableTrue], 0
jmp             exit
setOne:
mov             byte [cs: isEnableTrue], 1
jmp             exit

nomatch:
pop             ax
jmp             far [cs: oldkbisr]

exit:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
pop             ax
iret
;********************************************************************************************



; hook INT13 interrupt service routine
; [HINT: To write to the hard disk programs call the BIOS service INT 0x13 with AH=3]
my_int13_isr:
push            ax

cmp             ah, 03
jne             callINT13

cmp             byte [cs: isEnableTrue], 1
jne             disableWrites

callINT13:
pop             ax
jmp             far [cs: oldint13isr]

disableWrites:
mov             al, 0x20
out             0x20, al                        ; send EOI to PIC
pop             ax
iret
;********************************************************************************************



start:
xor             ax, ax
mov             es, ax          ; points ES to IVT
; save offset and segment of old keyboard and INT13 ISRs
mov             ax, [es: 9*4]
mov             bx, [es: 9*4+2]
mov             [oldkbisr], ax
mov             [oldkbisr + 2], bx
mov             ax, [es: 13h*4]
mov             bx, [es: 13h*4+2]
mov             [oldint13isr], ax
mov             [oldint13isr + 2], bx
; hook interrupts
cli
mov             word [es: 13h*4], my_int13_isr
mov             [es: 13h*4 + 2], cs
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