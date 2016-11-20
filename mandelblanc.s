.set r7 stack
;;we draw for x in [-2; .5] (increment of 4) and y in [-1.25, 1.25] (ie increment of 5)

.let r0 0xffff
call clearscr
refresh


;;parameters of refinment: r6 = 16 & r7 = 0x07

.let r0 159
.let r2 128 ; r3 = 1.25
loop_x:
	.let r1 127
	.let r3 260 ; r2 = .5
	loop_y:
		.push r2
		.push r3
		.push r0
		.push r1
		copy r13 r3
		copy r12 r2
		xor r4 r4 r4 ;an
		xor r5 r5 r5 ;bn
		.let r6 31	 ;max nb of iter
		loop_iter:
			.push r6
			copy r11 r5
			copy r10 r4
			.push r4
			copy r0 r10
			copy r1 r10
			call multfloat
			.pop r4
			copy r8 r0
			add r4 r0 0
			.push r4
			copy r0 r11
			copy r1 r11
			call multfloat
			.pop r4
			copy r9 r0
			sub r4 r4 r0
			add r4 r4 r12 ;done with an

			.push r4
			.push r5
			copy r0 r10
			copy r1 r11
			call multfloat
			.pop r5
			.pop r4
			add r5 r0 0
			add r5 r5 r0
			add r5 r5 r13 ;done with bn

			;now compute the norm
			add r6 r9 0

			add r6 r6 r8
			.let r8 0x0400
			snif r6 gt r8
				jump iter_end

			letl r0 0xff
			.pop r6
						
			xor r0 r0 r0
			copy r0 r6
			.let r0 0
			.pop r2
			.pop r1
			
			.push r1
			.push r2
			call plotpx
			letl r6 1
			.push r6

			iter_end:
			.pop r6
			sub r6 r6 1
			snif r6 eq 0
				jump loop_iter
		;jump 0
			
		.pop r1
		.pop r0
		.pop r3
		.pop r2
		sub r1 r1 1
		sub r3 r3 4
		snif r1 eq -1
			jump loop_y
	sub r0 r0 1
	sub r2 r2 4
	;print r0
	snif r0 eq -1
		jump loop_x

refresh

.let r8 0xfc00 ; r8 is red
.let r9 0x03c0 ; r9 is green

.let r10 158; xmax
.let r11 126; ymax

;glider
.let r5 0xffff
.let r1 2
.let r2 126
call pixel_xy
wmem r5 [r3]
;print r3
add r1 r1 1
sub r2 r2 1
call pixel_xy
wmem r5 [r3]
sub r2 r2 1
call pixel_xy
wmem r5 [r3]
sub r1 r1 1
call pixel_xy
wmem r5 [r3]
sub r1 r1 1
call pixel_xy
wmem r5 [r3]
refresh 

.align16
loop_life:
	; r1 <- x from 0 to 159
	; r2 <- y from 0 to 127
	.let r1 0
	
	.align16
	life_x:
		add r1 r1 1
		.let r2 0
	
		life_y:
			add r2 r2 1
			
			copy r12 r1
			copy r13 r2
				
			.let r5 0 ; r5 will contain the sum of all side pixels
			.let r6 4
			
			sub r1 r1 1
			call pixel_xy ; r3 has the adress
			call value_color; r5 gets added with [r3]'s value

			add r2 r2 1
			call pixel_xy
			call value_color
			
			add r1 r1 1
			call pixel_xy
			call value_color
			
			add r1 r1 1
			call pixel_xy
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
			
			sub r2 r2 1
			call pixel_xy
			call value_color
				
			snif r5 neq r6
				jump stop_calc  			
			
			sub r2 r2 1
			call pixel_xy
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
			
			sub r1 r1 1
			call pixel_xy
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
			
			sub r1 r1 1
			call pixel_xy
			call value_color
			
			stop_calc:

			copy r1 r12
			copy r2 r13
			
			;print r5 	
			call pixel_xy
			;print r3
			.let r0 2
			snif r5 neq r0
				jump end_mark_color
			
			.let r0 3
			snif r5 neq r0
				jump s_is_3

			.let r0 0
			rmem r4 [r3]
			snif r4 eq r0
				jump mark_red
			
			jump end_mark_color			
			mark_red:
				.let r8 0xfc00
				wmem r8 [r3]
				jump end_mark_color
			mark_green:
				.let r9 0x03c0
				wmem r9 [r3]
				jump end_mark_color
			s_is_3:
				.let r0 0
				rmem r4 [r3]
				snif r4 neq r0
					jump mark_green
				
			end_mark_color:

			snif r2 eq r11
				jump life_y
		
		snif r1 eq r10
			jump life_x
	refresh		

	.let r1 0
	refresh_x:
		add r1 r1 1
		.let r2 0
		
		refresh_y:
			add r2 r2 1
			
			call pixel_xy; we see [r3]'s pixel
			rmem r4 [r3]
					
			snif r4 eq r8; is r4 ([r3]'s pixel) red ?
				jump not_red
				.let r0 0
				wmem r0 [r3]
				jump end_refresh_y
			
			not_red:
			.let r9 0x03c0
			snif r4 eq r9; is r4 green ?
				jump end_refresh_y
				.let r0 0xffff
				wmem r0 [r3]
		
			end_refresh_y:
			
			snif r2 eq r11
				jump refresh_y
		
		snif r1 eq r10
			jump refresh_x

	refresh
jump loop_life
	
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

.align16
value_color:
	; r3 <- a pixel's adress
	; r5 : counter
	; add 1 to r5 if [r3]'s white or red, 0 if it is black or green
	; erases r0, r4
	
	rmem r4 [r3]
	snif r4 neq r8
		jump value_red
	.let r0 0xffff
	snif r4 neq r0 
		jump value_white
	
	jump end_value
	value_red:
		add r5 r5 1
		jump end_value
	value_white:
		add r5 r5 1	
		jump end_value

	end_value:
	return

#include vfx.s
#include arithmetics.s
stack:
