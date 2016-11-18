letl r0 0
call clearscr
refresh
letl r0 0xFF
leth r0 0xFF

.set r14 stack


letl r0 20
letl r1 20
letl r2 50
letl r3 0
letl r4 70
letl r5 50

call filltri2

;jump 0

letl r6 0x67
leth r6 0x1
loop:
	.set r13 points
	.set r7 points
	.set r5 transformed_points
	add r7 r7 12 
	add r7 r7 12 
	add r5 r5 8
	add r5 r5 8
	letl r0 0
	call clearscr
	verts_loop:
		sub r7 r7 1
		rmem r2 [r7] 
		sub r7 r7 1
		rmem r1 [r7] 
		sub r7 r7 1
		rmem r0 [r7] 
		push r5
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
		push r1
		push r2
		;call plotpx
		pop r2
		pop r1
		pop r13
		pop r7
		pop r5

		sub r5 r5 1
		wmem r2 [r5]
		sub r5 r5 1
		wmem r1 [r5]
		
		snif r7 eq r13
			jump verts_loop

	.set r7 edges
	.set r13 edges
	add r7 r7 12
	add r7 r7 12
	print "new loop"
	edges_loop:
		sub r7 r7 1
		rmem r10 [r7]
		sub r7 r7 1
		rmem r11 [r7]
		print "current"
		print r7
		print r10
		print r11
		push r7
		.set r12 transformed_points
		copy r7 r10
		lsl r7 r7 1
		add r7 r7 r12
		copy r10 r7

		copy r7 r11
		lsl r7 r7 1
		add r7 r7 r12
		copy r11 r7

		rmem r1 [r10]
		copy r7 r10
		add r7 r7 1
		copy r10 r7
		rmem r2 [r10]
		rmem r3 [r11]
		copy r7 r11
		add r7 r7 1
		copy r11 r7
		rmem r4 [r11]
		letl r0 0xff
		push r15
		push r6
		call line
		pop r6
		pop r15
		pop r7

		snif r7 eq r13
			jump edges_loop
	.set r7 triangles
	add r7 r7 12
	add r7 r7 12
	add r7 r7 12
	.set r13 triangles
	push r6
	faces_loop:
		sub r7 r7 1
		rmem r9 [r7]
		sub r7 r7 1
		rmem r10 [r7]
		sub r7 r7 1
		rmem r11 [r7]
		push r7
		.set r12 transformed_points
		copy r7 r9
		lsl r7 r7 1
		add r7 r7 r12
		rmem r1 [r7]
		add r7 r7 1
		rmem r2 [r7]
		
		copy r7 r10
		lsl r7 r7 1
		add r7 r7 r12
		rmem r3 [r7]
		add r7 r7 1
		rmem r4 [r7]
		
		copy r7 r11
		lsl r7 r7 1
		add r7 r7 r12
		rmem r5 [r7]
		add r7 r7 1
		rmem r6 [r7]
		
		push r13
		.let r0 0x0008
		
		call filltri2

		pop r13
		pop r7
		snif r7 eq r13
			jump faces_loop


	pop r6	
	refresh
	sub r6 r6 1
	snif r6 eq 0
		jump loop
jump 0

.align16
filltri2:
	push r15

	copy r13 r6
	copy r12 r5
	copy r11 r4
	copy r10 r3
	copy r9 r2
	copy r8 r1
	;;r6 <- color
	.let r7 128
	__filltri2_loopy:
		.let r6 160
		__filltri2_loopx:
			push r0
			copy r1 r6
			copy r2 r7
			push r6 
			push r7

			copy r0 r10
			copy r1 r11
			copy r2 r12
			copy r3 r13
			copy r4 r6
			copy r5 r7
			call orientpointtri
			
			pop r7
			pop r6
			push r7
			push r6
			push r0

			copy r0 r12
			copy r1 r13
			copy r2 r8
			copy r3 r9
			copy r4 r6
			copy r5 r7
			call orientpointtri
			pop r5
			pop r6
			pop r7
			add r5 r5 r0
			push r7
			push r6 
			push r5
			
			copy r0 r8
			copy r1 r9
			copy r2 r10
			copy r3 r11
			copy r4 r6
			copy r5 r7
			call orientpointtri
			pop r5
			pop r6
			pop r7
			add r5 r5 r0

			.let r0 0xff00
			copy r1 r6
			copy r2 r7
			pop r0
			snif r5 neq 0
				call plotpx
			sub r6 r6 1
			snif r6 eq -1
				jump __filltri2_loopx
		sub r7 r7 1
		snif r7 eq -1
			jump __filltri2_loopy
	
	refresh
	pop r15
	return

.align16
orientpointtri:
	;;param: r0, r1, r2, r3, r4, r5 the coordinates (r0 is A, r1 is B and r2 the current pt (or C here)
	push r15
	sub r5 r5 r1 ; <- r5 = C.y - A.y
	sub r2 r2 r0 ; <- r2 = B.x - A.x
	sub r3 r3 r1 ; <- r3 = B.y - A.y
	sub r4 r4 r0 ; <- r4 = C.x - A.x
	push r3
	push r4
	copy r0 r2
	copy r1 r5
	call mul16
	copy r0 r2
	pop r4
	pop r3
	push r0
	copy r0 r3
	copy r1 r4
	call mul16
	pop r0
	sub r0 r0 r2
	lsr r0 r0 15
	pop r15
	return


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
transformed_points:
	.reserve 16
edges:
	.word 0	
	.word 1
	
	.word 0	
	.word 7
	
	.word 0	
	.word 3
	
	.word 1
	.word 2
	
	.word 1	
	.word 4
	
	.word 2		
	.word 3
	
	.word 2		
	.word 5
	
	.word 3	
	.word 6
	
	.word 4	
	.word 7
	
	.word 4
	.word 5
	
	.word 5	
	.word 6
	
	.word 6	
	.word 7
triangles:
	.word 0
	.word 1
	.word 3

	.word 1
	.word 2
	.word 3

	.word 2
	.word 5
	.word 6

	.word 6
	.word 3
	.word 2

	.word 6
	.word 7
	.word 0

	.word 0
	.word 3
	.word 6

	.word 2
	.word 1
	.word 4

	.word 4
	.word 5
	.word 2

	.word 5
	.word 4
	.word 7

	.word 7
	.word 6
	.word 5

	.word 0
	.word 7
	.word 4

	.word 4
	.word 1
	.word 0
stack:
