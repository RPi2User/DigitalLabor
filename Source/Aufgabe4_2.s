/*
 * Aufgabe_4_2.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *	Aufgabe : Addition von zwei 8 stelligen BCD Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

stellenzaehler:
    .word   0
stellenmaske:
    .word   0
return:
    .word   0
oflow:
    .word   0



main:



stop:
	nop
	bal stop
.end