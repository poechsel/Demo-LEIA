
;xor r0 r0 r0
;.let r13 1
;.let r14 1
;.let r4 1
;loop:
;call tunnel_effect
;add r0 r14 1
;copy r14 r0
;add r0 r13 4
;copy r13 r0
;.let r4 1
;snif r4 eq 0
;	jump loop
;jump 0

.align16
tunnel_effect:
	xor r3 r3 r3
	.push r15
	xor r0 r0 r0
	call clearscr
	.let r11 0
	__tunnel_effect_loopy:
		.let r10 0 
		.let r8 64
		xor r3 r3 r3
		sub r6 r11 r8
		snif r6 sgt -1
			jump __tunnel_effect_cond1
		jump __tunnel_effect_end1
		__tunnel_effect_cond1:
			xor r6 r6 -1
			add r3 r3 1
		__tunnel_effect_end1:
		.let r8 63
		sub r6 r8 r6
		copy r9 r6
		.push r3
		__tunnel_effect_loopx:
			.pop r3
			.push r3
			copy r6 r9
			.let r8 64
			sub r5 r10 r8
			lsl r3 r3 1
			snif r5 sgt -1
				jump __tunnel_effect_cond2
			jump __tunnel_effect_end2
			__tunnel_effect_cond2:
				xor r5 r5 -1
				add r3 r3 1
			__tunnel_effect_end2:
			lsl r3 r3 1
			.let r8 63
			sub r4 r8 r6
			snif r5 le r4
				jump swap
			jump __tunnel_effect_end
			swap:
				.let r4 63
				sub r4 r4 r6
				sub r4 r4 r5
				add r6 r6 r4
				add r5 r5 r4
				add r3 r3 1
			__tunnel_effect_end:
			

			;now, compute the index for the lut
			copy r0 r10
			lsl r0 r0 6
			add r0 r0 r11

			.set r8 lut_tunnel_angles
			add r0 r8 r0
			copy r8 r0
			rmem r1 [r8]

			;lsl r0 r10 6
			;add r0 r0 r11
			;.set r8 lut_tunnel_dists
			;add r0 r8 r0
			;copy r8 r0
			;rmem r2 [r8]
		
			
			.set r8 offset_tunnel
			add r4 r8 r6
			copy r8 r4
			rmem r12 [r8]
			.set r8 lut_tunnel_dists
			copy r4 r5
			add r4 r4 r12
			add r4 r4 r6
			add r4 r4 r8
			copy r8 r4
			rmem r2 [r8]


			.set r8 offset_tunnel
			add r4 r8 r6
			copy r8 r4
			.set r8 lut_tunnel_angles
			copy r4 r5
			add r4 r4 r12
			add r4 r4 r6
			add r4 r4 r8
			copy r8 r4
			rmem r1 [r8]

			and r4 r3 1
			.let r8 -16
			snif r4 eq 0
				sub r1 r8 r1
			lsr r3 r3 1
			and r4 r3 1
			.let r8 -32
			snif r4 eq 0
				sub r1 r8 r1
			lsr r3 r3 1
			and r4 r3 1
			snif r4 eq 0
				jump __tunnel_effect_end3
			xor r1 r1 -1
			add r1 r1 1
			__tunnel_effect_end3:

			


			add r2 r2 r13
			add r1 r1 r14
			.let r8 0x3f
			and r2 r2 r8
			and r1 r1 r8


			.let r8 64
			sub r3 r10 r8
			sub r4 r11 r8
			.push r1
			.push r2

			copy r0 r3
			copy r1 r3
			call mul16
			copy r5 r2
			copy r0 r4
			copy r1 r4
			call mul16
			add r3 r2 r5
			.let r8 121
			.pop r2
			.pop r1
			snif r3 ge r8
				jump __tunnel_effect_no_draw

			.set r8 img_tunnel
			lsl r2 r2 6
			add r2 r2 r1
			add r0 r8 r2
			rmem r0 [r0]
			;xor r0 r1 r2
			copy r1 r10
			.let r8 16
			add r1 r1 r8
			copy r2 r11
			call plotpx
			__tunnel_effect_no_draw:

			add r6 r10 1
			copy r10 r6
			.let r8 128
			snif r10 eq r8
				jump __tunnel_effect_loopx
		
		.pop r3
		add r6 r11 1
		copy r11 r6
		.let r8 128
		snif r11 eq r8
			jump __tunnel_effect_loopy
	.pop r15
	refresh
	return

.align16
sqrt:
	;;r0 the nb
	xor r1 r1 r1

	letl r2 1
	lsl r2 r2 14
	__sqrt_loop1:
		snif r2 gt r0
			jump __sqrt_l1end
		lsr r2 r2 2
		jump __sqrt_loop1
	__sqrt_l1end:

	__sqrt_loop2:
		snif r2 neq 0
			jump __sqrt_l2end
		add r3 r2 r1
		snif r0 sgt r3
			jump __sqrt_else
		sub r0 r0 r3
		lsr r1 r1 1
		add r1 r1 r2
		jump __sqrt_endif
		__sqrt_else:
		lsr r1 r1 1
			
		__sqrt_endif:
		lsr r2 r2 2
		jump __sqrt_loop2
	__sqrt_l2end:
copy r0 r1
return

#include lut_tunnel.s
#include img_tunnel.s
#include arithmetics.s
#include vfx.s
