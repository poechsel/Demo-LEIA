;;we draw for x in [-2; .5] (increment of 4) and y in [-1.25, 1.25] (ie increment of 5)


;;parameters of refinment: r6 = 16 & r7 = 0x07
.align16
mandelbrot:
.push r15
.let r0 159
.let r2 128 ; r3 = 1.25
loop_x:
	.let r1 127
	.let r3 260 ; r2 = .5
	loop_y:
		.push r2
		.push r3
		.push r0
		.push r1
		copy r13 r3
		copy r12 r2
		xor r4 r4 r4 ;an
		xor r5 r5 r5 ;bn
		.let r6 31	 ;max nb of iter
		loop_iter:
			.push r6
			copy r11 r5
			copy r10 r4
			.push r4
			copy r0 r10
			copy r1 r10
			call multfloat
			.pop r4
			copy r8 r0
			add r4 r0 0
			.push r4
			copy r0 r11
			copy r1 r11
			call multfloat
			.pop r4
			copy r9 r0
			sub r4 r4 r0
			add r4 r4 r12 ;done with an

			.push r4
			.push r5
			copy r0 r10
			copy r1 r11
			call multfloat
			.pop r5
			.pop r4
			add r5 r0 0
			add r5 r5 r0
			add r5 r5 r13 ;done with bn

			;now compute the norm
			add r6 r9 0

			add r6 r6 r8
			.let r8 0x0400
			snif r6 gt r8
				jump iter_end

			letl r0 0xff
			.pop r6
						
			xor r0 r0 r0
			copy r0 r6
			lsl r0 r0 2
			.pop r2
			.pop r1
			
			.push r1
			.push r2
			call plotpx
			letl r6 1
			.push r6

			iter_end:
			.pop r6
			sub r6 r6 1
			snif r6 eq 0
				jump loop_iter
		;jump 0
			
		.pop r1
		.pop r0
		.pop r3
		.pop r2
		sub r1 r1 1
		sub r3 r3 4
		snif r1 eq -1
			jump loop_y
	sub r0 r0 1
	sub r2 r2 4
	snif r0 eq -1
		jump loop_x
.pop r15
return

#include vfx.s
#include arithmetics.s


