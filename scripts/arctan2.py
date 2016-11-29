import math


def octantify(x, y, o):
    if y < 0:
        x = -x
        y = -y
        o += 4
    if x<=0:
        t = x
        x = y
        y = -t
        o+=2
    if x < y:
        t = y - x
        x = x + y
        y = t
        o += 1
    print(x, y)
    return (x, y, o)
def approxatan2(y, x):
    print(y, x)
    BRAD_PI = 1<<14
    if (y == 0):
        return 0 if x >= 0 else BRAD_PI
    fixShift = 15
    x, y, phi = octantify(x, y, 0)
    phi *= BRAD_PI/4;
    print(x, y)
    t = ((x<<fixShift) )//y
    t2 = -t * t >> fixShift
    print(t)

    dphi= 0x00A9
    dphi= 0x0390 + (t2*dphi>>fixShift)
    dphi= 0x091C + (t2*dphi>>fixShift)
    dphi= 0x0FB6 + (t2*dphi>>fixShift)
    dphi= 0x16AA + (t2*dphi>>fixShift)
    dphi= 0x2081 + (t2*dphi>>fixShift)
    dphi= 0x3651 + (t2*dphi>>fixShift)
    dphi= 0xA2F9 + (t2*dphi>>fixShift)

    return phi + (dphi*t >> (fixShift+3));

def mul16(x, y):
    return (x*y >> 8) & 0xffff
def approxinv(x):
    y0 = (3-x)//2
    print(mul16(y0, y0))
    y1 = (mul16(y0, (3-mul16(x, mul16(y0, y0))))//2)
    y2 = (mul16(y1, (3-mul16(x, mul16(y1, y1))))//2)
    y3 = (mul16(y2, (3-mul16(x, mul16(y2, y2))))//2)
    y4 = (mul16(y3, (3-mul16(x, mul16(y3, y3))))//2)
    y5 = (mul16(y4, (3-mul16(x, mul16(y4, y4))))//2)
    y6 = (mul16(y5, (3-mul16(x, mul16(y5, y5))))//2)
    y7 = (mul16(y6, (3-mul16(x, mul16(y6, y6))))//2)
    print (y0, y1, y2, y3, y4, y5, y6, y7)
    return y7
print(1/math.sqrt(0.5), approxinv(0x0080)/(1<<8))
