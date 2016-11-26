;; entrée :
;; r3 <- position du pixel du haut du glider
;; si r3 n'est pas dans l'écran, on définit r3 = 0xb0a2
;; efface r0, r3, r5, r10

;glider
.align16
glider:

.let r0 0xb000
.let r10 160
snif r3 le r0
	.let r3 0xb0a2

.let r5 0xffff
.let r3 0xb0a2

wmem r5 [r3]
add r3 r3 r10
add r3 r3 1
wmem r5 [r3]
add r3 r3 r10
wmem r5 [r3]
sub r3 r3 1
wmem r5 [r3]
sub r3 r3 1
wmem r5 [r3]
refresh 

return

#include life.s
