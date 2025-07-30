/*
 * Aufgabe_5_3.S
 *
 * SoSe 2024
 *
 *  Created on: 29.06.2025 @ florian-main
 *      Author: florian & max
 *
 *	Aufgabe : Ein- und Ausgabe über Taster und LEDs
 */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
.data

// ---SYSTEM-REGISTER-----------------------------------------------
.equ	STACK_INIT,	0x40001000


// ---PORT-REGISTER-------------------------------------------------
.equ IOPIN0, 	0xE0028000	// Reference to Port A
.equ IOPIN1,	0xE0028010	// Reference to Port B
.equ IOSET, 	0x4			// Offset for port A/B -> SETPIN (Out)
.equ IODIR, 	0x8			// Offset for port A/B -> PORT-DIRECTION
.equ IOCLR, 	0xC			// Offset for port A/B -> CLRPIN (Out)
// -----------------------------------------------------------------


// ---BUTTONS-------------------------------------------------------
.equ	BUTTON_0_bm,	(1<<10)
.equ	BUTTON_1_bm,	(1<<11)
.equ	BUTTON_2_bm,	(1<<12)
.equ	BUTTON_3_bm,	(1<<13)
.equ	BUTTON_bm,		(BUTTON_0_bm | BUTTON_1_bm | BUTTON_2_bm | BUTTON_3_bm)


// ---LEDS----------------------------------------------------------
.equ	LED0,	(1<<16)
.equ	LED1,	(1<<17)
.equ	LED2,	(1<<18)
.equ	LED3,	(1<<19)
.equ	LED4,	(1<<20)
.equ	LED5,	(1<<21)
.equ	LED6,	(1<<22)
.equ	LED7,	(1<<23)
.equ	LED_MASK,(LED0 | LED1 | LED2 | LED3 | LED4 | LED5 | LED6 | LED7)


.text /* Specify that code goes in text segment */

main:
        mov r4, #4
        movs   r4,  r4
        beq     stop
	ldr	sp, =STACK_INIT

init_iodir:
	// 55:59 is purely optional, Port0 is on PON/Reset always Input-only
	ldr	r0,	=IOPIN0 + IODIR
	// this is equal to mov r1, #0
	ldr	r1,	=BUTTON_bm
	and r1, r1, #0		// set all (Buttons) as Input
	str	r1,	[r0]

	ldr	r0,	=IOPIN1 + IODIR
	ldr r1,	=LED_MASK
	str	r1,	[r0]		// set all LEDs as Output

	// Aufgabe 5.3.1
	// -------------------------------------------------------------
a31:
	mov r1,	#1				// Difference between LED0 and LED1
	ldr	r2,	=IOPIN1 + IOSET	// Port B + offset
	ldr r3,	=IOPIN1 + IOCLR // Port B + offset
	ldr	r4,	=IOPIN0			// provide Button reg
	ldr	r5,	=BUTTON_0_bm	// provide BT0 Bitmask
	ldr	r6,	=LED0			// provide LED0 
	bl voraufgabe
	//b 3_1
	// -------------------------------------------------------------
	b a31
	bal stop
loop:
	// pre-Init pointer regs
	ldr	r2,	=IOPIN1 + IOSET		// provide all Outputs on Port 1 (Port B)
	ldr r3,	=IOPIN1 + IOCLR		// provide all Clrs on Port 1
	ldr	r4,	=IOPIN0				// provide Button reg

	// bt0 LED0 and LED2 -> diff = 2
	ldr	r5,	=BUTTON_0_bm	// bt0
	ldr	r6,	=LED0			// LED0
	mov r1,	#2				// LED2-LED0 -> 2
	bl 	voraufgabe

	// bt1 LED1 and LED3 -> diff = 2
	ldr	r5,	=BUTTON_1_bm	// bt1
	ldr	r6,	=LED1			// LED1
	mov r1,	#2				// LED3-LED1 -> 2
	bl 	voraufgabe

	// bt2 LED4 and LED6 -> diff = 2
	ldr	r5,	=BUTTON_2_bm	// bt2
	ldr	r6,	=LED4			// LED4
	mov r1,	#2				// LED4-LED6 -> 2
	bl 	voraufgabe

	// bt3 LED5 and LED7 -> diff = 2
	ldr	r5,	=BUTTON_3_bm	// bt2
	ldr	r6,	=LED5			// LED5
	mov r1,	#2				// LED5-LED7 -> 2
	bl 	voraufgabe
	b	loop
	// -------------------------------------------------------------
stop:
	nop
	bal stop

/*  This function toggles between two LEDs based on BT_Press
*  requires:	
*		- r1	Offset to second LED
*		- r2	IOSET
*		- r3	IOCLR
*		- r4	IOPIN
*		- r5 	BTn_Bitmask
*		- r6	LEDn_Mask
*		
* returns: void
*/ 
voraufgabe:
  push {r0-r6, lr}

	// ldr r6, =LED0 // Load mask for the LED 0 in r6
	// ldr r5, =BUTTON_0_bm // Load mask for the button 0 in r5
	ldr r0, [r4]  // Load input values from IOPIN to register r0

	ands r0, r5, r0  // r0 := r5 && r0
  // THIS MOFO IS ACTIVE 
  beq noled1  // branch if button is not pressed
  

	// button is pressed,
	str r6, [r2]  // switch pins defined in r2 on (IOSET1) (first LED on)
	mov r6, r6, lsl r1 // shift mask to second LED (offseted by r1)
	str r6, [r3]  // switch pins defined in r3 off (IOCLR1) (second LED off)
	b led_done  // brunch to end
	// button is not pressed 

  noled1: 
	str r6, [r3]  // switch pins defined in r3 off (IOCLR1) (first LED off)
	mov r6, r6, lsl r1 // shift mask to second LED (offseted by r1)
	str r6, [r2]  // switch pins defined in r2 on (IOSET1) (second LED on)
  led_done:  // End subrutine
  pop	{r0-r6,lr}
  bx	lr

.end