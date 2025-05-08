/*
 * Aufgabe_2_1.S
 *
 * SoSe 2025
 *
 *  Created on: florian@florian-main @ 250428_133700
 *      Author: florian_hatzfeld(hafl1012)
 *
 *	Aufgabe : 64 Bit Addition
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

// also da wir ja hier ein 32-Bit Wort haben, haben wir in summe 4 Byte oder 8 Nibble

.equ  BREAD_bm,   (1 << 0)  // Nibble 0/8, bit 0
.equ  BUTTER_bm,  (1 << 1)  // N0/8, bit 1
.equ  CHEESE_bm,  (1 << 2)  // N0b2
// N0b3 wird nicht verwendet

// ----------------------------
// ACHTUNG: So wie ich das Memory Layout verstanden habe, soll unser 32Bit Wort folgendes Layout haben:
// 0           1            2           3
// 0123 4567 8901 2345 6789 0123 4567 8901
// -N0| -Byte1--| -N2| -N3| XXXX XXXX XXXX
//
// Da wir aber nur Byte-Weise addressieren können, ist nur folgende Memorymap sinnvoll
// 0           1            2           3
// 0123 4567 8901 2345 6789 0123 4567 8901
// -N0| XXXX -Byte1--| -N2| -N3| XXXX XXXX
// (die XXX sind leere, nicht verwendete stellen. Ich mache aber hier weiter "Dienst nach Vorschrift" indem ich einfach alles in Nibble rein schreibe)
// ----------------------------



// Nibble {1,2} von 8 -> Byte 1
.equ    TEQUILA_bm,   (1 << 3)  //N1b0
.equ    MILK_bm,      (1 << 4)  //N1b1
.equ    RUM_bm,       (1 << 5)  //N1b2
.equ    VINE_bm,      (1 << 6)  //N1b3

.equ    VODKA_bm,     (1 << 7)  //N2b0
// N2b1 bis N2b3 wird nicht verwendet

// Nibble 3 entspricht Nibble 2
.equ    ALMOND_bm,    (1 << 8) //N3b0
.equ    PEANUT_bm,    (1 << 9) //N3b1
.equ    CHESTNUTS_bm, (1 << 10) //N3b2
// N3b3 wird nicht verwendet

// Nibble 4 entspricht dem Nibble 3
.equ    APPLE_bm,      (1 << 12) //N4b0
.equ    MANGO_bm,      (1 << 13) //N4b1
.equ    LEMON_bm,      (1 << 14) //N4b2
// N4b3 wirrd nicht verwendet


// ----------------------------

.equ FOODMAIN_bm,   (BREAD_bm | BUTTER_bm | CHEESE_bm)
.equ SPIRITS_bm,    (TEQUILA_bm | MILK_bm | RUM_bm | VINE_bm | VODKA_bm)
.equ NUTS_bm,       (ALMOND_bm | PEANUT_bm | CHESTNUTS_bm)
.equ FRUITS_bm,     (APPLE_bm | MANGO_bm | LEMON_bm)

.equ BREAKFAST_bm,  (FOODMAIN_bm | MILK_bm | PEANUT_bm | LEMON_bm)

main:
  ldr r0, = BREAKFAST_bm
  ldr r1, = (BREAKFAST_bm | NUTS_bm)

  ldr r2, = ((BREAKFAST_bm | VINE_bm ) & ~MILK_bm )

// die bestellung (Wort) wird für r3 aufgeteilt in 2 Tabletts (halbwörter). Dadurch kann 
// da der gute auf diät ist, werden dinge getan.

  ldr r3, = FRUITS_bm | (MILK_bm << 16) | MILK_bm 

  ldr r4, = (BREAKFAST_bm & (~(MILK_bm | BUTTER_bm))) | RUM_bm

  // Sind alle glücklich? → Nö, R3 ist auf diät

stop:
	nop
	bal stop

.end
