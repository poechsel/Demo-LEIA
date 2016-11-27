; anime un feu
.align16
fire:
	.push r15
	; boucle principale
	.let r8 15 
	.let r10 0xffff ; blanc
	.let r9 0x001f ; 31
	.let r2 27
	.let r11 159
	.let r0 130
	__fire_loop:
		.push r0
		.let r0 0
		call loop_fire
		.pop r0
		sub r0 r0 1
		snif r0 eq 0
			jump __fire_loop
	.pop r15
	return

.align16
loop_fire:
	.push r15
	; randomize the bottom row
	.let r4 0xff5f ; memory adress
	add r2 r2 1
	snif r2 neq r9
		.let r2 15
	.align16
	__fire_loop_random:
		.let r1 52
		copy r0 r2

		;;pseudo-random generator
		;;calculates r2*49%31 -> number in [1..30] sin
		;; 31 is prime
		call mul16 ; r0*r1 -> r2
		
		__fire_modulo: ; does r2 % r9 operation
			snif r2 ge r9
				jump __fire_end_modulo
			sub r2 r2 r9
		jump __fire_modulo
		__fire_end_modulo:
		call color_fire ; puts fire color in r0, input r2
		add r4 r4 1
		wmem r0 [r4]

		snif r4 eq r10
			jump __fire_loop_random
	
	refresh
	.let r4 0xafff; 1 unit before start of screen
	.let r5 0xffff ; x = -1
	__fire_refresh_fire:
		add r4 r4 1
		add r5 r5 1

		.let r0 0
		copy r13 r4

		snif r5 neq r0
			jump __fire_left_f

		snif r5 neq r11
			jump __fire_right_f
		
		;if r4 is inside the screen
		__fire_inside:
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

			jump __fire_end_refresh
		
		__fire_left_f:
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

			jump __fire_end_refresh
		
		__fire_right_f:
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

		__fire_end_refresh:
		
		.let r1 32
		call mul16 ; sum*32 -> r2

		copy r0 r2
		.let r1 129
		call div ; sum*32 / 129 == sum * 4.20

		copy r4 r13
		wmem r2 [r4]

		
		snif r4 eq r10
			jump __fire_refresh_fire
	refresh
	.pop r15
	return
#include arithmetics.s
#include vfx.s
#include fire_colors.s
