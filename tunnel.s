.set r7 stack

xor r0 r0 r0
.let r12 1
.let r13 1
.let r14 100
loop:
call image
;add r0 r13 1
;copy r13 r0
;add r0 r12 5
;copy r12 r0
snif r4 eq 0
	jump loop
jump 0

.align16
image:
.push r15
xor r0 r0 r0
call clearscr
.let r6 64
loopy:
	.let r5 64
	loopx:
		.let r8 64
		;print "---------"
		sub r0 r5 r8
		copy r1 r0
		call mul16
		copy r4 r2
		.let r8 80
		sub r1 r6 r8
		copy r0 r1
		call mul16
		add r0 r4 r2
		call sqrt
		;print r0
		lsl r0 r0 2 ;;to augment precision
		copy r1 r0
		.let r0 0x0400
		call div ;;we obtain a float with a precision of 8 bit 
		;print r2
		lsr r0 r0 3 ;bit of tricking here
	copy r2 r0
	;	lsl r0 r0 5
	;	lsr r0 r0 5
	;	lsl r0 r0 6
	;	lsr r0 r0 6
	;	lsl r0 r0 8
;	print r0
	; mask for modulo:


		;snif r0 gt 4
		;	jump __tunnel_end
		add r0 r0 r12
		.let r8 0x3f
		and r0 r0 r8
		;print r0



		;now, compute the index for the lut
		copy r3 r5
		copy r4 r3
;		lsl r3 r3 7
;		lsl r4 r4 5
		lsl r3 r3 6
;		add r3 r4 r3
		add r3 r3 r6

		;print r1
		.set r8 lut_tunnel_angles
		add r4 r8 r3
		copy r8 r4
		rmem r1 [r8]
		copy r2 r0

		lsl r3 r5 6
		add r3 r3 r6
		.set r8 lut_tunnel_dists
		add r4 r8 r3
		copy r8 r4
		rmem r2 [r8]
		copy r0 r2
		add r0 r0 r12
		.let r8 0x3f
		and r0 r0 r8
		;print r5
		;print r6
		;print r3
		;print r1
		;print r2

		;.let r8 0x3f
		;and r0 r0 r8
		;and r1 r1 r8
		add r1 r1 r13
		.let r8 0x3f
		and r1 r1 r8


		.set r8 img_tunnel
		copy r3 r0
		copy r4 r3
		lsl r3 r3 6
		add r3 r3 r1
		add r4 r8 r3
		copy r8 r4
		rmem r0 [r8]

		
		;copy r2 r0
		;copy r4 r0
		;lsl r0 r2 7
		;lsl r4 r4 5
		;add r0 r0 r4
		;add r4 r0 r1

		;add r4 r8 r0
		;copy r8 r4
		;rmem r0 [r8]

		
		;xor r0 r1 r2

		;copy r0 r1
		jump __tunnel_plot
		__tunnel_end:
		xor r0 r0 r0
		__tunnel_plot:
		copy r1 r5
		copy r2 r6
		call plotpx

		sub r5 r5 1
		snif r5 eq 0
			jump loopx
	sub r6 r6 1
	snif r6 eq 0
		jump loopy


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
stack:
