; anime un feu
.let r0 0
call clearscr
refresh

; boucle principale
.let r10 0xffff ; blanc
.let r9 0x001f ; 47 : couleur max + 1
.let r11 159
.let r2 45
.align16
loop_fire:
	
	.let r8 15 ; used in fire_colors.s
	; randomize the bottom row
	.let r4 0xff5f ; memory adress
	
	add r2 r2 r11 ; décalage
	snif r2 lt r9 ; reste dans les couleurs définies
		.let r2 45

	modulo: ; does r2 % r9 operation
		snif r2 ge r9
			jump end_modulo
		sub r2 r2 r9
	jump modulo
	end_modulo:
	
	.align16
	loop_random:
		.let r1 69 ; multiplicateur
		copy r0 r2 

		;;pseudo-random generator
		;;calculates r2*r1% -> number in [1..46] sin
		;; 47 is prime
		call mul16 ; r0*r1 -> r2
		
		modulo: ; does r2 % r9 operation
			snif r2 ge r9
				jump end_modulo
			sub r2 r2 r9
		jump modulo
		end_modulo:
		
		call color_fire ; puts fire color in r0, input r2
		
		add r4 r4 1
		wmem r0 [r4]

		snif r4 eq r10
			jump loop_random
	;; inutilisés :
	;; r2, r8
	refresh
	.let r4 0xafff; 1 unit before start of screen
	.let r5 0 ; x
	refresh_fire:
		; r11 = 159
		snif r5 le r11 ; si r5 = 160, on le ramène à 0
			.let r5 0

		add r4 r4 1
		add r5 r5 1

		copy r13 r4
		
		.let r0 1
		snif r5 neq r0
			jump left_f
	
		.let r0 160
		snif r5 neq r0
			jump right_f
		
		;if r4 is inside the screen
		inside:
			.let r0 0
			add r4 r4 r11
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6
			
			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 r11
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			jump end_refresh
		
		left_f:
			.let r0 0
			add r4 r4 r11
			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 r11
			sub r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6
			
			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			jump end_refresh
		
		right_f:
			.let r0 0
			add r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 r11
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			sub r4 r4 1
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

			add r4 r4 2
			add r4 r4 r11
			rmem r6 [r4]
			call int_fire
			add r0 r0 r6

		end_refresh:
		
		.let r1 110
		call mul16 ; sum*32 -> r2

		copy r0 r2
		.let r1 420
		call div ; sum*32 / 129 == sum * 4.20
	
		.let r8 15
		;print r2
		call color_fire
		;print r0

		copy r4 r13
		wmem r0 [r4]

		snif r4 eq r10
			jump refresh_fire
	refresh
	jump loop_fire

#include arithmetics.s
#include vfx.s
#include fire_colors.s
#include int_of_fire.s
