/*
 * Aufgabe_3_4.S
 *
 * SoSe 2024
 *
 *  Created on: 21052025
 *      Author: Florian Hatzfeld
 *
 *	Aufgabe : nterprogrammaufruf mit Übergebe von mehreren Parametern - Division
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ    DIVIDEND,   100
.equ    DIVISOR,    3
.equ    QUOTIENT,   0
.equ    FEHLER,     0


main:
    
    ldr r0,=DIVIDEND
    ldr r1,=DIVISOR

    bl  division
    // Insert Error handling and result handling here ^^
    bal stop
    
    // Quotient := Dividend / Divisor

division:
    stmdb   sp!, {r0-r1, lr}   // Save relevante Register + Link Register
    // r0, r1 hat noch die werte DIVIDEND und DIVISOR
    ldr     r2,=QUOTIENT
    ldr     r3,=FEHLER
    
    cmp     r1, #0
    bne     div_begin
    mov     r3,     #1          // Set ERROR State
    bal     cleanup             // RETURN from Subroutine

    div_begin:
        mov     r2, #0
    div_worker:
        add     r2, r2, #1          // quotient++
        subs    r0, r0, r1          // dividend := dividend - divisor
        bge     div_worker
        sub     r2, r2, #1          // quotient--
        add     r0, r0, r1          // dividend := dividend + divisor
    
cleanup:
    ldmia   sp!, {r0-r1, lr}   // Restore vorher gespeicherte Register
    bx      lr



stop:
	nop
	bal stop

.end
