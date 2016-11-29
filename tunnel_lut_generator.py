import math
import csv

h = 128
w = 128#160
dists = []
dists_ar = []
dist_compress = []
dist_deb = []
for y in range(h):
    if y <= h//2:
        dists_ar.append([])
        dist_deb.append([])
    for x in range(w):
        if x == w//2 and y == h//2:
            dists += [0]
            if x >= w//2 and x<h-y:
                dists_ar[-1].append(0)
        else:
            dists += [int(32* 64 / math.sqrt((x - w//2)**2 + (y - h//2) ** 2))  % 64]
            if x >= w//2 and x <h-y:
                dists_ar[-1].append(int(32* 64 / math.sqrt((x - w//2)**2 + (y - h//2) ** 2))  % 64)
        if x>=w//2 and y <= h//2 and x-w//2 >= y:
            dist_compress.append(dists[-1])
            dist_deb[-1].append(dists[-1])
"""
for d in dist_deb:
    print(d)
"""
angles = []
angles_ar = []
for y in range(h):
    if y <= h//2:
        angles_ar.append([])
    for x in range(w):
        if x == w//2 and y == h//2:
            angles += [0]
            if x >= w//2 and x < h- y :
                angles_ar[-1].append(0)
        else:
            angles += [int(0.5 * 64 * math.atan2(y - h//2, x - w//2) / 3.14159)]
            if x >= w//2 and x < h-y:
                angles_ar[-1].append(angles[-1])

def to_word(v):
  return '.word 0x' + format(v if v >= 0 else (1 << 16) + v, '04x')

arctan = [-1] * 1000
for y in range(1, 129):
    for x in range(1, 161):
        index = int(32*math.atan2(y-64/2, x-80/2)/3.1415)
        

#arctan = map(lambda x: to_word(c), arctan)
#dists = map(lambda x: to_word(x), dist_compress)
angles = map(lambda x: to_word(x), angles)

dists_ar = [d for l in dists_ar for d in l]
dists_ar = map(to_word, dists_ar)
angles_ar = [d for l in angles_ar for d in l]
angles_ar = map(to_word, angles_ar)

print("offset_tunnel")
s = 0
for i in range(63, 0, -1):
    print(".word {}".format(s))
    s += i

print("lut_tunnel_dists:")
print("\n".join(list(dists_ar)))
print("lut_tunnel_angles:")
print("\n".join(list(angles_ar)))

"""
for d in angles_ar:
    o = ""
    for x in d:
        if x <= 9:
            o += " "
        o += " " + str(x)
    print(o)
"""

"""
csvf = open("tunnellut.csv", "wb")
writ = csv.writer(csvf, delimiter = ' ', quoting = csv.QUOTE_MINIMAL)
for l in angles_ar:
    print(l, type(writ))
    writ.writerow(l)
"""



"""
s = 0
print("offset_tunnel:")
print(".word 0")
for i in range(31,0,-1):
    s += i
    print(".word {}".format(s))

print("lut_tunnel_dists:")
print("\n".join(dists))
"""
"""
print("lut_tunnel_angles:")
print("\n".join(angles))

"""
