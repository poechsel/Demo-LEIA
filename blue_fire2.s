; anime un feu

.let r0 0
call clearscr
refresh
; boucle principale

.let r8 15 
.let r10 0xffff ; blanc
.let r9 0x001f ; 31
.let r2 27
.let r11 159
.let r12 0xff5f

.align16
loop_fire:	
	; randomize the bottom row
	.let r4 0xff5f ; memory adress
	.align16
	loop_random:
		.let r1 51
		copy r0 r2
		;;pseudo-random generator
		;;calculates r2*49%31 -> number in [1..30] sin
		;; 31 is prime
		call mul16 ; r0*r1 -> r2
		
		modulo: ; does r2 % r9 operation
			snif r2 ge r9
				jump end_modulo
			sub r2 r2 r9
		jump modulo
		end_modulo:
		;print r2
		call color_fire ; puts fire color in r0, input r2
		;print r0
		add r4 r4 1
		wmem r0 [r4]

		snif r4 eq r10
			jump loop_random
	
	refresh
	print "ref"
	.let r4 0xafff; 1 unit before start of screen
	.let r5 0xffff ; x = -1
	refresh_fire:
		add r4 r4 1
		
		snif r5 neq r11
			.let r5 0xffff
		
		add r5 r5 1
		
		.let r0 0
		copy r13 r4

		snif r5 neq r0
			jump left_f

		snif r5 neq r11
			jump right_f
		
		;if r4 is inside the screen
		inside:
			add r4 r4 r11
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 r11
			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			jump end_refresh
		
		left_f:
			add r4 r4 r11
			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 r11
			sub r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6
			
			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			jump end_refresh
		
		right_f:
			add r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 r11
			rmem r6 [r4]
			add r0 r0 r6

			sub r4 r4 1
			rmem r6 [r4]
			add r0 r0 r6

			add r4 r4 3
			add r4 r4 r11
			rmem r6 [r4]
			add r0 r0 r6

		end_refresh:
		
		.let r1 32
		call mul16 ; sum*32 -> r2
		
		copy r0 r2
		.let r1 142
		call div ; sum*32 / 129 == sum / 4.20
		
		copy r4 r13
		wmem r2 [r4]
		
		snif r4 eq r12
			jump refresh_fire
	refresh
	jump loop_fire

#include arithmetics.s
#include vfx.s
#include fire_colors.s
