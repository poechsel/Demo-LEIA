;; r6 : fire color
;; gives an int from a fire color
;; returns it in r6
;; erases r2,r8
.align16
int_fire:

copy r8 r6
.let r2 0
lsr r6 r8 12
add r2 r6 r2; on ajoute la valeur du premier nombre hexa de r6
lsl r6 r8 4
lsr r6 r6 11
add r2 r6 r2
copy r6 r2
return
