letl r0 0
call clearscr
refresh
letl r0 0xFF
lerh r0 0xFF
letl r1 1
letl r2 1
letl r6 60
letl r7 0
letl r5 64
leth r5 0 
letl r14 104
leth r14 1
loop:
	.set r4 lut_cos
	add r4 r4 r7
	rmem r4 [r4]
	copy r2 r4
	asr r2 r2 3
	add r2 r2 r6

	.set r4 lut_sin
	add r4 r4 r7
	rmem r4 [r4]
	copy r1 r4
	asr r1 r1 3
	add r1 r1 r6
	call plotpx
	refresh
	add r7 r7 1
	snif r7 eq r14
		jump loop
jump 0


project_point:
	; r0 -> x
	; r1 -> y
	; r2 -> z
	letl r3 0
	leth r3 4
	add r3 r3 r2
	letl r4 0
	leth r4 255
	push r2
	push r1
	push r0
	copy r0 r4
	copy r1 r3
	call div
	copy r3 r2
	pop r0
	pop r1
	pop r2
	
	
	return
	


#include math.s
#include vfx.s
#include mathlut.s

points:
	.word 0x0100
	.word 0xFFFF
	.word 0x0100

	.word 0xFFFF
	.word 0xFFFF
	.word 0x0100

	.word 0xFFFF
	.word 0x0100
	.word 0x0100

	.word 0x0100
	.word 0x0100
	.word 0x0100

	.word 0xFFFF
	.word 0xFFFF
	.word 0xFFFF
	
	.word 0xFFFF
	.word 0x0100
	.word 0xFFFF

	.word 0x0100
	.word 0x0100
	.word 0xFFFF

	.word 0x0100
	.word 0xFFFF
	.word 0xFFFF
stack:
