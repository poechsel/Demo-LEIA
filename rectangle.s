;; draws a rectangle of r8 width and r9 heighth
;; starting from pixel (r1,r2)
;; of color r10
refresh 

.let r10 0xffff

.let r1 1
.let r2 126

.let r6 160

.let r8 2
.let r9 20

call pixel_xy
;; now r3 contains starting point
wmem r10 [r3]
refresh
.let r0 0 ; compteur
first_loop:
	add r0 r0 1
	add r3 r3 1
	wmem r10 [r3]	
	snif r0 eq r8
		jump first_loop
refresh
.let r0 0 ; compteur
main_loop:
	add r0 r0 1

	sub r3 r3 r8
	add r3 r3 r6
	
	wmem r10 [r3]

	add r3 r3 r8
	wmem r10 [r3]

	snif r0 eq r9
		jump main_loop
sub r3 r3 r8
add r3 r3 r6
wmem r10 [r3]

.let r0 0 ; compteur
last_loop:
	add r0 r0 1
	add r3 r3 1
	wmem r10 [r3]

	snif r0 eq r8
		jump last_loop
refresh
jump 0

#include pixel_xy.s
