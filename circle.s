letl r0 0
call clearscr
refresh
letl r0 0xFF
leth r0 0xFF
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
	;asr r4 r4 4
	;add r2 r4 r6
	;and r4 r4 r5

	;.set r4 lut_sin
	;add r4 r4 r7
	;rmem r4 [r4]
	;asr r4 r4 4
	;add r1 r4 r6
	;copy r1 r7
	call plotpx
	refresh
	add r7 r7 1
	snif r7 eq r14
		jump loop
jump 0



#include vfx.s
#include mathlut.s
