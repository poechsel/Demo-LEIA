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
.let r11 0
loopy:
	.let r10 0
	.let r8 4
	;add r5 r10 0
	;copy r13 r5
	xor r3 r3 r3
	
	sub r6 r11 r8
	snif r6 sgt -1
		jump cond1
	jump end1
	cond1:
		xor r6 r6 -1
		add r3 r3 1
	end1:
	.push r3
	.let r8 3
	sub r6 r8 r6
	copy r9 r6
	loopx:
		.pop r3
		.push r3
		copy r6 r9
		.let r8 4
		
		sub r5 r10 r8
		lsl r3 r3 1
		snif r5 sgt -1
			jump cond2
		jump end2
		cond2:
			xor r5 r5 -1
			add r3 r3 1
		end2:
		lsl r3 r3 1
		.let r8 3
		sub r4 r8 r6
		snif r5 le r4
			jump swap
		jump end
		swap:
			;print "x"
			.let r4 3
			sub r4 r4 r6
			sub r4 r4 r5
			add r6 r6 r4
			add r5 r5 r4
			add r3 r3 1
			;jump bla
		end:
			;print "."

		bla:
		.set r8 offsets
		add r4 r8 r6
		copy r8 r4
		rmem r12 [r8]
		.set r8 triangle
		copy r4 r5
		add r4 r4 r12
		add r4 r4 r6
		add r4 r4 r8
		copy r8 r4
		rmem r1 [r8]
		
		and r4 r3 1
		.let r8 -16
		snif r4 eq 0
			jump tmp
		jump etmp
		tmp:
			sub r1 r8 r1
		etmp:
		lsr r3 r3 1
		and r4 r3 1
		.let r8 -32
		snif r4 eq 0
			sub r1 r8 r1
		lsr r3 r3 1
		and r4 r3 1
		snif r4 eq 0
			jump end3
		xor r1 r1 -1
		add r1 r1 1
		end3:

		print r1

		add r6 r10 1
		copy r10 r6
		.let r8 8
		snif r10 eq r8
			jump loopx
		print "\n"
	.pop r3
	add r6 r11 1
	.let r8  8
	copy r11 r6
	snif r11 eq r8
		jump loopy
jump 0






triangle:
.word -65520
.word -65523
.word -65525
.word -65527
.word -65520
.word -65524
.word -65526
.word -65520
.word -65525
.word -65520

;.word 0
;.word 1
;.word 2
;.word 3
;.word 4
;.word 5
;.word 6
;.word 7
;.word 8
;.word 9

offsets:
.word 0
.word 3
.word 5
.word 6

stack:
