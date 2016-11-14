xor r0 r0 r0
call clearscr
refresh
;letl r0 128
;letl r1 20
;letl r2 0
;letl r3 65
;call putchar
;jump 0

;xor r1 r1 r1
;letl r0 72
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'E'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'L'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'L'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'O'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 32
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'W'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'o'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'r'
;wmem r0 [r1]
add r1 r1 1
;letl r0 'l'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 'd'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 '!'
;wmem r0 [r1]
;add r1 r1 1
;letl r0 0
;wmem r0 [r1]
.set r1 message
letl r0 128
letl r1 20
letl r2 0
.set r3 message
call putstr
jump 0

.align16
putstr:
	copy r6 r3
	__putstr_loop:
		rmem r3 [r6]
		copy r10 r1
		copy r11 r2
		copy r12 r3
		copy r13 r6
		copy r14 r15
		call putchar
		refresh
		copy r1 r10
		copy r2 r11
		copy r3 r12
		copy r6 r13
		copy r15 r14
		add r6 r6 1
		add r1 r1 8
		snif r3 eq 0
			jump __putstr_loop
	return

.align16
putchar:
	;letl r4 0xff
	;leth r4 0x4f
	;add r2 r2 1
	;lsl r6 r2 7
	;sub r4 r4 r6
	;lsl r6 r2 5 
	;sub r4 r4 r6
	;add r4 r4 r1
add r2 r2 1
lsl r4 r2 7
lsl r2 r2 5
add r4 r4 r2
letl r2 0
sub r2 r2 r4
add r4 r2 r1

	.set r5 font
	;sub r5 r5 1
	add r3 r3 r3
	add r3 r3 r3
	add r5 r5 r3
	
	letl r6 160
	leth r6 0
	;sub r6 r6 8
	xor r2 r2 r2
	letl r1 4
	letl r2 7

	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	sub r4 r4 r6
	__putchar_loopy:
		rmeml r3 [r5]
		letl r2 8 
		add r4 r4 8
		__putchar_loopx:
			and r7 r3 1
			snif r7 neq 1
				wmem r0 [r4]
			sub r4 r4 1
			lsr r3 r3 1
			sub r2 r2 1
			snif r2 eq 0
				jump __putchar_loopx
		add r4 r4 r6
		letl r2 8
		add r4 r4 8
		__putchar_loopx2:
			and r7 r3 1
			snif r7 neq 1
				wmem r0 [r4]
			sub r4 r4 1
			lsr r3 r3 1
			sub r2 r2 1
			snif r2 eq 0
				jump __putchar_loopx2
		add r4 r4 r6
		add r5 r5 1
		sub r1 r1 1
		snif r1 eq 0
			jump __putchar_loopy
	return

.align16
clearscr:
	letl r1 0
	leth r1 -80
	;leth r1 0
	;lsl r1 r1 12
	____loop_clrscr:
		wmem r0 [r1]
		add r1 r1 1
		snif r1 eq 0
			jump ____loop_clrscr
	return
message:
.string "Hello world!"
#include fonts_data.s
