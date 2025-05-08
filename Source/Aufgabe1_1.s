/*
 * Aufgabe_1_1.S
 *
 * SoSe 2024
 *
 *    Created on: 2024-04-03
 *        Author: hafl1012
 *
 *	Aufgabe : Zahlendarstellung
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:

    ldr r0, =0x55aa55aa /* this is how you load a 32bit value*/


    mov r0, #0xFFFFFFF4
    mov r1, #4294967284
    mov r2, #-12
    mov r3, #-0xC
    mov r4, #~11        /*die tilde invertiert das Bitmuster der 11dec in das bekannte muster 0xFFFFFFF4*/
    mov r5, #0b11111111111111111111111111110100

stop:
    nop
    bal stop

.end
