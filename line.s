xor r0 r0 r0
call clearscr

xor r0 r0 r0
xor r1 r1 r1
xor r2 r2 r2
xor r3 r3 r3
xor r4 r4 r4
letl r1 0
letl r2 128
leth r2 0
letl r3 70
letl r4 60
letl r0 6
leth r0 0xff
call line
xor r1 r1 r1
xor r2 r2 r2
xor r3 r3 r3
xor r4 r4 r4
letl r1 50
letl r2 50
letl r3 70
letl r4 60
letl r0 128
call line
xor r1 r1 r1
xor r2 r2 r2
xor r3 r3 r3
xor r4 r4 r4
letl r1 49
letl r2 49
letl r3 30
letl r4 40
letl r0 68
call line


letl r0 0xff
leth r0 0
  letl r1 10
  letl r2 10
  letl r3 120
  leth r3 0
  letl r4 10
  xor r5 r5 r5
  xor r6 r6 r6
  xor r7 r7 r7
  call line
  letl r1 10
  letl r2 120
  leth r2 0
  letl r3 120
  leth r3 0
  letl r4 10
  call line
  letl r1 10
  letl r2 10
  letl r3 120
  leth r3 0
  letl r4 120
  leth r4 0
  call line

jump 0


	;r1 -> x1
	;r2 -> y1
	;r3 -> x2
	;r4 -> y2
	;r5 -> e
	;r6 -> dx
	;r7 -> dy

.align16
line:
	;http://www.falloutsoftware.com/tutorials/dd/dd4.htm
	;r0 -> couleur
	;r1 -> x1
	;r2 -> e
	;r3 -> screen_pointer

	;r5 -> memory

	;because apparently the origin is in bottom left
	letl r7 0x5f
	leth r7 0xff
	sub r2 r2 1
	lsl r6 r2 7
	sub r7 r7 r6
	lsl r6 r2 5
	sub r7 r7 r6
	add r7 r7 r1
	add r2 r2 1



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



	letl r4 -2
	__line_loop:
		wmem r0 [r7]
		snif r3 slt 0    ;e < 0
			jump __line_branch
		jump __line_branch_default
		__line_branch:
			sub r3 r3 r1
			add r7 r7 r6
		__line_branch_default:
			add r3 r3 r2
			add r7 r7 r5
		add r4 r4 2
		snif r4 eq r1
			jump __line_loop

	return


.align16
plotpx:
	xor r3 r3 r3
	leth r3 -80
	lsl r4 r2 7
	add r3 r3 r4
	lsl r4 r2 5
	add r3 r3 r4
	add r3 r3 r1
	wmem r0 [r3]
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
