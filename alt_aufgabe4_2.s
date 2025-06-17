/*
 * Aufgabe_4_2.S
 *
 * SoSe 2025
 *
 *  Created on: <$11.06.25>
 *      Author: me
 *
 *    Aufgabe : Addition von zwei 8 stelligen BCD Zahlen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.equ Variable_A, 0x09999999
.equ Variable_B, 0x1


main:
      ldr r0, =Variable_A
      ldr r1, =Variable_B
      mov r2, #0      // total

      mov r3, #0      // carry
      mov r4, #0xF    // BCD-Maske
      
      // working registers should only have contents from 0-9
      mov r5, #0      // workreg1
      mov r6, #0      // workreg2

      mov r7, #8      // cntr resti
      mov r8, #0      // subtotal


loop:
// ---Appennd mask---------------------
    and r5, r0, r4    // move first nibble into work register
    and r6, r1, r4    // r6 := r1 && r4
 // ---------------------------------------------------------
// ---add two nibble--(subtotal += a[i] + b[i] + C)--------
    add r8, r5, r6
    add r8, r8, r3
    mov r3, #0
 // --------------------------------------------------------
// ---bcd-Prüfen-----------------------------------------
    subs r8, #10        //prüfen ob r8 ein gültigen bcd Zahl ist
    addpl r3, #1        //wenn r8 <= 10 war carry setzen
    addmi r8, #10       //wenn r8 > 10 war restoren
 // --------------------------------------------------------
// ----Ergebnis--Setzen-------------------------------------
    add r2, r8
 // --------------------------------------------------------
// ---shift---around-----------------------------------------
    mov r0, r0, ror #4
    mov r1, r1, ror #4
    mov r2, r2, ror #4
 // --------------------------------------------------------
// ------loop----------------------------------------------
    sub r7, #1
    cmp r7, #0
    bne loop
// --------------------------------------------------------
    


stop:
    nop
    bal stop
.end