import numpy as np
import math

A = np.linspace(0, 2 * math.pi, 256)
C = np.cos(A)

def to_word(c):
  v = int(round(c * 256))
  return '.word 0x' + format(v if v >= 0 else (1 << 16) + v, '04x')

file = open('ASM/cos.s', 'w')
file.write('cos:\n')
file.write('\n'.join(map(to_word, C)))

file.close()
