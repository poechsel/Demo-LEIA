
.align16
glid_w:
.push r15
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
print "coucou"
snif r1 eq r3
	jump gliding
;print coucou
refresh 
.pop r15
return

;.let r10 158; xmax
;.let r11 126; ymax

;glider

.align16
;loop_life:
lifegame:
.push r15
	.let r8 0xfc00 ; r8 is red
	.let r9 0x03c0 ; r9 is green
	; r1 <- x from 0 to 159
	; r2 <- y from 0 to 127
	.let r1 0
	.let r3 0xb000
	
	.align16
	life_x:
		add r1 r1 1
		.let r2 0
		add r3 r3 1
		
		life_y:
			add r2 r2 1
			sub r3 r3 r10
			sub r3 r3 2
			
			copy r12 r1
			copy r13 r2
			copy r14 r3
			;print "0"
			;print r14	
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
			;print "1"
			;print r14
			copy r3 r14
			;print r3
			call pixel_xy
			;print "2" 
			;print r3
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

			snif r2 eq r11
				jump life_y
		
		snif r1 eq r10
			jump life_x
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
	.pop r15
	return
;jump loop_life
	
.align16
pixel_xy:
	;r1 <- x
	;r2 <- y
	;puts pixel (x,y)'s adress into r3
	;erases registers r4, r0
	;keeps r1,r2 values 
	add r0 r2 1
	lsl r3 r0 7
	lsl r0 r0 5
	add r3 r3 r0
	letl r0 0
	sub r0 r0 r3
	add r3 r0 r1
	return

#include vfx.s
