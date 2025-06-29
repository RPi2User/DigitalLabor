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


.text /* Specify that code goes in text segment */

main:
	ldr	sp, =STACK_INIT
	bl voraufgabe
	bl taster311

stop:
	nop
	bal stop

// This function is `void` and requieres no input and returns nothing
voraufgabe:
  push {r0-r6, lr}
init:
	ldr	r2,	=IOSET1
	ldr r3,	=IOCLR1
	ldr r4, =IOPIN0
worker:
	ldr r6, =LED0 // Load mask for the LED 0 in r6
	ldr r5, =BUTTON_0_bm // Load mask for the button 0 in r5
	ldr r0, [r4]  // Load input values from IOPIN to register r0

	ands r0, r5, r0  // check if button 0 is pressed 
  bne noled1  // branch if button is not pressed  

	// button is pressed,
	str r6, [r2]  // switch pins defined in r2 on (IOSET1) (first LED on)
	mov r6, r6, lsl #1 // shift mask to second LED
	str r6, [r3]  // switch pins defined in r3 off (IOCLR1) (second LED off)
	b led_done  // brunch to end
	// button is not pressed 
  noled1: 
	str r6, [r3]  // switch pins defined in r3 off (IOCLR1) (first LED off)
	mov r6, r6, lsl #1 // shift mask to second LED
	str r6, [r2]  // switch pins defined in r2 on (IOSET1) (second LED on)
  led_done:  // End subrutine

  pop	{r0-r6,lr}
  bx	lr

// this function is void and need no input and returns nothing
taster311:

/* Idea:
 * 1. CLR LED1, Set LED0
 * 2. Wait for BT0 pressed
 * 3. CLR LED0, SET LED1
 * 4. Wait for BT0 pressed
 * 5. -> 1.
 */
  push	{r0, r1, r2, lr}
  bt_init:
	ldr r0,	=IODIR0		// get DIR_Reg0
	ldr r1, =BUTTON_bm	// get Bitmask
	and	r1,	r1, #0		// set all pins on bitmask to zero
	str	r1,	[r0]		// write IO_DIR0
  led_init:
	ldr r0, =IODIR1		// get DIR_Reg1
	ldr r1, =(LED0 | LED1) // get LED_Bitmasks
	str	r1, [r0]		// write to Reg

// BEGIN: Loop
loop_init:
  clrLed1:
	ldr r0, =IOCLR1
	ldr r1, =LED1
	str r1, [r0]
  setLed0:
	ldr r0,	=IOSET1		// get set reg of port1
	ldr	r1,	=LED0		// get LED0_Bitmask
	str	r1,	[r0]		// set LED0

loop:
	// best spot for a delay loop
	ldr		r0,	=IOPIN0			// get Port0 Status reg Adress
	ldr		r1,	=BUTTON_0_bm	// get Bitmask of bt0
	ldr 	r2,	[r0]			// get Port0 Status VALUES
	ands 	r2,	r2, r1			// get BT0 press-Status
	
	beq	loop

  clrLed0:
    ldr r0, =IOCLR1
	ldr r1, =LED0
	str r1, [r0]
  setLed1:
  	ldr r0,	=IOSET1		// get set reg of port1
	ldr	r1,	=LED1		// get LED1_Bitmask
	str	r1,	[r0]		// set LED1

loop1:
    // best spot for a delay loop
	ldr		r0,	=IOPIN0			// get Port0 Status reg Adress
	ldr		r1,	=BUTTON_0_bm	// get Bitmask of bt0
	ldr 	r2,	[r0]			// get Port0 Status VALUES
	ands 	r2,	r2, r1			// get BT0 press-Status
	beq	loop1
	// Another good spot for a delay loop
	b   loop_init

  pop	{r0, r1, r2, lr}
  bx 	lr



.end