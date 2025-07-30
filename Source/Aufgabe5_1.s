/*
 * Aufgabe_5_1.S
 *
 * SoSe 2024
 *
 *  Created on: 27.06.2025 @ florian-main
 *      Author: florian, max
 *
 *	Aufgabe : Fortschrittsanzeige
 */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.data


// GPIO_Register
.equ    IODIR1,     0xe0028018  // changes direction whether or not pin is input or output
.equ    IOSET1,     0xe0028014  // set/clr will set/clr pins on µC

// LED_VALUES
.equ    LEDMASK,    0x00ff0000  // bits 16-23 masked
.equ    LED_COUNT,  8
.equ    PATTERN,    0xff000000  

// MISC
.equ    DELAY,      0x00800000  // delay should be noticeble
.equ    stackInit,  0x40001000  // Stackpointer init-address

.text /* Specify that code goes in text segment */
main:

    ldr sp, =stackInit          // pre init stackpointer to correct hw-address

    // Init GPIO-Regs
    ldr r0, =IODIR1
    ldr r1, =LEDMASK
    ldr r2, =LEDMASK
    bl writeMaskedGPIOreg
    // -----------------


    // SET PATTERN
    ldr r0, =IOSET1
    ldr r1, =LEDMASK
    ldr r2, =PATTERN
    ldr r3, =LED_COUNT

    bl fortschrittsanzeige

stop:
    nop
    bal stop
// ---------------------------------------------------------------------------
// FUNCTIONS

// This function requires this parameters
//  - r0    GPIO-SET-Register
//  - r1    PIN_MASK
//  - r2    PIN_PATTERN
//  - r3    Counter
// NO RETURNS / NO REFUNDS!
fortschrittsanzeige:
    push {lr}
loop:
    ror     r2, #1          // right-shift pattern by 1 bit
    bl      writeMaskedGPI5Oreg
    bl      delay
    subs    r3, r3, #1
    bgt     loop


    pop {lr}
    bx  lr

delay:

    STMDB sp!, {r0, lr}   // Save relevante Register + Link Register

    ldr r0,=DELAY       
    delay_loop:
        subs r0, r0, #1
        bne delay_loop

        LDMIA sp!, {r0, lr}   // Restore vorher gespeicherte Register
        bx lr                    // Zurück zum Aufrufer

// This function works with this registers:
//	- r0	[GPIO-Register]
//	- r1	LED_MASK
//	- r2	Pattern (shifted like LED_MASK!)
// NO RETURNS!
writeMaskedGPIOreg:
    push {r3, lr}
		and r3, r1, r2
        str r3, [r0]
    pop {r3, lr}
    bx lr
.end