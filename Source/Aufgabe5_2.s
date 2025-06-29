/*
 * Aufgabe_5_2.S
 *
 * SoSe 2024
 *
 *  Created on: 27.06.2025 @ florian-main
 *      Author: florian und max
 *
 *	Aufgabe : Permanentes Lauflicht
 */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.data


// GPIO_Register
.equ    IOSET1,     0xe0028014  // sets pins on µC
.equ    IODIR1,     0xe0028018  // changes direction whether or not pin is input or output
.equ    IOCLR1,     0xe002801c	// clr pins on µC

// LED_VALUES
.equ    LEDMASK,    0x00ff0000  // bits 16-23 masked
.equ    LED_COUNT,  8
.equ    PATTERN,    1 << 23     // starting at LED7

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
    
    ldr r0, =LEDMASK
    ldr r1, =PATTERN
    ldr r2, =LED_COUNT
    ldr r3, =IOSET1
    ldr r4, =IOCLR1
    bl lauflicht

stop:
    nop
    bal stop
// ---------------------------------------------------------------------------
// FUNCTIONS

// This function requires this parameters
//  - r0    PIN_MASK
//  - r1    PIN_PATTERN
//  - r2    PIN_COUNT
//  - r3    GPIO-SET-Register
//  - r4    GPIO-CLR-Register

lauflicht:
    push {r5, r6, r7, r8, lr}

	// idea:
	//	1. We push current pattern on PORT
	//	2. Rotate pattern by 1 pin
	//	3. We clear all pins (except one) !PATTERN
	//	4. dec counter (if 0 -> 6.)
	//	5. loop to 1.
	//  6. load pattern, reset cntr, set first led

loop_init:
	// set first led (led7)
    mov     r5,	r2	// Load Counter
    mov     r6,	r1	// Load pattern
    str     r6, [r3]    // set first LED (LED7)

loop:
    bl      delay       // display current LED
    ror     r6, #1      // right-shift pattern by 1 bit
    and     r7,	r6, r0	// just let relevant Pins through…
    str     r7, [r3]    // set next LED
    mvn     r8,	r6	// invert current mask
    and     r7, r8, r0	// use inverted mask to clear all LEDs excluding current one
    str     r7,[r4]    	// clear all LEDs excl. current one
    subs    r5, r5, #1  // dec counter
    bgt     loop
    b       loop_init

    pop {r5, r6, r7, lr}
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