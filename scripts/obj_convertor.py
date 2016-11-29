t = "head"
file = open(t+".obj")
vertices = []
faces = []
v_n = []
f_n = []
normals = []
def to_word(c):
  v = int(round(c * 256))
  return '.word 0x' + format(v if v >= 0 else (1 << 16) + v, '04x')
for l in file:
    s = l.split()
    if s[0] == "v":
        vertices.append((float(s[1]), float(s[2]), float(s[3])))
    elif s[0] == "vn":
        v_n.append((float(s[1]), float(s[2]), float(s[3])))
    elif s[0] == "f":
        faces.append((int(s[1].split("/")[0]), int(s[2].split("/")[0]), int(s[3].split("/")[0])))
        f_n.append((int(s[1].split("/")[-1]), int(s[2].split("/")[-1]), int(s[3].split("/")[-1])))
for i_1, i_2, i_3 in f_n:
    i_1 -= 1
    i_2 -= 1
    i_3 -= 1
    normals.append(((v_n[i_1][0]+v_n[i_2][0]+v_n[i_3][0])/3, (v_n[i_1][1]+v_n[i_2][1]+v_n[i_3][1])/3,(v_n[i_1][2]+v_n[i_2][2]+v_n[i_3][2])/3)) 

vertices = [(to_word(a), to_word(b), to_word(c)) for a, b, c in vertices]
faces = [(".word {}".format(a-1), ".word {}".format(b-1), ".word {}".format(c-1)) for a, b, c in faces]
normals = [(to_word(a), to_word(b), to_word(c)) for a, b, c in normals]
out_file = t+"_points:\n"
for a, b, c in vertices:
    out_file += "\t{}\n\t{}\n\t{}\n".format(a, b, c)
out_file += t+"_transformed_points:\n\t.reserve {}\n".format(len(vertices)*2)
out_file += t+"_triangles:\n"
for a, b, c in faces:
    #out_file += "\t.word {}\n\t.word {}\n".format(hex(((a-1)<<6)+((b-1)&0b111>>3)), hex(((b&0b111)<<13) + c-1))
    out_file += "\t{}\n\t{}\n\t{}\n".format(a, b, c)
out_file += t+"_normals:\n"
for a, b, c in normals:
    out_file += "\t{}\n\t{}\n\t{}\n".format(a, b, c)
out_file += t+"_transformed_normals:\n\t.reserve {}\n".format(len(normals))

print(out_file)
