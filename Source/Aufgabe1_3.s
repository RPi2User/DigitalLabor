/*
 * Aufgabe_1_3.S
 *
 * SoSe 2024
 *
 *    Created on: 2024-04-03
 *        Author: hafl1012
 *
 *	Aufgabe : Flags und bedingte Ausführung
 *            AI = true, sadly hat die auch nicht wirklich geholfen >.<
 */
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
main:

// ----------------------------------------------------------------------------
// REGION Part 1
part1:

    mov r0, #10 // y-threshold
    mov r1, #0    // x-value

    cmp r1, r0        // Use compare

    blt r1_0
    // VALUE GEQ THRESH
    mov r1, #0xFF
    bal part2

r1_0:
    // VALUE LESS THEN THRESH
    mov r1, #0x00
equ THRESHOLD, 10

// ----------------------------------------------------------------------------
// REGION PART 2
part2:

    // x:= threshold - 1
    mov r0, #THRESHOLD     // y-threshold
    mov r1, #THRESHOLD-1     // x-value
    cmp r1, r0        // Use compare
    movlt r1, #0
    movge r1, #0xFF

    // x:= threshold
    mov r0, #10     // y-threshold
    mov r1, #10     // x-value
    cmp r1, r0        // Use compare
    movlt r1, #0
    movge r1, #0xFF

    // x:= threshold + 1
    mov r0, #THRESHOLD     // y-threshold
    mov r1, #THRESHOLD+1     // x-value
    cmp r1, r0        // Use compare
    movlt r1, #0
    movge r1, #0xFF

    // x:= 0
    mov r0, #10     // y-threshold
    mov r1, #0     // x-value
    cmp r1, r0        // Use compare
    movlt r1, #0
    movge r1, #0xFF

    // x:= 65535
    mov r0, #10        // y-threshold
    mov r1, #65536 // x-value
    cmp r1, r0         // Use compare
    movlt r1, #0
    movge r1, #0xFF

// ----------------------------------------------------------------------------

stop:
	nop
	bal stop
.end

// ----------------------------------------------------------------------------