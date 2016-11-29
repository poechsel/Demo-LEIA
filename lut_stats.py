f = open("img_tunnel.s")
lines = [l for l in f]
m = {}
for i, l in enumerate(lines):
    l = l.strip().split()[-1]
    if l not in m:
        m[l] = []
    m[l].append(i)

nb_inter = {k:0 for k in m}
for k in m:
    i = 0
    while (i < len(m[k])-1):
        if m[k][i+1]-m[k][i]>1:
            nb_inter[k] += 1
        i+=1
print(len(m))
for k in m:
    print (k, len(m[k]), nb_inter[k])
print(sum(nb_inter[k] for k in nb_inter)*3, len(lines))
