/*
 * Aufgabe_2_2.S
 *
 * SoSe 2024
 *
 *  Created on: florian@florian-main @ 250428_161153
 *      Author: florian_hatzfeld(hafl1012)
 *
 *	Aufgabe : Multiplikation
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:
    ldr r0, =0 // ergebnisregister 
    ldr r1, =0 // überlaufsregister

    //Idee: 2^16 * 2^2 -> 2^18
    ldr r2, = 1<<31 // Multiplikant
    ldr r3, = 1<<2  // Multiplikator

movs r3, r3 // this triggers status flags
beq stop

    
einsprung:
    adds    r0, r2  // Addiere Multiplikant auf das ergebnis
    addcss  r1, r1, #1 // Inkrementiere den Überlauf auf r1
    subs    r3, #1  // Dekrementiere r2 in 1er Schritten
    bne einsprung

stop:
	nop
	bal stop

.end
