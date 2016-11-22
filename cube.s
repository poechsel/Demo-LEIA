letl r0 0
call clearscr
;refresh

letl r0 0xFF
leth r0 0xFF

.set r14 stack
.set r7 stack

.let r0 0xffff
letl r1 0
letl r2 0
letl r3 50
letl r4 0
letl r5 00
letl r6 50


call filltri
;refresh
;jump 0


.let r6 359
loop:
	letl r0 0
	call clearscr
;	.set r13 points
;	.set r3 points
;	.set r5 transformed_points
;	add r3 r3 12 
;	add r3 r3 12 
;	add r5 r5 8
;	add r5 r5 8
;	verts_loop:
;		sub r3 r3 1
;		rmem r2 [r3] 
;		sub r3 r3 1
;		rmem r1 [r3] 
;		sub r3 r3 1
;		rmem r0 [r3] 
;		.push r6
;		.push r5
;		.push r3
;		.push r13
;		.push r6
;
;		.push r2
;		copy r2 r6
;		call rotation ;rotate on axis z
;		.pop r2
;
;		.pop r6
;		.push r6
;		
;		.push r1
;		copy r1 r2
;		copy r2 r6
;		call rotation
;		copy r2 r1
;		.pop r1
;		call projection
;		copy r2 r1
;		copy r1 r0
;		letl r0 0xFF
;		.pop r6
;		.push r1
;		.push r2
;		call plotpx
;		.pop r2
;		.pop r1
;		.pop r13
;		.pop r3
;		.pop r5
;
;		sub r5 r5 1
;		wmem r2 [r5]
;		sub r5 r5 1
;		wmem r1 [r5]
;		snif r3 eq r13
;			jump verts_loop
	.let r5 8
	verts_loop:
		.set r3 points
		add r3 r3 r5
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		rmem r2 [r3] 
		sub r3 r3 1
		rmem r1 [r3] 
		sub r3 r3 1
		rmem r0 [r3] 
;		.push r6
		.push r5
		.push r6

		.push r2
		copy r2 r6
		call rotation ;rotate on axis z
		.pop r2

		.pop r6
		.push r6
	
		.push r1
		copy r1 r2
		copy r2 r6
		call rotation
		copy r2 r1
		.pop r1
		call projection
		copy r2 r1
		copy r1 r0
		letl r0 0xFF
		.pop r6
;		.push r1
;		.push r2
;		call plotpx
;		.pop r2
;		.pop r1
		.pop r5

		.set r3 transformed_points
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		wmem r2 [r3]
		sub r3 r3 1
		wmem r1 [r3]
		sub r5 r5 1
		snif r5 eq 0
			jump verts_loop
	.let r5 12
	normals_loop:
		.set r3 normals
		add r3 r3 r5
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		rmem r2 [r3] 
		sub r3 r3 1
		rmem r1 [r3] 
		sub r3 r3 1
		rmem r0 [r3] 
		.push r5
		.push r6

		.push r2
		copy r2 r6
		call rotation ;rotate on axis z
		.pop r2

		.pop r6
		.push r6
	
		.push r1
		copy r1 r2
		copy r2 r6
		call rotation
		copy r2 r1
		.pop r1
		.pop r6
		.pop r5
		.set r3 transformed_normals
		add r3 r3 r5
		sub r3 r3 1
		wmem r2 [r3]
		sub r5 r5 1
		snif r5 eq 0
			jump normals_loop



	.push r6

	.let r6 12
	faces_loop:
		;test the normal
		.set r5 transformed_normals
		add r5 r5 r6
		sub r5 r5 1
		rmem r1 [r5]
		.let r0 0xfc00
		lsl r2 r1 7
		and r0 r0 r2
		lsr r1 r1 15
		snif r1 eq 1
			jump faces_end
		.push r6
		.set r5 triangles
		add r5 r5 r6
		add r5 r5 r6
		add r6 r5 r6
		sub r6 r6 1
		rmem r9 [r6]
		sub r6 r6 1
		rmem r10 [r6]
		sub r6 r6 1
		rmem r11 [r6]
		.pop r6
		.push r6
		.set r12 transformed_points
		copy r6 r9
		lsl r6 r6 1
		add r6 r6 r12
		rmem r1 [r6]
		add r6 r6 1
		rmem r2 [r6]
		
		copy r6 r10
		lsl r6 r6 1
		add r6 r6 r12
		rmem r3 [r6]
		add r6 r6 1
		rmem r4 [r6]
		
		copy r6 r11
		lsl r6 r6 1
		add r6 r6 r12
		rmem r5 [r6]
		add r6 r6 1
		.push r6
		rmem r6 [r6]
		
		.push r13
		;.let r0 0x0008
		
		
		call filltri
		.pop r13
		.pop r6
		.pop r6
		faces_end:
		sub r6 r6 1
		snif r6 eq 0
			jump faces_loop

;	.set r5 edges
;	.set r13 edges
;	add r5 r5 12
;	add r5 r5 12
;	edges_loop:
;		sub r5 r5 1
;		rmem r10 [r5]
;		sub r5 r5 1
;		rmem r11 [r5]
;		.push r5
;		.set r12 transformed_points
;		copy r5 r10
;		lsl r5 r5 1
;		add r5 r5 r12
;		copy r10 r5
;
;		copy r5 r11
;		lsl r5 r5 1
;		add r5 r5 r12
;		copy r11 r5
;
;		rmem r1 [r10]
;		copy r5 r10
;		add r5 r5 1
;		copy r10 r5
;		rmem r2 [r10]
;		rmem r3 [r11]
;		copy r5 r11
;		add r5 r5 1
;		copy r11 r5
;		rmem r4 [r11]
;		letl r0 0xff
;		.push r15
;		call line
;		.pop r15
;		.pop r5
;
;		snif r5 eq r13
;			jump edges_loop
;
	.pop r6	
	refresh
	sub r6 r6 1
	snif r6 slt 0
		jump loop
jump 0


.align16
filltri:
	.push r15

	;todo
	.push r0

	;; compute the increments
	sub r0 r5 r3
	copy r8 r0		;v2.x - v1.x
	sub r0 r1 r5
	copy r9 r0		;v0.x - v2.x
	sub r0 r3 r1
	copy r10 r0		;v1.x - v0.x
	sub r0 r6 r4
	copy r11 r0		;v2.y - v1.y
	sub r0 r2 r6
	copy r12 r0		;v0.y - v2.y
	sub r0 r4 r2
	copy r13 r0		;v1.y - v0.y
	

	.push r2
	.push r1
	.push r3
	copy r0 r8
	copy r1 r4
	call mul16
	copy r0 r2
	.pop r3
	.pop r1
	.pop r2
	.push r2
	.push r1
	.push r0
	copy r0 r11
	copy r1 r3
	call mul16
	.pop r0
	sub r0 r2 r0
	.pop r1
	.pop r2

	.push r0


	.push r2
	.push r1
	copy r0 r9
	copy r1 r6
	call mul16
	copy r0 r2
	.pop r1
	.pop r2
	.push r2
	.push r1
	.push r0
	copy r0 r12
	copy r1 r5
	call mul16
	.pop r0
	sub r0 r2 r0
	.pop r1
	.pop r2
	
	.push r0

	.push r1
	copy r0 r10
	copy r1 r2
	call mul16
	copy r0 r2
	.pop r1
	.push r0
	copy r0 r13
	call mul16
	.pop r0

	sub r6 r2 r0
	.pop r5
	.pop r4

	
	.pop r0
	.let r2 0
	;now we need to go through the screen
	.let r15 0xaf60
	__filltri_loopy:
		.let r1 0
		.push r4
		.push r5
		.push r6
		__filltri_loopx:
		
			.push r1
			.push r2
			or r3 r4 r5
			or r3 r3 r6
			lsr r3 r3 15
			;.let r0 465
			
			snif r3 eq 1
				wmem r0 [r15]
				;call plotpx
			add r1 r15 1
			copy r15 r1
			.pop r2
			.pop r1

			sub r4 r4 r11
			sub r5 r5 r12
			sub r6 r6 r13
			add r1 r1 1
			.let r14 160
			snif r1 eq r14
				jump __filltri_loopx
		.pop r6
		.pop r5
		.pop r4
		add r4 r4 r8	
		add r5 r5 r9	
		add r6 r6 r10	
		add r2 r2 1
		.let r14 128
		snif r2 eq r14
			jump __filltri_loopy
;	refresh
	.pop r15
	return




.align16
rotation:
	;;r0 <- x
	;;r1 <- y
	;;r2 <- theta (in degre)
	;;we compute x' = x * cos(t)-y*sin(t) and y' = x*sin(t)+y*cos(t)
	.push r15
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
	.push r0		;; x * cos(t)
	
	copy r0 r10
	copy r1 r13
	call multfloat
	.push r0		;; x * sin(t)

	copy r0 r11
	copy r1 r12
	call multfloat
	.push r0		;; y * cos(t)

	copy r0 r11
	copy r1 r13
	call multfloat
	.push r0		;; y * sin(t)

	.pop r5
	.pop r1
	.pop r4
	.pop r0

	sub r0 r0 r5
	add r1 r1 r4
	.pop r15
	return

.align16
projection:
	;; project the point (r0; r1; r2) <- the coordinates are in the range [-1, 1]
	;; return the coordinates in (r0, r1)
	;asr r0 r0 3
	;asr r1 r1 3
	;letl r6 64
	;add r0 r0 r6
	;add r1 r1 r6
	;return

	.push r15
	letl r6 5
	lsl r6 r6 7

	add r2 r2 r6
	add r2 r2 1
	copy r6 r2
	;we augment the precision
	lsl r0 r0 4
	lsl r1 r1 4
	
	.push r1
	copy r1 r6
	call divs
	copy r8 r2
	.pop r0

	copy r1 r6
	call divs
	copy r1 r2
	copy r0 r8

	letl r6 64
	lsl r1 r1 1
	add r1 r1 r6
	letl r6 80
	leth r6 0
	lsl r0 r0 1
	add r0 r0 r6
	.pop r15
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
normals:
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100

	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000

	.word 0x0100
	.word 0x0000
	.word 0x0000
	.word 0x0100
	.word 0x0000
	.word 0x0000

	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000

	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00

	.word 0x0000
	.word 0xFF00
	.word 0x0000
	.word 0x0000
	.word 0xFF00
	.word 0x0000
transformed_normals:
	.reserve 12

triangles:
	.word 3
	.word 1
	.word 0
	.word 3
	.word 2
	.word 1

	.word 6
	.word 5
	.word 2
	.word 2
	.word 3
	.word 6

	.word 0
	.word 7
	.word 6
	.word 6
	.word 3
	.word 0

	.word 4
	.word 1
	.word 2
	.word 2
	.word 5
	.word 4

	.word 7
	.word 4
	.word 5
	.word 5
	.word 6
	.word 7

	.word 4
	.word 7
	.word 0
	.word 0
	.word 1
	.word 4



;triangles:
;	.word 0
;	.word 1
;	.word 3
;
;	.word 1
;	.word 2
;	.word 3
;
;	.word 2
;	.word 5
;	.word 6
;
;	.word 6
;	.word 3
;	.word 2
;
;	.word 6
;	.word 7
;	.word 0
;
;	.word 0
;	.word 3
;	.word 6
;
;	.word 2
;	.word 1
;	.word 4
;
;	.word 4
;	.word 5
;	.word 2
;
;	.word 5
;	.word 4
;	.word 7
;
;	.word 7
;	.word 6
;	.word 5
;
;	.word 0
;	.word 7
;	.word 4
;
;	.word 4
;	.word 1
;	.word 0
stack:
