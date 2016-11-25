;3 2 1 0 0 1 2 3
;2 6 5 4 4 5 6 2
;1 5 8 7 7 8 5 1
;0 4 7 9 9 7 4 0
;0 4 7 8 8 7 4 0
;1 5 8 7 7 8 5 1
;2 6 5 4 4 5 6 2
;3 2 1 0 0 1 2 3




;0,0 0,1 0,2 0,3
;1,0 1,1 1,2 0,2
;2,0 2,1 1,1 1,2
;3,0 2,0 1,0 0,0

.set r7 stack
.let r1 0
loopy:
	.let r0 0
	.let r8 4
	;add r2 r0 0
	;copy r13 r2
	
	sub r3 r1 r8
	snif r3 sgt -1
		xor r3 r3 -1
	.let r9 3
	sub r3 r9 r3
	copy r13 r3
	loopx:
		copy r3 r13
		.let r8 4
		
		sub r2 r0 r8
		snif r2 sgt -1
			xor r2 r2 -1
		.let r9 3
		sub r4 r9 r3
		snif r2 le r4
			jump swap
		jump end
		swap:
			;print "x"
			.let r4 3
			sub r4 r4 r3
			sub r4 r4 r2
			add r3 r3 r4
			add r2 r2 r4
			;jump bla
		end:
			;print "."

		bla:
		.set r9 offsets
		add r4 r9 r3
		copy r9 r4
		rmem r11 [r9]
		.set r9 triangle
		copy r5 r2
		add r5 r5 r11
		add r5 r5 r3
		add r5 r5 r9
		copy r9 r5
		rmem r6 [r9]
		print r6

		add r0 r0 1
		.let r8 8
		snif r0 eq r8
			jump loopx
		print "\n"
	add r1 r1 1
	.let r8  8

	snif r1 eq r8
		jump loopy
jump 0






triangle:
.word 0
.word 1
.word 2
.word 3
.word 4
.word 5
.word 6
.word 7
.word 8
.word 9

offsets:
.word 0
.word 3
.word 5
.word 6

stack:
