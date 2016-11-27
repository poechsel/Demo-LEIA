xor r0 r0 r0
call clearscr
refresh

letl r0 128
letl r1 20
letl r2 0
.set r3 msgline1
call putstr
letl r0 128
letl r1 20
letl r2 8
.set r3 msgline2
call putstr
letl r0 128
letl r1 20
letl r2 16
.set r3 msgline3
call putstr
letl r0 128
letl r1 20
letl r2 24
.set r3 msgline4
call putstr
letl r0 128
letl r1 20
letl r2 32
.set r3 msgline5
call putstr
letl r0 128
letl r1 20
letl r2 40
.set r3 msgline6
call putstr
letl r0 128
letl r1 20
letl r2 48
.set r3 msgline7
call putstr
jump 0


msgline7:
.string "  5----6"
msgline6:
.string " /|   /|"
msgline5:
.string	"2----3 |"
msgline4:
.string "| |  | |"
msgline3:
.string	"| 4--|-7"
msgline2:
.string "|/   |/ "
msgline1:
.string	"1----0  "

#include vfx.s
#include fonts_data.s
