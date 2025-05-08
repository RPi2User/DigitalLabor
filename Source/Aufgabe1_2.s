/*
 * Aufgabe_1_2.S
 *
 * SoSe 2024
 *
 *    Created on: 2024-04-03
 *        Author: hafl1012
 *
 *	Aufgabe : Addition von Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
/* Aufgabe 2a*/
    mov r0, #4294967295
    mov r1, #1

    add r2, r0, r1

/* Aufgabe 2b*/

    mov r2, #-1
    mov r3, #1

    add r4, r0, r1

/* Aufgabe 2c*/

    mov r0, #1<<31
    add r1, r0, r0


stop:
    nop
    bal stop

.end
