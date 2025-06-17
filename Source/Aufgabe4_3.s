/*
 * Aufgabe_4_3.S
 *
 * SoSe 2024
 *
 *  Created on: <$Date>
 *      Author: <$Name>
 *
 *    Aufgabe : Maximalwert eines Datenblocks ermitteln
 */

.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */

.data



ERROR:      .byte 0   // 4-Bit Status-/Fehlercode

// Status Bitmasks
.equ    STATUS_ILLEGAL_DATA_BLOCK,  0x1
.equ    STATUS_NO_DATA,             0x2
.equ    STATUS_MINIMUM_EXISTS,      0x4
.equ    STATUS_MAXIMUM_EXISTS,      0x8
.equ    STATUS_OK,                  0


VALID_HEADER:
    .hword 0xaaaa

Datablock_1:
    .hword 0xAAAA
    .byte 2
    .byte 0
    .byte 0
    .byte 0
    .byte 10, 127
    .align 2

Datablock_2:
    .hword 0xAAAA
    .byte 6
    .byte 0
    .byte 0
    .byte 0
    .byte 11, 1, 60, 30, 70, 55
    .align 2

Datablock_3:
    .hword 0xAFFA
    .byte 10
    .byte 0
    .byte 0
    .byte 0
    .byte -1, 60, 2, 59, 3, 58, 4, 15, 0, 6
    .align 2

Datablock_4:
    .hword 0xAAAA
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .align 2

// ------------------------------------------------------------------


// ---CODE-SEGMENT---------------------------------------------------
.text
main:


    ldr r4, =Datablock_4

check_header:
    ldrh    r0, [r4, #0]            // load header from Datablock
    ldr     r7, =VALID_HEADER   // load address of VALID_HEADER
    ldrh    r7, [r7, #1]        // load value of VALID_HEADER
    cmp     r0, r7              // compare with valid header value
    bne     illegalDataBlock    // branch if not equal

    // set header[3]status[0] to 1 → DATA_EXISTS
    ldrb    r0, [r4, #3]    // r0 := StatusByte -> block[3]
    orr     r0, #1          // set status[0] to 1
    strb    r0, [r4, #3]    // store StatusByte

	// Check datablock size
    ldrb    r0, [r4, #2]    // load r0 := block[2]
    cmp     r0, #0          // check if size == zero
    beq     noData          // branch if true


    bl  min // min()
    bl  max // max()

    // Set ERROR to STATUS_OK
    // If we reach here, datablock is valid
    ldr     r0, =STATUS_OK  // set status to OK
    ldr     r4, =ERROR      // load address of ERROR
    strb    r0, [r4]        // store status in ERROR

	b stop                  // branch to stop

// ---MINIMUM--------------------------------------------------------
// Calculate minimum value in the datablock
// The minimum value is stored at datablock[min] (offset 4)
// The status bit STATUS_MINIMUM_EXISTS is set at datablock[3] if a minimum value is found

min:
    push    {r1-r7, lr}     // Save used registers and link register

    mov     r1, r4          // r1 = pointer to current datablock
    ldrb    r2, [r1, #2]    // r2 = size (number of data bytes)
    add     r3, r1, #6      // r3 = pointer to first data byte
    mov     r5, #127        // r5 = current minimum (init to max possible)

    mov     r6, #0          // r6 = loop counter

min_loop:
    cmp     r6, r2      // while (counter < size)
    bge min_done

    ldrb r7, [r3, r6]               // load data byte: r7 = data[r6]
    cmp r7, r5                      // compare with current min
    movlt r5, r7                    // if (data < min) min = data

    add r6, r6, #1                  // counter++
    b min_loop

min_done:
    strb r5, [r1, #4]               // store min at datablock[min] (offset 4)

    // set min bit in status
    ldrb r7, [r1, #3]               // load status from header[3]
    orr r7, r7, #0x02
    strb r7, [r1, #3]               // store updated status

    mov     r0,	#STATUS_MINIMUM_EXISTS // set error code
    ldr     r4, =ERROR         // load address of ERROR
    strb    r0, [r4]         // store error code

    pop {r1-r7, lr}                 // Restore registers and return
    bx lr
// ------------------------------------------------------------------


// ---MAXIMUM--------------------------------------------------------
// Calculate maximum value in the datablock
// The maximum value is stored at datablock[max] (offset 5)
// The status bit STATUS_MAXIMUM_EXISTS is set if a maximum value is found
// If no data is present, the function will branch to noData

max:
    push {r1-r7, lr}                // Save used registers and link register

    mov r1, r4                      // r1 = pointer to current datablock
    ldrb r2, [r1, #2]               // r2 = size (number of data bytes)
    add r3, r1, #6                  // r3 = pointer to first data byte
    mov r5, #-128                      // r5 = current maximum (init to min possible)

    mov r6, #0                      // r6 = loop counter

max_loop:
    cmp r6, r2                      // while (counter < size)
    bge max_done

    ldrb r7, [r3, r6]               // load data byte: r7 = data[r6]
    cmp r7, r5                      // compare with current max
    movgt r5, r7                    // if (data > max) max = data

    add r6, r6, #1                  // counter++
    b max_loop

max_done:
    strb r5, [r1, #5]               // store max at datablock[max] (offset 5)

    // set max bit in status
    ldrb r7, [r1, #3]               // load status
    orr r7, r7, #0x04
    strb r7, [r1, #3]               // store updated status

    mov     r0,	#STATUS_MAXIMUM_EXISTS // set error code
    ldr     r4, =ERROR         // load address of ERROR
    strb    r0, [r4]         // store error code

    pop {r1-r7, lr} 
    bx lr

// ------------------------------------------------------------------



// ---ERROR-HANDLING-------------------------------------------------
illegalDataBlock:
    mov     r0,    #STATUS_ILLEGAL_DATA_BLOCK  // set error code
    ldr     r4, =ERROR                      // load address of ERROR
    strb    r0, [r4]                        // store error code
    b stop

noData:
    mov     r0,	#STATUS_NO_DATA // set error code
    ldr     r4, =ERROR         // load address of ERROR
    strb    r0, [r4]         // store error code
    b stop

stop:
    nop
    bal stop
.end