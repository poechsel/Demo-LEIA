.set r7 stack
;jump currentbegin
.let r0 0
call clearscr
.let r0 0xffff
.let r1 20
.let r2 40
.let r3 1
.let r4 1
call fill
refresh

.let r0 0xf0ff
.let r1 102
.let r2 60
.let r3 150
.let r4 10
call fill
refresh

.let r0 0x00ff
.let r1 140
.let r2 110
.let r3 15
.let r4 100
call fill
refresh

.let r0 0x000f
.let r1 45
.let r2 65
.let r3 123
.let r4 78
call line
refresh


letl r0 0xFF
leth r0 0xFF
letl r1 1
letl r2 1
letl r6 60
letl r5 0
letl r14 104
leth r14 1
.let r11 0xffff
loop_circle:
	.let r6 60
	.set r4 lut_cos
	add r4 r4 r5
	rmem r4 [r4]
	copy r2 r4
	asr r2 r2 3
	add r2 r2 r6

	.set r4 lut_sin
	add r4 r4 r5
	rmem r4 [r4]
	copy r1 r4
	asr r1 r1 3
	add r1 r1 r6
	
	copy r3 r6
	copy r4 r6
	copy r10 r5
	.let r0 180
	sub r0 r11 r0
	copy r11 r0
	call line
	copy r5 r10

	and r1 r5 3
	snif r1 neq 0
		refresh
	add r5 r5 1
	snif r5 eq r14
		jump loop_circle


.let r0 120
call pause
refresh

.let r0 0xffff
call clearscr

.let r4 1
.let r0 0x0000
.let r1 10
.let r2 95
.set r3 text
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 85
.set r3 text2
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 75
.set r3 text3
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 65
.set r3 text4
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 55
.set r3 text5
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 45
.set r3 text6
call putstr
refresh
.let r0 0x0000
.let r1 10
.let r2 35
.set r3 text7
call putstr
refresh
.let r0 0xfc00
.let r1 30
.let r2 25
.set r3 text8
call putstr
refresh


.let r0 90
call pause

.let r0 0xff00
call clearscr
.let r0 5
call pause

xor r0 r0 r0

.let r13 0
.let r14 0
.let r0 1
.let r1 1
.let r4 80
call tunnel_effect_wrapper

.let r0 0xff00
call clearscr
.let r0 5
call pause
.let r13 0
.let r14 0
.let r0 4
.let r1 4
.let r4 60
call tunnel_effect_wrapper

.let r0 0xff00
call clearscr
.let r0 5
call pause
.let r13 0
.let r14 0
.let r0 8
.let r1 8
.let r4 40
call tunnel_effect_wrapper

.let r0 0xff00
call clearscr
.let r0 5
call pause
.let r13 0
.let r14 0
.let r0 16
.let r1 16
.let r4 20
call tunnel_effect_wrapper

.let r0 0xff00
call clearscr
.let r0 5
call pause
.let r13 0
.let r14 0
.let r0 24
.let r1 24
.let r4 20
call tunnel_effect_wrapper
print "end"

.let r0 0
call clearscr
refresh
call mandelbrot
refresh
.let r0 180
call pause

.let r3 0xb000
.let r6 6
mandelbrotwrapper_loop_mem:
	rmem r0 [r3]
	.let r2 0x0060
	snif r0 lt r2
		letl r0 -1
	snif r0 neq 0
		letl r0 -1
	.let r2 0xffff
	snif r0 eq -1
		letl r0 0
	;sub r0 r2 r0
	wmem r0 [r3]
	add r3 r3 1
	snif r3 eq 0
		jump mandelbrotwrapper_loop_mem
	refresh
mandeloop:
	.let r3 0xb000
	mandelbrotloopmem:
		rmem r0 [r3]
		letl r2 -1
		sub r0 r2 r0
		wmem r0 [r3]
		add r3 r3 1
		snif r3 eq 0
			jump mandelbrotloopmem
	refresh
	.let r0 5
	call pause
	sub r6 r6 1
	snif r6 eq 0
		jump mandeloop
;call glid_w
refresh
.let r0 5
call pause 
.let r3 210 
life_wrapper:
	.push r3
	.let r10 158; xmax
	.let r11 126; ymax
	call lifegame
	.pop r3
	sub r3 r3 1
	snif r3 eq 0
		jump life_wrapper


currentbegin:
call illuminati
call fire

jump 0




.align16
tunnel_effect_wrapper:
	__tunnel_effect_loop:
		.push r0
		.push r1
		.push r4
		.push r15
		call tunnel_effect
		.pop r15
		.pop r4
		.pop r1
		.pop r0
		add r2 r13 r0
		copy r13 r2
		add r2 r14 r1
		copy r14 r2
		sub r4 r4 1
		print r4
		snif r4 eq 0
			jump __tunnel_effect_loop
	return






.align16
tunnel_effect_wrapper:
	__tunnel_effect_loop:
		.push r0
		.push r1
		.push r4
		.push r15
		call tunnel_effect
		.pop r15
		.pop r4
		.pop r1
		.pop r0
		add r2 r13 r0
		copy r13 r2
		add r2 r14 r1
		copy r14 r2
		;add r0 r14 1
		;copy r14 r0
		;add r0 r13 4
		;copy r13 r0
		sub r4 r4 1
		print r4
		snif r4 eq 0
			jump __tunnel_effect_loop
	return

.align16
pause:
	add r0 r0 1
	__pause_loop:
		refresh
		sub r0 r0 1
		snif r0 eq 0
			jump __pause_loop
	return



text: 
	.string "Did you believe"
text2:
	.string "It was really the"
text3:
	.string "END?"
text4:
	.string "..."
text5:
	.string "It is only the "
text6:
	.string "BEGINNING!"
text7:
	.string "Please enter"
text8:
	.string "INFINITY"
text9:
	.string "What about a bit of"
text10:
	.string "MADNESS?"

#include fire.s
#include life.s
#include mandelbrot.s
#include mathlut.s
#include vfx.s
#include tunnel.s
#include illuminati.s

stack:
