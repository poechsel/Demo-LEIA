.set r7 stack

; 0xfc00 red
; 0x03c0 green
; 0x003f blue
.let r8 0xfc00
.let r9 0x03c0
.let r10 0x003f

; limites pour x et y
.let r11 158 ; x_max
.let r12 0 ; y_min

; to do :
; meta-converter .let -> two instructions letl leth
; done

.let r0 0xffff
call clearscr
refresh

;glider
;.let r0 0xb0a2
;.let r1 0xffff;blanc
;wmem r1 [r0]
;add r0 r0 r11
;add r0 r0 3
;wmem r1 [r0]
;add r0 r0 r11
;wmem r1 [r0]
;add r0 r0 1
;wmem r1 [r0]
;add r0 r0 1
;wmem r1 [r0]
;refresh 

.align16
loop_iter:
	
	.let r0 1; x from 0 to 159
	.let r1 126; y from 0 to 127
	.let r2 0xb09d;
	
	.align16
	loop_y:	
		sub r1 r1 1
		add r2 r2 1
		add r2 r2 1
		.let r0 1 
		.align16
		loop_x:
			add r0 r0 1
			add r2 r2 1
			
			.let r3 0
			copy r4 r2 ; adresse r4
			
			add r4 r4 1 ; on regarde à droite de r4
			call add_vital_energy
			
			sub r4 r4 2 ; à gauche
			call add_vital_energy
			
			add r4 r4 r11 ; en bas à gauche
			add r4 r4 2
			call add_vital_energy
			
			add r4 r4 1 ; en bas
			call add_vital_energy
			
			add r4 r4 1 ; en bas à droite
			call add_vital_energy
			
			sub r4 r4 r11 ; en haut à droite
			sub r4 r4 2 
			call add_vital_energy
			
			sub r4 r4 1 ; en haut
			call add_vital_energy

			sub r4 r4 1 ; en haut à gauche
			call add_vital_energy
			; alors, r3 vaut s
			rmem r4 [r2] ; pixel r4
			.let r5 3 ; 3
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
				jump end ; si oui, sauter cette instruction
			; s est différent de 2 et 3
			.let r5 0xffff ; blanc
			snif r4 eq r5 ; le pixel est-il blanc ?	
				jump end ; si oui, sauter cette instruction
				.let r8 0xfc00 ; rouge
				;print r3
				wmem r8 [r2]; le pixel devient rouge
			end:
			;print r0
		        .let r11 158
			snif r0 eq r11		
				jump loop_x
		;refresh
		snif r1 eq r12
			jump loop_y
		;refresh
;maintenant, on actualise, càd on fait mourir les rouges et vivre les verts

	.let r0 1
	.let r1 126
	.let r2 0xb09d

	.align16
	refresh_y:
		sub r1 r1 1
		add r2 r2 1
		add r2 r2 1
		.let r0 1
		add r2 r2 1 
		.align16
		refresh_x:
			add r0 r0 1
			add r2 r2 1

			rmem r3 [r2]; pixel r3
			.let r8 0xfc00; rouge
			snif r3 eq r8; est-il rouge ?
			jump first_out; si oui, sauter cette instruction
			.let r4 0
			;print "2"
			;print r4
			wmem r4 [r2] ; le pixel devient noir
			first_out:
			.let r9 0x03c0 ; vert
			snif r3 eq r9 ; est-il vert ?
			jump end_refresh ; si oui, sauter cette instruction
			.let r4 0xffff ; blanc
			;print "3"
			;print r4
			wmem r4 [r2] ; le pixel devient blanc
			end_refresh:
			snif r0 eq r11 ; si y=127
				jump refresh_x
		;refresh
		snif r1 eq r12
			jump refresh_y
		refresh

	jump loop_iter

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
endend:
jump 0
#include vfx.s

stack:
