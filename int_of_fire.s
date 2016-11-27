;; r6 : fire color
;; gives an int from a fire color
;; returns it in r6
;; erases r0, r1, r2
.let r6 0xfc00
.align16
int_fire:
copy r14 r6
.let r7 0
lsr r6 r14 12
add r7 r6 r7
lsl r6 r14 4
lsr r6 r6 11
add r7 r6 r7
copy r6 r7
return
