/*
 * Aufgabe_4_1.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Verwendung von Stack
 */
.data /* Specify that data goes in data segment */
term1: .word 0 /* Speicherplatz für term1 */
term2: .word 0 /* Speicherplatz für term2 */
temp:  .word 0 /* Speicherplatz für temp */

.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ    a,  150
.equ    b,  -193
.equ    c,  -200



main:			// Einsprungspunkt
    sub sp, sp, #4          // Dekrementiere den stackpointer (r13) um 4
    mov r0, #0x44           // Lade Wert 0x44 in Register 0
    mov r1, #0x55           // Lade Wert 0x55 (Bitnmuster 01010101) Register 1
    mov r2, #0xffffffff     // Lade nur einsen in R2
    str r2,[sp,#4]          // Speichere r2 an [sp + 4]
    mov r5, #3              // Lade Wert 3 in register 5

while:    // Einsprungsmarke für den bedingten Sprung
    bl berechne             // Springe zu berechne und überschreibe R14 := R15 - 4
    ldr r1,[sp,#+4]         // Lade r1 mit dem wert von ([r13 bzw. sp] offset +4)
    cmp r0,r1               // Vergleiche r0 und r1 und setze das Statusregister
    strge r0,[sp,#+4]       // Wenn r0 größer-gleich r1 ist, speicher r0 an [sp offset 4]
    subs r5, r5, #1         // Dekrementeire r5 um 1 und setze Statusregister
    bne while               // Wiederhole solange r5 != 0 ist

    
berechne:
    push    {r0-r3}         // Speichere {r0-r3} auf den Stack

    ldr r0, =a              // Lade Registerwerte aus globalen Variablen (unseren netten Speicheraddressen welche wir zum glück nicht händisch berechnen müssen
    ldr r1, =b
    ldr r2, =c
    ldr r3, =0

    ldr r0, =b
    ldr R1, =0
    
    push    {lr}
    bl absSub
    pop     {lr}
    // r0 hat nun -b

    mov r1, r0
    ldr r0, =a

    push    {lr}
    bl absSub
    pop     {lr}
    
    // r0 hat nun |a - b| diese soll nun in term1 gespeichert werden

    ldr r1, =term1
    str r0, [r1]           // Speichere den Wert von r0 in *term1

    pop     {r0-r3}         // Lade {r0-r3} von dem Stack

absSub:

    rsbs    r0, r1, r0
    rsbmi   r0, r0, #0
    bx      lr

stop:
	nop
	bal stop

.end