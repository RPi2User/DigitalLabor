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
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.data
.equ z1, 0x01111111
.equ z2, 0x22202222


.text 

main:

init:

    mov r0, #0          // Ergebnis
    mov r1, #0          // Zwischensumme
    mov r2, #0          // bcd1
    mov r3, #0          // bcd2
    ldr r4, =0x11111110 // carry-wort
    mov r5, #0xF        // maske
    mov r6, #0          // schleifenzähler
    ldr r7, =z1         // Zahl1 
    ldr r8, =z2         // Zahl2
    mov r9, #0          // CarryTemp

    
while:

isolate_symbols:
    and r2, r7, r5  // r2 := r7[r5]
    and r3, r8, r5  // r3 := r8[r5]

shift_mask:
    mov r5, r5, lsl #4  // r5 << 4

add_bcd:
    add     r1, r2, r3      // r1 := r2 + r3
    subs    r1, #10         // r1 -= 10
    addmi   r1, #10         // when we subtracted too much, add it right on there
    
add_carry:
    // we only add carry to current mask (here 10^n+1)
    andpl   r9, r4, r5
    add     r0, r9      // should add 1 to NEXT position

add_subtotal:
    add     r0, r0, r1  // r0 += r1

end_while:
    add r6, r6, #1  // do-while logic
    cmp r6, #7
    blt while
    
stop:
	nop
	bal stop
.end