;letl r0 0
;call clearscr
;refresh

;letl r0 0xFF
;leth r0 0xFF

;.set r7 stack

;.let r0 0xffff
;letl r1 0
;letl r2 0
;letl r3 50
;letl r4 0
;letl r5 00
;letl r6 50


;call filltri
;refresh
;jump 0
;.let r6 359
;loop:
;.let r0 0
;call clearscr
;.set r1 projection_ortho
;.let r0 0xfc00
;call plot_head
;refresh
;sub r6 r6 1
;snif r6 eq 0
;	jump loop
;jump 0



;.let r6 359
.align16
plot_cube:
	.push r15
	;;r0 -> color
	;;r1 -> projection
	;;r6 -> angle
	;;conserve r6
	.push r6
	.push r0
	.push r1
	.let r0 8
	.pop r1
	.set r13 cube_points
	.set r14 cube_transformed_points
	call transform_points
	.let r0 12
	.set r13 cube_normals
	.set r14 cube_transformed_normals
	call transform_normals
	.let r6 12
	.pop r0
	.set r12 cube_transformed_normals
	.set r13 cube_triangles
	.set r14 cube_transformed_points
	call draw_faces
	.pop r6	
	.pop r15
	return

.align16
plot_sphere:
	.push r15
	;;r0 -> color
	;;r1 -> projection
	;;r6 -> angle
	;;conserve r6
	.push r6
	.push r0
	.push r1
	.let r0 114
	.pop r1
	.set r13 sphere_points
	.set r14 sphere_transformed_points
	call transform_points
	.let r0 224
	.set r13 sphere_normals
	.set r14 sphere_transformed_normals
	call transform_normals
	.let r6 224
	.pop r0
	.set r12 sphere_transformed_normals
	.set r13 sphere_triangles
	.set r14 sphere_transformed_points
	call draw_faces
	.pop r6	
	.pop r15
	return
.align16
plot_head:
	.push r15
	;;r0 -> color
	;;r1 -> projection
	;;r6 -> angle
	;;conserve r6
	.push r6
	.push r0
	.push r1
	.let r0 104
	.pop r1
	.set r13 head_points
	.set r14 head_transformed_points
	call transform_points
	.let r0 192
	.set r13 head_normals
	.set r14 head_transformed_normals
	call transform_normals
	.let r6 192
	.pop r0
	.set r12 head_transformed_normals
	.set r13 head_triangles
	.set r14 head_transformed_points
	call draw_faces
	.pop r6	
	.pop r15
	return
;loop:
;	letl r0 0
;	call clearscr
;	.let r0 8
;	.let r0 512
;	.set r1 projection_ortho
;	.set r13 cube_points
;	.set r14 cube_transformed_points
;	call transform_points
;	.let r0 12
;	.let r0 968
;	.set r13 cube_normals
;	.set r14 cube_transformed_normals
;	call transform_normals
;	.push r6
;	.let r6 12
;	.let r0 0xfc0f
;	.let r0 968
;	.set r12 cube_transformed_normals
;	.set r13 cube_triangles
;	.set r14 cube_transformed_points
;	call draw_faces
;	.pop r6	
;	refresh
;	sub r6 r6 1
;	snif r6 slt 0
;		jump loop
;jump 0


.align16
transform_points:
	.push r15
	copy r5 r0
	.set r9 __transform_points_rewrite
	lsr r1 r1 4
	.let r2 0xa000
	or r1 r2 r1
	wmem r1 [r9]
	__transform_points_loop:
		copy r3 r13
		add r3 r3 r5
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		rmem r2 [r3] 
		sub r3 r3 1
		rmem r1 [r3] 
		sub r3 r3 1
		rmem r0 [r3] 
		.push r13
		.push r14
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
		__transform_points_rewrite:
		call projection_ortho
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
		.pop r14
		.pop r13
		copy r3 r14
		;.set r3 transformed_points
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		wmem r2 [r3]
		sub r3 r3 1
		wmem r1 [r3]
		sub r5 r5 1
		snif r5 eq 0
			jump __transform_points_loop
	.pop r15
	return

.align16
transform_normals:
	.push r15
	copy r5 r0
	__transform_normals_loop:
		copy r3 r13
		add r3 r3 r5
		add r3 r3 r5
		add r3 r3 r5
		sub r3 r3 1
		rmem r2 [r3] 
		sub r3 r3 1
		rmem r1 [r3] 
		sub r3 r3 1
		rmem r0 [r3] 
		.push r13
		.push r14

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
		
		.pop r14
		.pop r13
		
		copy r3 r14
		add r3 r3 r5
		sub r3 r3 1
		wmem r2 [r3]
		sub r5 r5 1
		snif r5 eq 0
			jump __transform_normals_loop
	.pop r15
	return

;.align16
;draw_edges:
;	.push r15
;	.set r5 edges
;	.set r13 edges
;	add r5 r5 r0
;	add r5 r5 r0
;	__draw_edges_loop:
;		sub r5 r5 1
;		rmem r10 [r5]
;		sub r5 r5 1
;		rmem r11 [r5]
;		.push r5
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
;		rmem r4 [r11]
;		letl r0 0xff
;		call line
;		.pop r5
;
;		snif r5 eq r13
;			jump __draw_edges_loop
;	.pop r15
;	return

.align16
draw_faces:
	.push r15
;	copy r6 r0
	__draw_faces_loop:
		;test the normal
		copy r5 r12
		;.set r5 transformed_normals
		add r5 r5 r6
		sub r5 r5 1
		rmem r1 [r5]

	;	.let r0 0xfc00
		.push r0
		;; prepare the bitmap to darken areas that are not well aligned
		;; it willbe in the form dist dist dist
		.let r4 0x00ff
		and r3 r1 r4
		sub r3 r4 r3
		lsr r3 r3 2
		.let r4 0x003f
		and r3 r3 r4
		lsr r4 r3 1
		lsl r3 r3 5
		or r3 r3 r4
		lsl r3 r3 5
		or r3 r3 r4
		;lsl r3 r3 10
		lsl r2 r1 7
		and r0 r0 r3



		;copy r3 r1
		lsr r1 r1 15
		snif r1 eq 1
			jump __draw_faces_end
		print r3
		.push r6
		copy r5 r13
;		.set r5 triangles
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
		.push r12
		copy r12 r14
;		.set r12 transformed_points
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
		.push r14
		;.let r0 0x0008
		
		
		call filltri
		.pop r14
		.pop r13
		.pop r6
		.pop r12
		.pop r6
		__draw_faces_end:
		sub r6 r6 1
		.pop r0
		snif r6 eq 0
			jump __draw_faces_loop
	.pop r15
	return


.align16
filltri:
	.push r15
	.push r0

	.let r14 0x40 ;;minx
	.let r12 0x50 ;;maxx
	.let r15 0x34 ;;miny
	.let r13 0x44 ;;maxy

	copy r12 r1
	copy r14 r1
	snif r3 lt r12
		copy r12 r3
	snif r3 gt r14
		copy r14 r3
	snif r5 lt r12
		copy r12 r5
	snif r5 gt r14
		copy r14 r5
	copy r13 r2
	copy r15 r2
	snif r4 lt r13
		copy r13 r4
	snif r4 gt r15
		copy r15 r4
	snif r6 lt r13
		copy r13 r6
	snif r6 gt r15
		copy r15 r6
	add r0 r12 1
	copy r12 r0
	add r0 r13 1
	copy r13 r0


	;todo
	.set r10 __filltri_rewrite1
	copy r11 r12
	leth r11 0xce
	;.let r11 0xce50
	wmem r11 [r10]
	.set r10 __filltri_rewrite2
	copy r11 r13
	leth r11 0xce
	;.let r11 0xce44
	wmem r11 [r10]

	.set r10 __filltri_rewrite3
	copy r11 r14
	leth r11 0xc1
	;.let r11 0xc140
	wmem r11 [r10]
	.set r10 __filltri_rewrite4
	copy r11 r15
	leth r11 0xc2
	;.let r11 0xc234
	wmem r11 [r10]
	
	;.let r14 0x40
	;.let r15 0x34

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
	;copy r1 r4
	copy r1 r15
	sub r1 r1 r4
	.push r15
	call mul16
	.pop r15
	copy r0 r2
	.pop r3
	.pop r1
	.pop r2
	.push r2
	.push r1
	.push r0
	copy r0 r11
	copy r1 r14
	sub r1 r1 r3
	;copy r1 r3
	.push r15
	call mul16
	.pop r15
	.pop r0
	sub r0 r0 r2
	;sub r0 r2 r0
	.pop r1
	.pop r2

	.push r0


	.push r2
	.push r1
	copy r0 r9
	copy r1 r15
	sub r1 r1 r6
	;copy r1 r6
	.push r15
	call mul16
	.pop r15
	copy r0 r2
	.pop r1
	.pop r2
	.push r2
	.push r1
	.push r0
	copy r0 r12
	copy r1 r14
	sub r1 r1 r5
	;copy r1 r5
	.push r15
	call mul16
	.pop r15
	.pop r0
	sub r0 r0 r2
	;sub r0 r2 r0
	.pop r1
	.pop r2
	
	.push r0

	.push r1
	copy r0 r10
	copy r1 r15
	sub r1 r1 r2
	;copy r1 r2
	.push r15
	call mul16
	.pop r15
	copy r0 r2
	.pop r3
	.push r0
	copy r0 r13
	copy r1 r14
	sub r1 r1 r3
	.push r15
	call mul16
	.pop r15
	.pop r0

	sub r6 r0 r2
	.pop r5
	.pop r4

	

	

	

	.pop r0
	__filltri_rewrite4:
	letl r2 0
	leth r2 0
	;.let r14 68
	;.push r14
	;.let r14 80
	;.push r14
	;now we need to go through the screen
;	.let r15 0xaf60
	__filltri_loopy:
		__filltri_rewrite3:
		letl r1 0
		leth r1 0
		
		;.pop r14
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
				;wmem r0 [r15]
				call plotpx
;			add r1 r15 1
;			copy r15 r1
			.pop r2
			.pop r1

			sub r4 r4 r11
			sub r5 r5 r12
			sub r6 r6 r13
			add r1 r1 1
			__filltri_rewrite1:
			letl r14 160
			leth r14 0
			;.let r14 160
			snif r1 eq r14
				jump __filltri_loopx
		.pop r6
		.pop r5
		.pop r4
		add r4 r4 r8	
		add r5 r5 r9	
		add r6 r6 r10	
		add r2 r2 1
		;.let r14 128
	;	.pop r15
	;	.push r15
	;	.push r14
		__filltri_rewrite2:
		letl r14 128
		leth r14 0
		snif r2 eq r14
			jump __filltri_loopy
	;.pop r14
	;.pop r15
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
projection_ortho:
	asr r0 r0 3
	asr r1 r1 3
	letl r6 80
	add r0 r0 r6
	letl r6 64
	add r1 r1 r6
	return
	
.align16
projection_persp:
	;; project the point (r0; r1; r2) <- the coordinates are in the range [-1, 1]
	;; return the coordinates in (r0, r1)

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

	

#include mathlut.s
#include arithmetics.s
#include vfx.s
#include cube_data.s
#include sphere_data.s
#include head_data.s
;stack:
