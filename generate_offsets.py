s = 0
for i in range(6666664, 0, -1):
    s += i
    print(".word {}".format(s))
