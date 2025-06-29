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
.equ	IOPIN0,		0xe0028000
.equ	IOSET0,		IOPIN0 + 4
.equ	IODIR0,		IOSET0 + 4
.equ	IOCLR0,		IODIR0 + 4
// -----------------------------------------------------------------
.equ	IOPIN1,		IOCLR0 + 4
.equ    IOSET1,     IOPIN1 + 4
.equ	IODIR1,     IOSET1 + 4
.equ	IOCLR1,		IODIR1 + 4

// ---BUTTONS-------------------------------------------------------
.equ	BUTTON_0_bm,	(1<<10)
.equ	BUTTON_1_bm,	(1<<11)
.equ	BUTTON_2_bm,	(1<<12)
.equ	BUTTON_3_bm,	(1<<13)

.equ	LED_MASK,		0x00ff000000

.text /* Specify that code goes in text segment */

main:
	bl voraufgabe

	bl taster311

stop:
	nop
	bal stop

// This function is `void` and requieres no input and returns nothing
voraufgabe:
  push {r0-r9, lr}
init:


	// need to make this shit somewhat compatible with current program
	mov r6, #1<<16 // Load mask for the LED 0 in r6
	mov r5, #1<<10 // Load mask for the button 0 in r5
	ldr r0, [r4]  // Load input values from IOPIN to register r0
	ands r0, r5, r0  // check if button 0 is pressed 
	bne noled1  // branch if button is not pressed  
	// button is pressed,
	str r6, [r2]  // switch pins defined in r9 on (IOSET1) (first LED on)
	mov r6, r6, lsl #1 // shift mask to second LED
	str r6, [r3]  // switch pins defined in r9 off (IOCLR1) (second LED off)
	b led_done  // brunch to end
	// button is not pressed 
  noled1: 
	str r6, [r3]  // switch pins defined in r9 off (IOCLR1) (first LED off)
	mov r6, r6, lsl #1 // shift mask to second LED
	str r6, [r2]  // switch pins defined in r9 on (IOSET1) (second LED on)
	led_done:  // End subrutine

  pop	{r0-r9,lr}
  bx	lr

// this function is void and need no input and returns nothing
taster311:
  push	{lr}

  pop	{lr}
  bx 	lr


.end