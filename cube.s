letl r0 0
call clearscr
refresh
letl r0 0xFF
leth r0 0xFF

.set r14 stack


letl r6 0x67
leth r6 0x1
loop:
	.set r13 points
	.set r7 points
	add r7 r7 12 
	add r7 r7 12 
	letl r0 0
	call clearscr
	verts_loop:
		sub r7 r7 1
		rmem r2 [r7] 
		sub r7 r7 1
		rmem r1 [r7] 
		sub r7 r7 1
		rmem r0 [r7] 
		push r7
		push r13
		push r6

		push r2
		copy r2 r6
		call rotation ;rotate on axis z
		pop r2

		pop r6
		push r6
		
		push r1
		copy r1 r2
		copy r2 r6
		call rotation
		copy r2 r1
		pop r1

		call projection

		copy r2 r1
		copy r1 r0
		letl r0 0xFF
		pop r6
		call plotpx
		pop r13
		pop r7

		snif r7 eq r13
			jump verts_loop

	refresh
	sub r6 r6 1
	snif r6 eq 0
		jump loop
jump 0


.align16
rotation:
	;;r0 <- x
	;;r1 <- y
	;;r2 <- theta (in degre)
	;;we compute x' = x * cos(t)-y*sin(t) and y' = x*sin(t)+y*cos(t)
	push r15
	.set r4 lut_cos
	add r4 r4 r2
	rmem r12 [r4] ;;r12 is cos(t)
	.set r4 lut_sin
	add r4 r4 r2
	rmem r13 [r4] ;;r13 is sin(t)
	


	copy r10 r0
	copy r11 r1
	
	copy r0 r10
	copy r1 r12
	call multfloat
	push r0		;; x * cos(t)
	
	copy r0 r10
	copy r1 r13
	call multfloat
	push r0		;; x * sin(t)

	copy r0 r11
	copy r1 r12
	call multfloat
	push r0		;; y * cos(t)

	copy r0 r11
	copy r1 r13
	call multfloat
	push r0		;; y * sin(t)

	pop r5
	pop r1
	pop r4
	pop r0

	sub r0 r0 r5
	add r1 r1 r4
	pop r15
	return

.align16
projection:
	;; project the point (r0; r1; r2) <- the coordinates are in the range [-1, 1]
	;; return the coordinates in (r0, r1)
	push r15
	letl r6 5
	lsl r6 r6 7

	add r2 r2 r6
	add r2 r2 1
	copy r6 r2
	;we augment the precision
	lsl r0 r0 4
	lsl r1 r1 4
	
	push r1
	copy r1 r6
	call divs
	copy r8 r2
	pop r0

	copy r1 r6
	call divs
	copy r1 r2
	copy r0 r8

	letl r6 64
	add r1 r1 r6
	letl r6 80
	leth r6 0
	add r0 r0 r6
	pop r15
	return
;.set r4 lut_cos
	;add r4 r4 r7
	;rmem r4 [r4]
	;copy r2 r4
	;asr r2 r2 3
	;add r2 r2 r6

	;.set r4 lut_sin
	;add r4 r4 r7
	;rmem r4 [r4]
	;copy r1 r4
	;asr r1 r1 3
	;add r1 r1 r6
	;call plotpx
	;refresh
	;add r7 r7 1
	
	;snif r7 eq r13
	;	jump loop

	


#include arithmetics.s
#include vfx.s
#include mathlut.s

points:
	.word 0x0100
	.word 0xFF00
	.word 0x0100

	.word 0xFF00
	.word 0xFF00
	.word 0x0100

	.word 0xFF00
	.word 0x0100
	.word 0x0100

	.word 0x0100
	.word 0x0100
	.word 0x0100

	.word 0xFF00
	.word 0xFF00
	.word 0xFF00
	
	.word 0xFF00
	.word 0x0100
	.word 0xFF00

	.word 0x0100
	.word 0x0100
	.word 0xFF00

	.word 0x0100
	.word 0xFF00
	.word 0xFF00
stack:
