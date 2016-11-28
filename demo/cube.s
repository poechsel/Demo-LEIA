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


.align16
transform_points:
	; r13 -> adress to the points
	; r14 -> adress to the transformed_points
	; r0 -> number of point
	.push r15
	copy r5 r0
	.set r9 __transform_points_rewrite
	lsr r1 r1 4
	.let r2 0xa000
	or r1 r2 r1
	wmem r1 [r9]
	__transform_points_loop:
		; get the current point
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

		; rotate it
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
		.pop r5
		.pop r14
		.pop r13
		copy r3 r14
		; write the 2d point in memory
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
	; r13 -> adress of normals
	; r14 -> adress of transformed normals
	; r0 -> number of normals
	; does the same thing than transform_normals except it is for normals
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
		
		; we only keep the z coordinates because it is the only one useful for us
		copy r3 r14
		add r3 r3 r5
		sub r3 r3 1
		wmem r2 [r3]
		sub r5 r5 1
		snif r5 eq 0
			jump __transform_normals_loop
	.pop r15
	return

;; this code could draw_edges. Not compatible with current version
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
		;; it will be in the form dist dist dist
		;; Their is a little hack: when the color is red we use an other way to compute the color to avoid "black triangles" due to the loss of precision when masking
		.let r4 0xfc00
		snif r0 eq r4
			jump __draw_faces_notred
		jump __draw_faces_red
		__draw_faces_notred:
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
			and r0 r0 r3
		jump __draw_faces_endcolor
		__draw_faces_red:
			lsl r2 r1 7
			and r0 r0 r2
		__draw_faces_endcolor:

		lsr r1 r1 15
		; if the triangle have a normal directed toward us, then we draw them (backface culling)
		snif r1 eq 1
			jump __draw_faces_end
		.push r6
		copy r5 r13
		; get the index of the points of the triangle
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
		; get the points corresponding to each index
		copy r12 r14
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
	; r0 -> color
	; draw the triangle ((r1, r2), (r3, r4), (r5, r6)) to the screen and fill it with color r0
	;; we first compute the bounding box. Then for each pixel of this bounding box we check thanks to the sign of 3 crossproducts wether it is inside the triangle or not
	;; to accelerate the process we develop the formula of the crossproducts: after pretreatements only one addition per pixel is needed to compute them 
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


	; rewrite the code to take into account the bounding box
	.set r10 __filltri_rewrite1
	copy r11 r12
	leth r11 0xce
	wmem r11 [r10]
	.set r10 __filltri_rewrite2
	copy r11 r13
	leth r11 0xce
	wmem r11 [r10]

	.set r10 __filltri_rewrite3
	copy r11 r14
	leth r11 0xc1
	wmem r11 [r10]
	.set r10 __filltri_rewrite4
	copy r11 r15
	leth r11 0xc2
	wmem r11 [r10]
	

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
	

	; compute the cross product for the first point we are going to walk through
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


	
	; now go through all pixels of the bounding box

	.pop r0
	__filltri_rewrite4:
	letl r2 0
	leth r2 0
	__filltri_loopy:
		__filltri_rewrite3:
		letl r1 0
		leth r1 0
		.push r4
		.push r5
		.push r6
		__filltri_loopx:
		
			.push r1
			.push r2
			or r3 r4 r5
			or r3 r3 r6
			lsr r3 r3 15
			
			snif r3 eq 1
				;wmem r0 [r15]
				call plotpx
			.pop r2
			.pop r1

			sub r4 r4 r11
			sub r5 r5 r12
			sub r6 r6 r13
			add r1 r1 1
			__filltri_rewrite1:
			letl r14 160
			leth r14 0
			snif r1 eq r14
				jump __filltri_loopx
		.pop r6
		.pop r5
		.pop r4
		add r4 r4 r8	
		add r5 r5 r9	
		add r6 r6 r10	
		add r2 r2 1
		__filltri_rewrite2:
		letl r14 128
		leth r14 0
		snif r2 eq r14
			jump __filltri_loopy
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
; orthogonal projection of point (r0, r11 r2)
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

	

#include mathlut.s
#include arithmetics.s
#include vfx.s
#include cube_data.s
#include sphere_data.s
#include head_data.s
