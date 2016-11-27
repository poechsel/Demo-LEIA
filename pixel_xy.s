.align16
pixel_xy:
	;r1 <- x
	;r2 <- y
	;puts pixel (x,y)'s adress into r3
	;erases registers r4, r0
	;keeps r1,r2 values 
	.let r3 0xb000
	.let r4 160
	.let r0 127; on descend jusque y
	add_pixel_y:
		snif r0 neq r2
			jump end_add_y
		add r3 r3 r4
		sub r0 r0 1
		jump add_pixel_y

	end_add_y:

	.let r0 0 ; on monte jusque x
	add_pixel_x:
		snif r0 neq r1
			jump end_add_x
		add r0 r0 1
		add r3 r3 1
		jump add_pixel_x
	end_add_x:
	.let r4 0 ; reset r4
	.let r0 0 ; reset r0
	return
