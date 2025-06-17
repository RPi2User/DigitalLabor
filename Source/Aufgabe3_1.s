/*
 * Aufgabe_3_1.S
 *
 * SoSe 2024
 *
 *  Created on: 21052025
 *      Author: Florian Hatzfeld
 *
 *	Aufgabe : Unterprogrammaufruf
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ DELAY, 3 // Our delay Counter

var:
    .word   0x00
    .word   0x101
    .word   0x02
    .word   0x103
    .word   0x04
    .word   0x105
    .word   0x06
    .word   0x107

main:

init_regs:
    mov     r0, #0          // Ausgaberegister initialisieren
    mov     r1, #8          // Datenmenge = 8 (Anzahl der Werte in var)
    ldr     r3, =var        // Datenzeiger initialisieren (Adresse von var)
    mov     r4, #80         // Schwellenwert = 80

loop:
    ldr     r2, [r3], #4    // Wert aus dem Speicher laden, Datenzeiger verschieben
    lsl     r0, r0, #4      // Register nach links verschieben (um ein Nibble)
    cmp     r2, r4          // Vergleiche Wert mit Schwellenwert
    movlt   r2, #0          // Wenn Wert < Schwellenwert, setze Wert = 0
    movge   r2, #8          // Wenn Wert >= Schwellenwert, setze Wert = 8
    orr     r0, r0, r2      // Wert mit dem Ausgaberegister verodern, dadurch werden nur das ergebnis hinein geschrieben ohne vorherhige zu überschreiben
    
    bl delay

    subs    r1, r1, #1      // Datenmenge um 1 dekrementieren
    bne     loop            // Solange Datenmenge > 0, wiederhole

stop:
    nop
    bal stop

delay:

    STMDB sp!, {r0, lr}   // Save relevante Register + Link Register


    ldr r0,=DELAY       
    delay_loop:
        subs r0, r0, #1
        bne delay_loop

        LDMIA sp!, {r0, lr}   // Restore vorher gespeicherte Register

        bx lr                    // Zurück zum Aufrufer



.end
