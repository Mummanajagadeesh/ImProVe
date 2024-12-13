import numpy as np
from PIL import Image

def text_to_image(input_text_path, output_image_path):

    with open(input_text_path, 'r') as file:
        lines = file.readlines()
    
    pixel_values = []
    for line in lines:
        # Replace 'x' with '0' and split the line into values
        cleaned_line = line.replace('x', '0')
        pixel_values.append(list(map(int, cleaned_line.split())))
    
    # Convert the list to a numpy array
    img_array = np.array(pixel_values, dtype=np.uint8)
    
    # Create an image from the numpy array
    img = Image.fromarray(img_array)
    
    # Save the image
    img.save(output_image_path)
    print(f"Image saved as {output_image_path}")

# Example usage
text_to_image('output_image_combined.txt', 'output_image_combined.jpg')
