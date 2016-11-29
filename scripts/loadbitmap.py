from PIL import Image

im = Image.open("8x8font.png")
rgb_im = im.convert('RGB')


def convToWords(x):
    data = []
    for y in range(8):
        data += [sum([0 if list(rgb_im.getpixel((x+i, y))) == [255, 255, 255] else 1<<(7-i) for i in range(8)])]
    #data = [int(str(bin(d))[::-1][:-2], 2) for d in data]
    out = [data[1] << 8 | data[0], data[3] << 8 | data[2], data[5] << 8 | data[4], data[7] << 8 | data[6]]
    return [".word 0b" + str(bin(o))[2:] for o in out]



out_text = "font:\n"
for x in range(0, 1024, 8):
    for c in convToWords(x):
        out_text += c + "\n"

print(out_text)

