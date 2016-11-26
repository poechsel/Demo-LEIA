.let r0 0
call clearscr
refresh

.let r0 0xb000
.let r10 160
snif r3 le r0
	.let r3 0xb0a2

.let r5 0xffff
.let r3 0xb0a2
.let r1 0xfba2

gliding:

copy r4 r3
wmem r5 [r3]
add r3 r3 r10
add r3 r3 1
wmem r5 [r3]
add r3 r3 r10
wmem r5 [r3]
sub r3 r3 1
wmem r5 [r3]
sub r3 r3 1
wmem r5 [r3]
copy r3 r4
add r3 r3 r10
add r3 r3 r10
add r3 r3 r10
add r3 r3 r10 
add r3 r3 r10
refresh

snif r1 eq r3
	jump gliding
refresh

.let r8 0xfc00 ; r8 is red
.let r9 0x03c0 ; r9 is green

.let r10 158; xmax
.let r11 126; ymax

;glider

.align16
loop_life:
	; r1 <- x from 0 to 159
	; r2 <- y from 0 to 127
	.let r2 127
	.let r3 0xb09e

	.align16
	life_y:
		sub r2 r2 1
		add r3 r3 2
		;;;print r3
		.let r1 0
		
		life_x:
			add r1 r1 1
			add r3 r3 1
			;;;print r3
			
			copy r12 r1
			copy r13 r2
			copy r14 r3
			;;;print "0"
			;;;print r14	
			.let r5 0 ; r5 will contain the sum of all side pixels
			.let r6 4
			
			sub r1 r1 1
			sub r3 r3 1 ; r3 has the adress
			call value_color; r5 gets added with [r3]'s value
			
			add r2 r2 1
			sub r3 r3 r10
			sub r3 r3 2
			call value_color
			
			add r1 r1 1
			add r3 r3 1
			call value_color
			
			add r1 r1 1
			add r3 r3 1
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
			
			sub r2 r2 1
			add r3 r3 r10
			add r3 r3 2
			call value_color
				
			snif r5 neq r6
				jump stop_calc  			
			
			sub r2 r2 1
			add r3 r3 r10
			add r3 r3 2
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
			
			sub r1 r1 1
			sub r3 r3 1
			call value_color
			
			snif r5 neq r6
				jump stop_calc  			
				
			sub r1 r1 1
			sub r3 r3 1
			call value_color
			
			stop_calc:
			
			copy r1 r12
			copy r2 r13
			copy r0 r3
			sub r0 r0 r10
			sub r0 r0 1
			snif r1 neq r10
				add r0 r0 1
			copy r14 r0
			call pixel_xy
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
				wmem r8 [r3]
				jump end_mark_color
			
			mark_green:
				wmem r9 [r3]
				jump end_mark_color
			
			s_is_3:
				.let r0 0
				rmem r4 [r3]
				snif r4 neq r0
					jump mark_green

jump end_mark_color			
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
	
			end_mark_color:

			snif r1 eq r10
				jump life_x
					

			.let r1 0
			.let r3 0xb000
			.let r6 0xff60
			loop_up: ; here we calculate the up border except the "coins"
				add r1 r1 1
				add r2 r2 1
					
				copy r14 r3
				.let r5 0 ; r5 will contain the sum of all side pixels
				.let r6 4
				
				sub r3 r3 1 ; r3 has the adress
				call value_color; r5 gets added with [r3]'s value
				
				xor r3 r3 r6
				xor r6 r3 r6
				xor r3 r3 r6
				
				call value_color
				
				add r3 r3 1
				call value_color
				
				add r3 r3 1
				call value_color
				
				snif r5 neq r6
					jump stop_calc  			
				
				add r3 r3 r10
				add r3 r3 2
				call value_color
					
				snif r5 neq r6
					jump stop_calc  			
				
				add r3 r3 r10
				add r3 r3 2
				call value_color
				
				snif r5 neq r6
					jump stop_calc  			
				
				sub r3 r3 1
				call value_color
				
				snif r5 neq r6
					jump stop_calc  			
					
				sub r3 r3 1
				call value_color
				
				stop_calc:
				
				call pixel_xy
				.let r0 2
				snif r5 neq r0
					jump end_up
				
				.let r0 3
				snif r5 neq r0
					jump s_is_3
				
				.let r0 0
				rmem r4 [r3]
				snif r4 eq r0
					jump mark_red
				
				jump end_mark_color			
				mark_red:
					wmem r8 [r3]
					jump end_up			
				mark_green:
					wmem r9 [r3]
					jump end_up
				
				s_is_3:
					.let r0 0
					rmem r4 [r3]
					snif r4 neq r0

				end_up:

				snif r1 eq r10
					jump loop_up
				




		.let r0 1	
		snif r2 eq r0
			jump life_y
	refresh	
	
	.let r3 0xb000
	.let r2 0xffff
	loop_refresh:
		add r3 r3 1	
		rmem r4 [r3]
				
		snif r4 eq r8; is r4 ([r3]'s pixel) red ?
			jump not_red
			.let r0 0
			wmem r0 [r3]
			jump end_refresh
		
		not_red:
		snif r4 eq r9; is r4 green ?
			jump end_refresh
			wmem r2 [r3]
		end_refresh:
	
		snif r2 eq r3
			jump loop_refresh

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

#include vfx.s
