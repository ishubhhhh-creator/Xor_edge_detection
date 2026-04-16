import numpy as np
from PIL import Image, ImageEnhance
import os

inputfile = "edge_output.mem"
outputfile = "edge_result.png"

if not os.path.exists(inputfile):
    print(f"Error: Input file '{inputfile}' not found.")
    exit()

try:
    with open(inputfile, "r") as f:
        lines = [line.strip() for line in f if line.strip()]
    
    # .mem mei pixels 0 ya 1 hai 
    data = [list(map(int, i.split())) for i in lines]
    pixels = np.array(data, dtype=np.uint8)

    height,width = pixels.shape
    
    # png mei 0 se 255 
    # pixels ko 255 se step up kar rhe hai
    pixels = pixels * 255

    img = Image.fromarray(pixels, mode="L")
    img.save(outputfile)
    print(f"Success: {width}x{height} image saved as {outputfile}")

except Exception as e:
    print(f"Error processing file: {e}")