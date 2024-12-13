import numpy as np
from PIL import Image

def text_to_image(input_text_path, output_image_path):
    # Read the text file and process pixel values
    with open(input_text_path, 'r') as file:
        lines = file.readlines()
    
    pixel_values = []
    for line in lines:
        # Replace 'x' with '0' and split the line into values
        cleaned_line = line.replace('x', '0')
        pixel_values.append(list(map(int, cleaned_line.split())))
    
    # Convert the list to a numpy array
    img_array = np.array(pixel_values, dtype=np.uint8)

    # Extract the region excluding boundaries (first and last rows and columns)
    inner_region = img_array[1:-1, 1:-1]

    # Exclude 0s from the mean calculation
    valid_pixels = inner_region[inner_region > 0]
    threshold = valid_pixels.mean() if valid_pixels.size > 0 else 0
    
    # Apply the threshold: set pixels to 0 or 255
    binary_img_array = np.where(img_array > 127, 255, 0).astype(np.uint8)

    # Create an image from the numpy array
    img = Image.fromarray(binary_img_array)

    # Save the image
    img.save(output_image_path)
    print(f"Image saved as {output_image_path} {threshold}")

# Example usage
text_to_image('output_image_combined.txt', 'output_image_combined.jpg')
