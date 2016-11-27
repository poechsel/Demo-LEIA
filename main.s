.set r7 stack

.let r0 0
call clearscr
.let r0 0xffff
.let r1 20
.let r2 40
.let r3 1
.let r4 1
call fill
refresh

.let r0 0xf0ff
.let r1 102
.let r2 60
.let r3 150
.let r4 10
call fill
refresh

.let r0 0x00ff
.let r1 140
.let r2 110
.let r3 15
.let r4 100
call fill
refresh

.let r0 0x000f
.let r1 45
.let r2 65
.let r3 123
.let r4 78
call line
refresh


letl r0 0xFF
leth r0 0xFF
letl r1 1
letl r2 1
letl r6 60
letl r5 0
letl r14 104
leth r14 1
.let r11 0xffff
loop:
	.let r6 60
	.set r4 lut_cos
	add r4 r4 r5
	rmem r4 [r4]
	copy r2 r4
	asr r2 r2 3
	add r2 r2 r6

	.set r4 lut_sin
	add r4 r4 r5
	rmem r4 [r4]
	copy r1 r4
	asr r1 r1 3
	add r1 r1 r6
	
	copy r3 r6
	copy r4 r6
	copy r10 r5
	.let r0 180
	sub r0 r11 r0
	copy r11 r0
	call line
	copy r5 r10

	and r1 r5 3
	snif r1 neq 0
		refresh
	add r5 r5 1
	snif r5 eq r14
		jump loop


.let r0 30
call pause


jump 0



#include mathlut.s

print "done"
refresh
jump 0
#include vfx.s


.align16
pause:
	add r0 r0 1
	__pause_loop:
		refresh
		sub r0 r0 1
		snif r0 eq 0
			jump __pause_loop
	return

stack:
