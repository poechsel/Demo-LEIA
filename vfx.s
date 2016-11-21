.align16
line:
	;http://www.falloutsoftware.com/tutorials/dd/dd4.htm
	;r0 -> couleur
	;r1 -> x1
	;r2 -> e
	;r3 -> screen_pointer

	;r5 -> memory


	letl r5 0x5f
	leth r5 0xff
	;sub r2 r2 1 <- commented for a fix
	add r4 r4 1 ;<- also in the fix
	
	lsl r6 r2 7
	sub r5 r5 r6
	lsl r6 r2 5
	sub r5 r5 r6
	add r5 r5 r1
	add r2 r2 1
	.push r5

	snif r3 ge r1   ;si x2 >= x1
		jump __line_ifr3ger1
	sub r1 r3 r1
	letl r5 1
	jump __line_ifr3ger1end
	__line_ifr3ger1:
		sub r1 r1 r3
		letl r5 -1
	__line_ifr3ger1end:
	
	snif r4 ge r2   ;si y2 >= y1
		jump __line_ifr4ger2
	sub r2 r4 r2
	letl r6 0x60
	leth r6 0xff
	jump __line_ifr4ger2end
	__line_ifr4ger2:
		sub r2 r2 r4
		letl r6 160
		leth r6 0x00
	__line_ifr4ger2end:


	snif r1 le r2  ;dx >= dy
		jump __line_ifdxgedyend
		;now inverts the dx and invert the i_
		xor r1 r1 r2
		xor r2 r1 r2
		xor r1 r1 r2
		xor r6 r6 r5
		xor r5 r6 r5
		xor r6 r6 r5
	__line_ifdxgedyend:
	xor r3 r3 r3   ;set up e
	sub r3 r3 r1
	add r2 r2 r2	;dy = 2dy
	add r1 r1 r1    ;dx = 2dx
	add r3 r3 r2	;e = 2dy - dx


	copy r8 r2
	.pop r2
	letl r4 -2
	__line_loop:
		wmem r0 [r2]
		snif r3 slt 0    ;e < 0
			jump __line_branch
		jump __line_branch_default
		__line_branch:
			sub r3 r3 r1
			add r2 r2 r6
		__line_branch_default:
			add r3 r3 r8
			add r2 r2 r5
		add r4 r4 2
		snif r4 eq r1
			jump __line_loop

	return


.align16
plotpx:
	;; (0, 0) is in bottom left corner
	add r2 r2 1
	lsl r3 r2 7
	lsl r2 r2 5
	add r3 r3 r2
	letl r2 0
	sub r2 r2 r3
	add r3 r2 r1
	wmem r0 [r3]
	return

.align16
clearscr:
	;; here we don't mind where is (0, 0): is is enough to walkthrough the whole screen
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
