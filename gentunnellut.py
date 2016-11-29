f = open("testlut")
L = []
for l in f:
    L += [l]
w = [l.split() for l in L]


print("lut_tunnel_dists:")
for l in w[0]:
    l = int(l)
    print(".word {}".format(l))

print ("lut_tunnel_angles:")
for l in w[1]:
    l = int(l)
    print (".word {}".format(l if l > 0 else (1<<16) + l))
    
