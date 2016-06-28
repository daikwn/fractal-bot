# Julia fractal
# FB - 201003151
from PIL import Image
import sys
import numpy
import random

# drawing area (xa < xb and ya < yb)
xa = -2.0
xb = 1.0
ya = -1.5
yb = 1.5
maxIt = 256 # iterations
# image size
imgx = 512
imgy = 512
image = Image.new("RGB", (imgx, imgy))
# Julia set to draw
c = complex(0.21 * 2.0 - 1.0, 0.05 - 0.5)

for y in range(imgy):
    zy = y * (yb - ya) / (imgy - 1)  + ya
    for x in range(imgx):
        zx = x * (xb - xa) / (imgx - 1) + xa
        z = complex(zx, zy)
        for i in range(maxIt):
            if abs(z) > 2.0: break
            z = z * z + c
        r = i % 4 * 64
        g = i % 8 * 32
        b = i % 16 * 32
        image.putpixel((x, y), b * 65536 + g * 256 + r)

tmp1 = image.rotate(90)
tmp2 = tmp1.resize((imgx + 300,imgy + 300))
tmp3 = tmp2.crop((150,150,imgx + 150,imgy + 150))
tmp3.save("/tmp/julia.png")