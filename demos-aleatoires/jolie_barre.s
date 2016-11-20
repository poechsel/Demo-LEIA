.set r7 stack

; 0xfc00 red
; 0x03c0 green
; 0x003f blue
.let r8 0xfc00
.let r9 0x03c0
.let r10 0x003f

; limites pour x et y
.let r11 159 ; x_max
.let r12 0 ; y_min

; to do :
; meta-converter .let -> two instructions letl leth
; done

.let r0 0xffff
call clearscr
refresh

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
		add r2 r2 1 
		.align16
		loop_x:
			add r0 r0 1
			add r2 r2 1
			
			.let r3 0
			copy r4 r2
			
			sub r4 r4 1
			call add_vital_energy
			
			add r4 r4 2
			call add_vital_energy
			
			add r4 r4 r12
			add r4 r4 1
			call add_vital_energy
			
			sub r4 r4 r12
			sub r4 r4 r12
			sub r4 r4 2
			call add_vital_energy
			
			add r4 r4 1
			call add_vital_energy
			
			add r4 r4 1
			call add_vital_energy
			
			rmem r4 [r2]
			
			.let r5 3
			snif r3 eq r5 ; si S=3, on rentre dans la boucle (cf. jump 4)
				jump 4
				.let r5 0
				snif r4 eq r5 ; snif la cellule était vivante
					wmem r9 [r2] ; nouvelle naissance
					jump end
			.let r5 2 
			snif r3 neq r5 ; si S=2, on rentre dans la boucle		
			    jump end
			.let r5 0
			snif r3 eq r5
				wmem r8 [r2]
			
			.align16
			end:
		 

			snif r0 eq r11		
				jump loop_x
		refresh
		snif r1 eq r12
			jump loop_y

;maintenant, on actualise, càd on fait mourir les rouges et vivre les verts

	.let r0 2
	.let r1 2
	.let r2 0xb080

	.align16
	refresh_y:
		add r0 r0 1
		.let r1 1
		add r2 r2 r11
		add r2 r2 1
		add r2 r2 1
		.align16
		refresh_x:
			add r1 r1 1
			add r2 r2 1
			
			rmem r3 [r2]
			snif r3 neq r8 ;est rouge
			.let r4 0
			wmem r4 [r2] ; meurt
			snif r3 neq r9 ;est vert
			.let r4 0xffff	
			wmem r4 [r2] ; vit
			
			snif r1 eq r12 ; si y=127
				jump refresh_x
				
		snif r0 eq r11
			jump refresh_y

	refresh
	jump loop_iter

.align16
add_vital_energy:
	; add pixel [r4]'s vital energy (which is 0 if black or green and 1 if white or red) to r3
	rmem r5 [r4]
	snif r5 neq r9
		letl r5 0
	snif r5 neq r8
		letl r5 1
	.let r6 0xffff
	snif r6 neq r6
		letl r5 1
	add r3 r3 r5
	return

#include vfx.s

stack:
