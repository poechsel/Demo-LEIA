.align16
life_tunnel:
	.push r15
	.let r0 0
	call clearscr
	.let r0 0xffff
	.let r1 0
	.let r2 0
	.let r3 65
	.let r4 65
	call fill

	.let r3 256 
	letl r14 0
	letl r13 0
	__life_tunnel_loop:
		.push r3
		; we play the life game only on a 64*64 grid
		.let r10 64; xmax
		.let r11 64; ymax
		.push r13
		.push r14
		call lifegame
		.pop r14
		.pop r13

		.set r3 img_tunnel
		.let r4 0xb000
		.let r2 128
		; copy the 64*64 region of the screen where their is the game of life to the image used by the tunnel
		__life_tunnel_cloopy:
			.let r1 0
			__life_tunnel_cloopx:
				.let r5 64
				snif r2 lt r5
					jump __life_tunnel_cnone
				snif r1 lt r5
					jump __life_tunnel_cnone
				rmem r0 [r4]
				wmem r0 [r3]
				add r3 r3 1
				__life_tunnel_cnone:
				.let r5 160
				add r4 r4 1
				add r1 r1 1
				snif r1 eq r5
					jump __life_tunnel_cloopx
			.let r5 128
			sub r2 r2 1
			snif r2 eq 0
				jump __life_tunnel_cloopy
		.push r15

		add r2 r13 1
		copy r13 r2
		call tunnel_effect
		.pop r15
		.let r0 0
		call clearscr
		.set r3 img_tunnel
		.let r4 0xb000
		.let r2 128
		; copy back the game of life to screen
		__life_tunnel_c2loopy:
			.let r1 0
			__life_tunnel_c2loopx:
				.let r5 64
				snif r2 lt r5
					jump __life_tunnel_c2none
				snif r1 lt r5
					jump __life_tunnel_c2none
				rmem r0 [r3]
				wmem r0 [r4]
				add r3 r3 1
				__life_tunnel_c2none:
				.let r5 160
				add r4 r4 1
				add r1 r1 1
				snif r1 eq r5
					jump __life_tunnel_c2loopx
			.let r5 128
			sub r2 r2 1
			snif r2 eq 0
				jump __life_tunnel_c2loopy
		.let r0 0xffff
		.let r1 64
		.let r2 0
		.let r3 64
		.let r4 64
		call line
		cend:
		.pop r3
		sub r2 r14 1
		.let r5 128
		snif r3 gt r5 
			copy r14 r2
		;jump 0
		sub r3 r3 1
		snif r3 eq 0
			jump __life_tunnel_loop
.pop r15
return
	


#include life.s
#include tunnel.s

