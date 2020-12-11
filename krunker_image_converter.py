import sys
import os
import numpy as np
import cv2

object_count = 0



def underscore_pad(s, n_chars):
    while (len(s) < n_chars):
        s += "_"
    
    return s


def bgr_to_rgb_hex(tuple):
    return "{:02x}{:02x}{:02x}".format(tuple[2], tuple[1], tuple[0])


def get_opacity(pixel):
    return pixel[3] / 255


# Processes a given column, merging adjacent identically-coloured pixels.
# Only 'row' is changed between recursive calls.
def process_column(img, row, col, fp):
    height = 1
    next_row = row - 1
    colour = bgr_to_rgb_hex(img[row][col])
    opacity = get_opacity(img[row][col])

    while next_row >= 0:
        if colour == bgr_to_rgb_hex(img[next_row][col]) and opacity == get_opacity(img[next_row][col]):
            height += 1
            next_row -= 1
        else:
            process_column(img, next_row, col, fp)
            break
    
    if (opacity == 0):
        return

    # 'global' brings the highest-scope variable of the same name into the
    # local scope. Changes will be carried over to the original variable.
    global object_count
    object_count += 1

    print('{"p":[%d,%d,0],"s":[1,%d,1],"l":1,"c":"#000000","e":"#%s","o":%lf,"t":6}' % (col, img.shape[0] - 1 - row, height, colour, opacity), end=",\n", file=fp)



if (len(sys.argv) != 2):
    print("Usage: %s <image path>" % os.path.basename(sys.argv[0]))
    exit()

img_path = sys.argv[1]
img = cv2.imread(img_path, cv2.IMREAD_UNCHANGED)
out_file = os.path.basename(img_path) + ".txt"
pixel_count = img.shape[0] * img.shape[1]

if (str(img.dtype) != "uint8"):
    print("Invalid image type")
    exit()

print(
    "%s\n"
    "Output directory:     %s\n"
    "Output file:          %s\n"
    "Pixels (max objects): %d\n"
    "Object limit:         3500 for non-verified players, 6000 for verified players\n"
    "\n"
    "This limit also applies when hosting maps, so verified players should stick to\n"
    "the non-verified limit if they want their maps to be hosted by non-verified players.\n"
    % (underscore_pad("Start", 80), os.getcwd(), out_file, pixel_count)
)

input("Press enter to continue: ")

with open(out_file, "w") as fp:
    fp.write("[")
    
    for col in range(img.shape[1]):
        process_column(img, img.shape[0] - 1, col, fp)
    
    fp.write('{"p":[0,0,0],"s":[10,10,10]}]')

print(
    "\n"
    "%s\n"
    "Object count:      %d\n"
    "Objects saved:     %d\n"
    "Compression ratio: %lf"
    "\n"
    "You'll see a 10x10 cube in the asset. This is to make sure it can be imported properly."
    % (underscore_pad("Completed", 80), object_count, pixel_count - object_count, pixel_count / object_count)
)


