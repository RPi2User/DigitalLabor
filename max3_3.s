.text /* Specify that code goes in text segment */
.code 32 /* Select ARM instruction set */
.global main /* Specify global symbol */


variable:
.word 0x51  //8
.word 0x40  //0 
.word 0x90  //8
.word 0x50  //0
.word 0x83  //8
.word 0x20  //0
.word 0x10  //0
.word 0x54  //8
.align 4

main:

  .equ PARAMETER,  3
  .equ SCHWELLENWERT, 80
  mov r0, #0  //zielregister
  mov r1, #SCHWELLENWERT //schwellenwert
  mov r2, #8  //anzahl schleifensprünge
  mov r4, #0  //vorinitialisierung des registers für variableninhalt
  ldr r5, =variable //r5 als adresse von variable definireren
  mov r6, #PARAMETER

while:

  ldr r4, [r5], #4      //register mit mit variableninhalt laden
  mov   r0, r0, lsl #4  //shift um einen nibble im zielregister nach links
  cmp   r4, r1          //vergleich mit schwellwert  
  movle r4, #0          //wenn < oder == als schwellwert lege 0 ins zielregister //bei optimierung irrelevant
  movgt r4, #8          //wenn > schwellwert lade 8 ins register
  orr   r0, r4          //verodern der werte des zielregisters mit denen des variableninhalt

  mov r6,   #5
  str r6,[sp,#-4]!
  mov r6,   #0xff       // mache hier mal r6 sichtbar "kaputt" um zu zeigen, dass wir über den Stack arbeiten
  bl delaySUB

  subs  r2, #1          //anzahl scleifen reduzieren 
  bne   while           //sprung zum schleifenanfang wenn r2 größer 0



stop:
    nop
    bal stop


delaySUB:
  
  ldr  r6, [sp],#4
  stmfd sp!, {r0-r6, lr}
  
delay:
  
  sub r6,             #1
  cmp r6,             #0

  bne delay

  ldmfd sp!, {r0-r6, pc}

.end