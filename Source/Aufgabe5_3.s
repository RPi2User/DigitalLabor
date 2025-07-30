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
.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */
.equ BUTTON_0, (1<<10)          
.equ BUTTON_1, (1<<11)          
.equ BUTTON_2, (1<<12)          
.equ BUTTON_3, (1<<13)         

.equ LED_0, (1<<16)             
.equ LED_1, (1<<17)             
.equ LED_4, (1<<20)             
.equ LED_5, (1<<21)             

.equ PARTNER_SHIFT, 2          

.equ IOPIN0, 0xE0028000         // Adresse des Port-0-Pinwertregisters
.equ IOPIN1, 0xE0028010         // Adresse des Port-1-Pinwertregisters
.equ IOSET1, 0x4                // Adresse des Port-1-Ausgangs-Setzregisters
.equ IODIR1, 0x8                // Adresse des Port-1-Richtungsregisters
.equ IOCLR1, 0xC                // Adresse des Port-1-Ausgangs-Löschregisters

main:
       ldr r4, =IOPIN0            
       ldr r8, =IOPIN1            

       ldr r0, =0x00ff0000        // LED-Maske laden (Pins 16–23)
       ldr r1, [r8, #IODIR1]      // Liest den aktuellen Zustand des Port-1-Richtungsregisters
       orr r1, r0                 // Fügt die LED-Pins als Ausgänge hinzu
       str r0, [r8, #IODIR1]      // Speichert die manipulierte Konfiguration zurück in das Richtungsregister

loop:
       ldr r7, =BUTTON_0        // Lädt die Maske für Taste 0 in das Register r7
       ldr r6, =LED_0           // Lädt die Maske für LED 0 in das Register r6
       bl switch_led            // Springt zur Unterroutine switch_led

       ldr r7, =BUTTON_1        // Lädt die Maske für Taste 1 in das Register r7
       ldr r6, =LED_1           // Lädt die Maske für LED 1 in das Register r6
       bl switch_led            // Springt zur Unterroutine switch_led

       ldr r7, =BUTTON_2        // Lädt die Maske für Taste 2 in das Register r7
       ldr r6, =LED_4           // Lädt die Maske für LED 2 in das Register r6
       bl switch_led            // Springt zur Unterroutine switch_led

       ldr r7, =BUTTON_3        // Lädt die Maske für Taste 3 in das Register r7
       ldr r6, =LED_5           // Lädt die Maske für LED 3 in das Register r6
       bl switch_led            // Springt zur Unterroutine switch_led

       b loop                   // Springt zurück zur Schleife
switch_led:
       stmfd sp!, {r0, r5, r8, r9, lr}   // Sichert r0, r5, r8, r9 und lr auf dem Stack
       mov r5, r7                        // Lädt die Tastenmaske in r5
       mov r9, r6                        // Lädt die LED-Maske in r9
       ldr r0, [r4]                      // Liest die Werte der Tasten in r0 (IOPIN0)
       ands r0, r5, r0                   // Prüft, ob die entsprechende Taste gedrückt ist
       beq noled1                        // Springt zu noled1, wenn keine Taste gedrückt ist (z=1)

       str r9, [r8, #IOSET1]             // Wenn die Taste nicht gedrückt ist, schaltet die LED ein (IOSET1)
       mov r9, r9, lsl #2                // Verschiebt zur Partner-LED
       str r9, [r8, #IOCLR1]             // Schaltet die Partner-LED aus (IOCLR1)
       ldmfd sp!, {r0, r5, r8, r9, pc}   // Stellt r0, r5, r8, r9 und lr wieder her

noled1:                                  // Wenn die Taste gedrückt ist
       str r9, [r8, #IOCLR1]             // Schaltet die LED aus
       mov r9, r9, lsl #2                // Verschiebt zur Partner-LED
       str r9, [r8, #IOSET1]             // Schaltet die Partner-LED ein
       ldmfd sp!, {r0, r5, r8, r9, pc}   // Stellt r0, r5, r8, r9 und lr wieder her

stop:
    nop                                 
    bal stop                             

.end