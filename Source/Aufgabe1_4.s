/*
 * Aufgabe_1_4.S
 *
 * SoSe 2024
 *
 *    Created on: 2024-04-03
 *        Author: hafl1012
 *
 *	Aufgabe : Maskenoperationen
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

main:
    /*a-value*/
    ldr r0, =0xFFFF0001 /* Low-Word*/
    ldr r1, =0x0000FFFF /* High-Word*/

    /*b-value*/
    ldr r2, =0x0000FFFF /* Low-Word*/
    ldr r3, =0xFFFF0000 /* High-Word*/

    /*c-value*/
    ldr r4, =0x0 /* Low-Word*/
    ldr r5, =0x0 /* High-Word*/
    
add_lw: 
    adds r4, r0, r2    /* Add low-words AND SET STATURS REGS ffs*/
    adcs r5, r1, r3    /* Add high-words + carry*/
    movcs r6, #0x01
    movcc r6, #0x00 // set no carry (clear carry reg)
    bal stop    /*Exit*/


stop:
    nop
    bal stop
.end