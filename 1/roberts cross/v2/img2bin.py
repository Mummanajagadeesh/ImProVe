from PIL import Image
import numpy as np

def image_to_text(input_image_path, output_text_path):

    img = Image.open(input_image_path).convert('L')  
    
    img_array = np.array(img)
    
    with open(output_text_path, 'w') as file:
        for row in img_array:
            file.write(" ".join(map(str, row)) + "\n")

image_to_text('input_image.jpg', 'input_image.txt')