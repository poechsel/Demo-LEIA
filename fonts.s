xor r0 r0 r0
call clearscr
refresh

letl r0 128
letl r1 20
letl r2 0
.set r3 msgline1
call putstr
letl r0 128
letl r1 20
letl r2 8
.set r3 msgline2
call putstr
letl r0 128
letl r1 20
letl r2 16
.set r3 msgline3
call putstr
letl r0 128
letl r1 20
letl r2 24
.set r3 msgline4
call putstr
letl r0 128
letl r1 20
letl r2 32
.set r3 msgline5
call putstr
letl r0 128
letl r1 20
letl r2 40
.set r3 msgline6
call putstr
letl r0 128
letl r1 20
letl r2 48
.set r3 msgline7
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
	;r4->screen ptr
	;r2->y
	;r0->col
	;r1->x
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

	.let r6 1280	
	sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	;sub r4 r4 r6
	__putchar_loopy:
		rmem r3 [r5]
		letl r2 8 
		add r4 r4 8
		__putchar_loopx:
			and r6 r3 1
			snif r6 neq 1
				wmem r0 [r4]
			sub r4 r4 1
			lsr r3 r3 1
			sub r2 r2 1
			snif r2 eq 0
				jump __putchar_loopx
		.let r6 160
		add r4 r4 r6
		letl r2 8
		add r4 r4 8
		__putchar_loopx2:
			and r6 r3 1
			snif r6 neq 1
				wmem r0 [r4]
			sub r4 r4 1
			lsr r3 r3 1
			sub r2 r2 1
			snif r2 eq 0
				jump __putchar_loopx2
		.let r6 160
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
msgline7:
.string "  5 ---- 6"
msgline6:
.word " "
.word "/"
.word "|"
.word " "
.word " "
.word " "
.word " "
.word " "
.word "/"
.word "|"
.word 0
msgline5:
.string	"2------3 |"
msgline4:
.word "|"
.word " "
.word "|"
.word " "
.word " "
.word " "
.word " "
.word "|"
.word " "
.word "|"
.word 0
msgline3:
.string	"| 4----|-7"
msgline2:
.word "/"
.word "|"
.word " "
.word " "
.word " "
.word " "
.word " "
.word "/"
.word "|"
.word " "
.word 0
msgline1:
.string	"1------0  "


#include fonts_data.s
