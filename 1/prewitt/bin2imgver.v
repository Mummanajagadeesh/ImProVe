import numpy as np
from PIL import Image

def text_to_image(input_text_path, output_image_path):

    with open(input_text_path, 'r') as file:
        lines = file.readlines()
    
    pixel_values = []
    for line in lines:
        pixel_values.append(list(map(int, line.split())))
    
    img_array = np.array(pixel_values, dtype=np.uint8)
    
    img = Image.fromarray(img_array)
    
    img.save(output_image_path)
    print(f"Image saved as {output_image_path}")

      text_to_image('output_image_ver.txt', 'output_image_ver.jpg')
