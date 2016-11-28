.align16
illuminati:
	; 0xfc00 red
	; 0x03c0 green
	; 0x003f blue
	.push r15
	.let r8 0xfc00
	.let r9 0x03c0
	.let r10 0x003f

	; limites pour x et y
	.let r11 158 ; x_max
	.let r12 0 ; y_min

	.let r0 0xffff
	call clearscr
	refresh 

	.let r0 135
	__illuminati_loop:
		.push r0
		call illuminati_loop_iter
		.pop r0
		sub r0 r0 1
		snif r0 eq 0
			jump __illuminati_loop

	.pop r15
	return


.align16
illuminati_loop_iter:
	.push r15	
	.let r0 1; x from 0 to 159
	.let r1 126; y from 0 to 127
	.let r2 0xb0a1;
	
	__illuminati_loop_y:	
		sub r1 r1 1
		add r2 r2 1
		add r2 r2 1
		.let r0 1
		add r2 r2 1 
		__illuminati_loop_x:
			add r0 r0 1
			add r2 r2 1
			
			.let r3 0
			copy r4 r2
			
			add r4 r4 1
			call add_vital_energy
			
			sub r4 r4 2
			call add_vital_energy
			
			add r4 r4 r11
			add r4 r4 2
			call add_vital_energy
			
			add r4 r4 1
			call add_vital_energy
			
			add r4 r4 1
			call add_vital_energy
			
			sub r4 r4 r11
			sub r4 r4 2
			call add_vital_energy
			
			sub r4 r4 1
			call add_vital_energy

			sub r4 r4 1
			call add_vital_energy

			rmem r4 [r2] ; pixel r4
			.let r5 3
			snif r3 eq r5 ; s vaut-il 3 ?
				jump othercase ; si oui, sauter cette instruction
				.let r5 0 ; noir
				snif r4 eq r5 ; le pixel est-il noir ? 
					jump othercase ; si oui, sauter cette instruction
					.let r9 0x03c0 ; vert
					wmem r9 [r2] ; nouvelle naissance
			othercase:
			.let r5 2 
			snif r3 neq r5 ; s vaut-il qqch différent de 2 ?
				jump __illuminati_end ; si oui, sauter cette instruction
			; s est différent de 2 et 3
			.let r5 0xffff ; blanc
			snif r4 eq r5 ; le pixel est-il blanc ?	
				jump __illuminati_end ; si oui, sauter cette instruction
				.let r8 0xfc00 ; rouge
				wmem r8 [r2]; le pixel devient rouge
			__illuminati_end:
		        
			snif r0 eq r11		
				jump __illuminati_loop_x
		;refresh
		snif r1 eq r12
			jump __illuminati_loop_y

		refresh
		refresh
		refresh
;maintenant, on actualise, càd on fait mourir les rouges et vivre les verts

	.let r0 1
	.let r1 126
	.let r2 0xb09d

	__illuminati_end_y:
		sub r1 r1 1
		add r2 r2 1
		add r2 r2 1
		.let r0 1
		add r2 r2 1 
		__illuminati_end_x:
			add r0 r0 1
			add r2 r2 1

			rmem r3 [r2]; pixel r3
			.let r8 0xfc00; rouge
			snif r3 eq r8; est-il rouge ?
			jump first_out; si oui, sauter cette instruction
			.let r4 0
			wmem r4 [r2] ; le pixel devient noir
			first_out:
			.let r9 0x03c0 ; vert
			snif r3 eq r9 ; est-il vert ?
			jump __illuminati_end_refresh ; si oui, sauter cette instruction
			.let r4 0xffff ; blanc
			wmem r4 [r2] ; le pixel devient blanc
			__illuminati_end_refresh:
			snif r0 eq r11 ; si y=127
				jump __illuminati_end_x
		;refresh
		snif r1 eq r12
			jump __illuminati_end_y
		refresh
	.pop r15
	return
;	jump __illuminati_loop_iter

.align16
add_vital_energy:
	; add pixel [r4]'s vital energy (which is 0 if black or green and 1 if white or red) to r3
	rmem r5 [r4]; pixel r5
	.let r6 0xffff; blanc
	snif r5 eq r6; est-il blanc ?
		jump snd_add; si oui, sauter cette instruction
		add r3 r3 1; ajouter 1 au compteur
	snd_add:
	.let r6 0xfc00; rouge
	snif r5 eq r6; est-il rouge ?
		jump end_add; si oui, sauter cette instruction
		add r3 r3 1
	end_add:
	return
#include vfx.s

