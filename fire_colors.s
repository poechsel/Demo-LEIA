; 0xfc00 red
; 0xff00 jaune
; 0xfc80 orange
; 0xfcc0 orange
.align16
color_fire:
;; r2 <- entier entre 0 (rouge) et 46 (jaune) en passant par l'orange
;; renvoie la couleur associée à cet entier, stockée dans r0

; considering .let r8 15 was called before
;.let r8 15

snif r2 le r8
	jump jaunes

lsl r0 r2 12
jump end_cf

jaunes:

.let r0 0xf000
sub r2 r2 r8
lsl r2 r2 7
or r0 r0 r2

end_cf:
return
