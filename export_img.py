from PIL import Image

im = Image.open("img_tunnel_2.png")
rgb_im = im.convert('RGB')


def to_word(v):
    v = (v[0]/256*(1<<5), v[1]/256*(1<<6), v[2]/256*(1<<5))
    v = list(map(int, v))
    v = v[0]<<11 | (v[1]<<6) | (v[2])
    return '.word 0x' + format(v if v >= 0 else (1 << 16) + v, '04x')

data = []
for y in range(64):
    for x in range(64):
        data.append(to_word(rgb_im.getpixel((x, y))))
out_text = "img_tunnel:\n"+"\n".join(data)

print(out_text)

